# Data Visualization
# Prof. Robert A. Cooper

# Fall 2021. 

# Polar Coordinates.

# Polar coordinates allow us to make pie charts, coxcomb/rose plots, and other circle-oriented plots. 

# Ultimately, the first concept for polar coordinates is 'theta'.
# Theta represents the variable that will be tied to the angles created at the center of the circle. 

# For our purposes in ggplot2, that will be either 'x' or 'y'.

library(tidyverse)
 
 # ggplot2's coord_polar. 
 
 # We need to know 'theta'. Is X or Y going to inform the angles from the center?
 
 # Pie chart = single stacked bar plot turned polar. Don't believe me? 
 
data("mtcars")
glimpse(mtcars)
 
# Bar chart.
 
 mtcars %>%
   ggplot(aes(x = factor(cyl), fill = factor(cyl))) +
   geom_bar() 
 
 mtcars %>%
    mutate(cyl_fact = factor(cyl)) %>%
    group_by(cyl_fact) %>%
    summarize(mean_mpg = mean(mpg, na.rm = TRUE)) %>%
    ggplot(aes(x = cyl_fact, y = mean_mpg, fill = cyl_fact)) +
    geom_col() 
 
# Bar chart plus polar coordinates... 
 
 mtcars %>%
   ggplot(aes(x = factor(cyl))) +
   geom_bar() +
   coord_polar(theta = "y")
 
 ##### Actual Pie chart. 
 # To create our pie chart we rearrange the aesthetics a bit. 
 
 
 mtcars %>%
   ggplot(aes(x = 0, fill = factor(cyl))) +
   geom_bar() +
   coord_polar(theta = "y") 

# Note: the constant has no real meaning here. Just meant to be a constant.  
  
 mtcars %>%
    ggplot(aes(x = 5, fill = factor(cyl))) +
    geom_bar() +
    coord_polar(theta = "y")
 
## Pie chart rotated. 
## The 'start' argument is based on radians.
 
 mtcars %>%
    ggplot(aes(x = factor(1), fill = factor(cyl))) +
    geom_bar() +
    coord_polar(theta = "y",
                start =  pi)


## Pie charts rotated AND labeled by slice. 
## If you want to label your pie charts in ggplot2,
## by proportion/percent, at least, you'll have to quickly 
## mutate a new proportion/percent variable. 
 
pie1 <- mtcars %>%
    ggplot(aes(x = factor(1), fill = factor(cyl))) +
    geom_bar() +
    coord_polar(theta = "y",
                start = pi) 

pie1

mtcars2 <- mtcars %>%
   mutate(cylfact = factor(cyl)) %>%
   group_by(cylfact) %>%
   summarize(nn = n()) %>%
   ungroup() %>%
   mutate(prop = nn/sum(nn)*100) 


 pie2 <- mtcars2 %>%
   ggplot(aes(x = factor(1), fill = cylfact, y = nn)) +
   geom_bar(stat = "identity") +
   geom_text(aes(label = paste0(round(prop, 2), "%"), x = 1),
                 position = position_stack(vjust = 0.5)) +
   coord_polar(theta = "y", start = 1) +
   theme_void()
 
 ### For two-panel plots. See also the 'cowplot' package
 
 # library(cowplot) 
 library(gridExtra)

 
 grid.arrange(pie1, pie2, ncol = 2,
              top = "A Simple Grid Example") 
 
## Rose plot using the 'diamonds' data set. 

data("diamonds")
glimpse(diamonds) 

?diamonds # For further info on data. 

# What do we want here instead? First, we are changing theta to X.
# Second, the center angles are all the same,
# built off different categories of diamond color. 
# We now vary the plot by the length of the "petal". 

# Stacked version of roseplot. 

diamonds %>%
   group_by(cut, color) %>%
   summarize(avgcarat = mean(carat, na.rm = TRUE)) %>%
   ggplot(aes(x = color, y = avgcarat, fill = cut)) +
   geom_bar(width = 1, stat = "identity") +
   labs(title = "Color, Cut, and Carat: Diamonds",
        x = "Color (D (Best) to J (Worst)",
        y = " Average Carat",
        fill = "Cut") +
   coord_polar(theta =  "x") +
   theme_minimal()


# Unstacked version of roseplot. 

diamonds %>%
  group_by(cut, color) %>%
  summarize(avgcarat = mean(carat, na.rm = TRUE)) %>%
  ggplot(aes(x = color, y = avgcarat, fill = cut)) +
  geom_bar(width = 1, stat = "identity", position = "identity", alpha = 0.8) +
  labs(title = "Color, Cut, and Carat: Diamonds",
       x = "Color (D (Best) to J (Worst)",
       y = " Average Carat",
       fill = "Cut") +
  coord_polar(theta =  "x") +
  theme_minimal()


########################

##############################3

# hexbin plots. 
# These are two-dimensional density plots. 
# The bins are not bars or squares, but hexagons. 

# When are they appropriate? Two continuous variables. 

data("diamonds")
glimpse(diamonds)

# A hexbin is a two-dimensional histogram. 
# Hex bins. COULD USE BETTER DATA HERE. 


diamonds %>%
   ggplot(aes(x = log(carat), y = log(price))) +
   geom_hex(bins = 30) # Increase number of bins for fine tuning. 

## 2D density plot. 
## This works for two continuous variables. 

data("diamonds")
glimpse(diamonds)


diamonds %>%
   ggplot(aes(x = carat, y = price)) +
   geom_density2d() +
   theme_minimal()

# There's actually an underlying stat_... for every geom. 
# It can be useful sometimes. 

diamonds %>%
   ggplot(aes(x = carat, y = price)) +
   stat_density2d(aes(fill = stat(level)), geom = "polygon") +
   theme_minimal()

# Less useful is the 2d_filled, which fills the entire data space. Like a raster. 

diamonds %>%
   ggplot(aes(x = carat, y = price)) +
   geom_density2d_filled() +
   theme_minimal()

################################################################################
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

library(readxl)

wiid <- read_excel(file.choose()) 

wiid_smooth <- wiid %>%
   filter(year > 1945) %>%
   group_by(oecd, year) %>%
   summarize(med_gini = median(gini)) %>%
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

plot_dat2

# Experiment: make new y's with y1 and y2 using pivot_wider?

plot_dat2 %>%
   pivot_wider(names_from = "group", values_from = "y") %>%
   select(`1`,`2`, everything()) # Doesn't work because. 

# What about group_split?  Need the right purrr function here, methinks. 
# install.packages("rlist")
# library(rlist)

plot_dat_list

plot_dat_list <-plot_dat2 %>%
   group_split(group) 

# list.cbind() from 'rlist' works, but names of variables are identical. 

library(rlist)

plot_dat2 %>%
   group_split(group) %>%
   list.cbind()

# How about a join? 

plot_dat3 <- full_join(plot_dat_list[[1]], plot_dat_list[[2]], by = c("x"))
plot_dat3

glimpse(plot_dat3)

# Now we can create a geom_ribbon. 

plot_dat3 %>%
   filter(x < 2000) %>%
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

library(tidyverse)

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


################################################################################
# Using things like inset plots from cowplot. 

library(tidyverse)
library(cowplot)

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















