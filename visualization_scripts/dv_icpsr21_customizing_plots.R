# Data Visualization
# ICPSR 2021
# Robert A. Cooper

# Customization of plots. 

# I'm going to talk about a few ways you can customize plots. 

# 1. Grabbing plot build data.
# 2. Creating new variables for aesthetics.
# 3. Knowing plot functions so that you may trick them. 
# 4. Using things like inset plots, adding plots to plots. 
# ** For some additional geoms you are less likely to see, look at ggforce package. 
# ** https://ggforce.data-imaginist.com/reference/index.html

library(tidyverse)
library(cowplot)

################################################################################
# Grabbing plot-build data. 

# OECD line plots by year. Note: points underneath smoother would be an improvement.

wiid_smooth <- wiid %>%
  filter(year > 1945) %>%
  group_by(oecd, year) %>%
  summarize(med_gini = median(gini_reported)) %>%
  ggplot(., aes(x = year)) +
  # geom_line(aes(y = med_gini, color = oecd)) +
  geom_smooth(aes(y = med_gini, color = oecd), span = 0.5) +
  # geom_area(aes(y = med_gini, fill = oecd)) +
  theme_minimal()

wiid_smooth

# Let's say I want a geom_ribbon, like the W. Playfair plots. 

# Aesthetics: x OR y, then xmin/xmax or ymin/ymax. 

# Start with a basic smoother. Save the build data from ggplot. 

plot_dat <- ggplot_build(wiid_smooth)
class(plot_dat)  
is.list(plot_dat)

# Work with these data. 

plot_dat2 <- data.frame(plot_dat[[1]])
class(plot_dat2) # Just to double-check. 


# Could we just group these data and try to work with them?

plot_dat2

# Experiment: make new y's with y1 and y2 using pivot_wider?

plot_dat2 %>%
  pivot_wider(names_from = "group", values_from = "y") %>%
  select(`1`,`2`, everything()) 

# What about group_split?  Need the right purrr function here, methinks. 
# install.packages("rlist")
# library(rlist)

plot_dat_list <-plot_dat2 %>%
  group_split(group) 

# list.cbind() from 'rlist' works, but names of variables are identical. 

plot_dat2 %>%
  group_split(group) %>%
  list.cbind()

# How about a join? 

plot_dat3 <- full_join(plot_dat_list[[1]], plot_dat_list[[2]], by = "x")
plot_dat3

# Now we can create a geom_ribbon. 

plot_dat3 %>%
  ggplot(aes(x = x)) +
  geom_ribbon(aes(ymin = y.x, ymax = y.y), fill = "#420DAB", alpha = 0.7) +
  geom_ribbon(aes(ymin = ymin.x, ymax = ymax.x), fill = "#718ef2", alpha = 0.3) +
  geom_ribbon(aes(ymin = ymin.y, ymax = ymax.y), fill = "#718ef2", alpha = 0.3) +
  labs(title = "Gini Index Scores: OECD v. non-OECD",
       x = "Year", y = "Smoothed Median Gini Scores") +
  theme_minimal()

################################################################################
# Creating new variables for aesthetics. 
# Probably the most common way to make a plot `your own`. 

# Two examples from the assignments so far:

# 1: Labels for the scatterplot/dotplot of European countries flipped.

wiid_labs <- wiid %>%
  filter(region_un == "Europe") %>%
  group_by(country) %>%
  summarize(mean_gini = mean(gini_reported, na.rm = TRUE)) %>%
  mutate(lab_pos = ifelse(country == "Bosnia and Herzegovina", -.1,
                          ifelse(country == "Serbia and Montenegro", -.02,
                                 ifelse(country == "Macedonia, former Yugoslave Republic of", -.02, 0)))) 

wiid_labs %>%
  ggplot(., aes(x = reorder(country, mean_gini, na.rm = TRUE), y = mean_gini)) +
  geom_point() +
  geom_text(aes(label = country, y = mean_gini, hjust = lab_pos), size = 2.5, nudge_y = 0.5) +
  labs(x = "", y = "Average Gini Index Scores", 
       title = "Income Inequality in Europe") +
  coord_flip() +
  ylim(c(20,45)) +
  theme_minimal() +
  theme(axis.text.y = element_blank())


# 2: From our Nightingale plot!
# The trick (among others): Getting properly rotated angles.
# Potential solution: hard-coding each angle for each label in a vector. 
# Alternate solution: mutating a new variable that calculates the angle. 

# Just on the data front end. 

night2 <- night %>%
  pivot_longer(names_to = "death_type", 
               values_to = "deaths",
               Disease:Other) %>%
  select(death_type, deaths, everything()) %>%
  group_by(Date) %>%
  mutate(maxdeath = max(deaths),
         maxdeath2 = ifelse(Date < "1854-07-01", 150, maxdeath),
         maxdeath3 = ifelse(Date > "1855-08-01", 375, maxdeath)) %>%
  ungroup() %>% # Important after group_by and mutate. 
  mutate(rotz = rep(rotation, 2)) # rotation is a variable I created. 

################################################################################
# Tricking functions (like facet). 

# From our Assignment 3. 

wiid %>%
  filter(year >= 1940) %>%
  ggplot(aes(x = year, y = gini_reported, color = region_un)) +
  # geom_point(data = wiid[, c("year", "gini_reported")], aes(x=year, y=gini_reported), colour="grey", alpha = 0.4, size = 0.4) +
  geom_point(aes(color = region_un), alpha = 0.4, size = 0.3) +
  scale_color_manual(values=c("red","orange","blue", "green", "purple")) + 
  # geom_smooth() +
  scale_color_manual(values=c("#d3ed16","orange","blue", "green", "purple")) + 
  facet_wrap(~region_un) +
  xlab("Year") +
  ylab("Gini Coefficent") +
  labs(col = "Region") +
  ggtitle("Gini Coefficient Over Time for UN Regions") +
  theme_minimal()


################################################################################
# Using things like inset plots from cowplot. 

library(tidyverse)

pacdat <- data.frame(x = c(1, 1, 1, 1, 1, 2, 3, 4, 5, 6),
                     y = c(1, 2, 3, 4, 5, 1, 1, 1, 1, 1))

pacdot_plot <- pacdat %>%
  ggplot() +
  geom_point(aes(x = x, y = y), size = 5, color = "white") +
  expand_limits(x = 0, y = 0) +
  labs(title = "PAC MAN RULES!", color = "white") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5,
                                  color = "white",
                                  size = 20),
        plot.background = element_rect(fill = "#365096"))

pacdot_plot

pacman <- data.frame(y = c(rep("Pac", 13), rep("Man", 3)))

pacplot <- pacman %>%
  ggplot() +
  geom_bar(aes(x = 1, fill = y)) +
  coord_polar(theta = "y", 
              start = 1.6*pi) +
  scale_fill_manual(values = c("#365096", "#f6c704")) +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "transparent"),
        rect = element_rect(fill = "transparent"),
        panel.border = element_rect(fill = "transparent",
                                    color = "#4360ae"))

pacplot

# Using ggdraw to inset a plot. Super useful. 

ggdraw() +
  draw_plot(pacdot_plot) +
  draw_plot(pacplot, x = .33, y = -.26, scale = 0.25)


library(extrafont)


fonts()















