# Data Visualization
# Additional Geoms (+ %in% and case_when, flipping coordinates, etc.)
# ICPSR 2021
# Robert A. Cooper


# Introducing the %in% vector. 
# subset vector. 

letter_vect <- c("zz", "hh", sample(letters, 3))
letter_vect

letters # base R letters vector.
letter_vect # our subset vector. 

letters_df <- data.frame(alphabet = letters)
letters_df

# small vector 'in' large vector.

letter_vect %in% letters

# large vector 'in' small vector. 

letters %in% letter_vect

letters_df %>%
  filter(alphabet %in% letter_vect)

# case_when v. if/else. Conditional recoding. 

glimpse(movies)

# count function. Note: I said use the arrange function, but you don't have to!

movies %>%
  count(genres, color, sort = TRUE) 

movies %>%
  mutate(big_time = case_when(
    budget > mean(budget, na.rm = TRUE) ~ "big time",
    budget <= mean(budget, na.rm = TRUE) ~ "small fry",
    is.na(budget) ~ "LIARS!"
  )) %>% 
  filter(big_time == "LIARS!") %>%
  select(movie_title, big_time, budget)


# This is roughly equilvalent code, but with ifelse(). 

movies %>%
  mutate(money = ifelse(budget > 50000000, "big time", 
                        ifelse(budget > 25000000 & budget <= 50000000, "medium", "small fry"))) %>%
  select(money, everything()) %>%
  count(money)


movies %>%
  mutate(big_time = ifelse(budget > mean(budget, na.rm = TRUE), "big time", 
                           ifelse(budget <= mean(budget, na.rm = TRUE), "small fry",
                           ))) %>%
  select(big_time, everything())


##################################
## Geoms continued. 

# Adding text to a plot with geom_text. 

wiid %>%
  filter(country == c("Germany", "France", "Italy", "Spain", "Norway"), year == 2000) %>%
  group_by(country, year) %>%
  summarize(avg = (mean(gini_reported))) %>%
  ggplot(., aes(x = country, y = avg)) +
  geom_point() +
  labs(x = "Country",
       y = "Mean Gini Score") +
  geom_text(label = c("Germany", "France", "Italy", "Spain", "Norway"), nudge_y = 0.5) +
  theme_minimal() 

# Flipping coordinates. Let's repeat the prior problem, but add coord_flip(). 
# Not overly useful for this plot, but VERY useful for pointrange plots, 
# bar plots, and scatter plots over many units. 


wiid %>%
  filter(country == c("Germany", "France", "Italy", "Spain", "Norway"), year == 2000) %>%
  group_by(country, year) %>%
  summarize(avg = (mean(gini_reported))) %>%
  ggplot(., aes(x = reorder(country, avg), y = avg)) +
  geom_point() +
  labs(x = "Country",
       y = "Mean Gini Score") +
  geom_text(label = c("Germany", "France", "Italy", "Spain", "Norway"), nudge_y = 2) +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.y = element_blank())

# 

# Univariate plots: histograms and density plots. 

# A density plot is a kernel smoother. 
# Note the y-axis. 

wiid %>%
  ggplot(aes(x = gini_reported)) +
  geom_density(alpha = 0.3, fill = "blue", color = "white") +
  labs(x = "Gini Index Density",
       y = "UN Region",
       fill = "UN Region") +
  theme_minimal()

# A histogram is a very close cousin to the density plot.
# The continuous variable is chopped into bins. 

wiid %>%
  ggplot(aes(x = gini_reported)) +
  geom_histogram(alpha = 0.3, bins = 40, fill = "blue") +
  labs(x = "Gini Index Density",
       y = "UN Region",
       fill = "UN Region") +
  theme_minimal()

# We can convert the histogram into a proportional/density histogram.
# In this way, it is the discretized twin of the density plot. 

wiid %>%
  ggplot(aes(x = gini_reported, y = ..density..)) +
  geom_histogram(alpha = 0.3, bins = 40, fill = "blue") +
  labs(x = "Gini Index Density",
       y = "UN Region",
       fill = "UN Region") +
  theme_minimal()

# Bar chart. Simple bar plot. 

mtcars %>%
  ggplot(aes(x = factor(cyl), fill = factor(cyl))) +
  geom_bar() 

# Also simple bar plot, but with a variable/calculated y aesthetic. 
# Thus, default bar plot will not do. 
# We use either (a) bar plot with stat="identity" or (b) geom_col (same thing.)

mtcars %>%
  mutate(cyl_fact = factor(cyl)) %>%
  group_by(cyl_fact) %>%
  summarize(mean_mpg = mean(mpg, na.rm = TRUE)) %>%
  ggplot(aes(x = cyl_fact, y = mean_mpg, fill = cyl_fact)) +
  geom_col() 


# Flipped coordinates. VERY useful, depending on your data. 

diamonds %>%
  group_by(clarity) %>%
  summarize(mean_price = mean(price, na.rm = TRUE)) %>%
  ggplot(aes(x = clarity, y = mean_price, fill = clarity)) +
  geom_col() 

# Here's what the plot looks like flipped. 
# Now, let's clean it up a a bit. 

diamonds %>%
  group_by(clarity) %>%
  summarize(mean_price = mean(price, na.rm = TRUE)) %>%
  ggplot(aes(x = clarity, y = mean_price, fill = clarity)) +
  geom_col() + 
  coord_flip() 

### We can also reorder the data within the ggplot code.

diamonds %>%
  filter(clarity == "SI2") %>%
  summarize(avgprice = mean(price, na.rm = TRUE),
            maxprice = max(price, na.rm = TRUE))


diamonds %>%
  group_by(clarity) %>%
  summarize(mean_price = mean(price, na.rm = TRUE)) %>%
  ggplot(aes(x = reorder(clarity, mean_price), y = mean_price, fill = clarity)) +
  geom_col() + 
  coord_flip() 

# For clarity, 'IF' is the worst and `I1` is the best. 
# Interestingly now our color scheme makes less sense. What a choice!

#### 

# Bar chart, modified bar chart, and polar coordinates. 
# Pie chart = single stacked bar plot turned polar. Don't believe me? 
# Bar chart plus polar coordinates... 

mtcars %>%
  ggplot(aes(x = factor(cyl))) +
  geom_bar() +
  coord_polar(theta = "y")

##### Actual Pie chart. 

glimpse(mtcars)

mtcars %>%
  ggplot(aes(x = 1, fill = factor(cyl))) +
  geom_bar() +
  coord_polar(theta = "y") 

mtcars %>%
  ggplot(aes(x = 1, fill = factor(cyl))) +
  geom_bar() +
  coord_polar(theta = "y")

## Pie chart rotated. 
## The 'start' argument is based on radians.Trig circle!

mtcars %>%
  ggplot(aes(x = factor(1), fill = factor(cyl))) +
  geom_bar() +
  coord_polar(theta = "y",
              start =  pi)


## Pie charts rotated AND labeled by slice. 
## If you want to label your pie charts in ggplot2,
## by proportion/percent, at least, you'll have to quickly 
## mutate a new proportion/percent variable. 

pie1 <-  mtcars %>%
  ggplot(aes(x = factor(1), fill = factor(cyl))) +
  geom_bar() +
  coord_polar(theta = "y",
              start = pi) 

wiid %>%
  filter(incomegroup == "Low income") %>%
  group_by(region_un) %>%
  summarize(sumreg = n())

wiid %>%
  filter(incomegroup == "High income") %>%
  group_by(region_un) %>%
  summarize(sumreg = n())


mtcars2 <- mtcars %>%
  mutate(cylfact = factor(cyl)) %>%
  group_by(cylfact) %>%
  summarize(nn = n()) %>%
  ungroup() %>%
  mutate(prop = nn/sum(nn)*100,
         ypos = cumsum(prop)- 0.5*prop) %>%
  select(nn, prop, everything())

mtcars2   

mtcars2 %>%
  ggplot(aes(x = factor(1), fill = cylfact, y = prop)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(prop, 2), y = ypos, x = 1)) +
  coord_polar(theta = "y") 

### For two-panel plots. See also the 'cowplot' package

library(gridExtra)

# library(cowplot) 

grid.arrange(plot1, plot2, plot3, ncol = 2,
             top = "A Simple Grid Example") 

## Rose plot using the 'diamonds' data set. 

data("diamonds")
glimpse(diamonds) 

# What do we want here instead? First, we are changing theta to X.
# Second, the center angles are all the same,
# built off different categories of diamond color. 
# We now vary the plot by the length of the "petal". 

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


#######
# A ridgeline plot. A different way to look at density plots.

library(ggridges)

wiid %>%
  ggplot(aes(x = gini_reported)) +
  geom_density(alpha = 0.3) +
  labs(x = "Gini Index Density",
       y = "UN Region",
       fill = "UN Region") +
  theme_minimal()


wiid %>%
  ggplot(aes(x = gini_reported, fill = region_un)) +
  geom_density(alpha = 0.3) +
  labs(x = "Gini Index Density",
       y = "UN Region",
       fill = "UN Region") +
  theme_minimal()

wiid %>%
  ggplot(aes(x = q5, y = region_un, fill = region_un)) +
  geom_density_ridges(alpha = 0.4) +
  labs(x = "Gini Index Density",
       y = "UN Region",
       fill = "UN Region") +
  theme_minimal()


# The violin plot. A cousing to the box plot AND the density plot. 

wiid %>%
  ggplot(aes(x = region_un, y = gini_reported)) +
  geom_violin() +
  theme_minimal()


#####

# One way to do this is the gridExtra package. 
# Another useful package is the cowplot package. 

library(gridExtra)
library(cowplot)

# Let's make a couple of random plots. 

data("mtcars")

plot1 <- mtcars %>%
  mutate(cyl_fact = factor(cyl)) %>%
  group_by(cyl_fact) %>%
  summarize(avgmpg = mean(mpg, na.rm = TRUE)) %>%
  ggplot(aes(x = cyl_fact, y = avgmpg, fill = cyl_fact)) +
  geom_bar(stat = "identity") + # identical to geom_col
  theme_minimal()

plot2 <-  mtcars %>%
  mutate(cyl_fact = factor(cyl)) %>%
  ggplot(aes(x = 1, fill = cyl_fact)) +
  geom_bar() +
  coord_polar(theta = "y") +
  labs(title = "Dude, Check This Pie!") +
  theme_void() +
  theme(legend.position = "none",
        plot.title = element_text(size = 7,
                                  hjust = 0.5))

grid.arrange(plot1, 
             plot2, 
             ncol = 2,
             top = "Shared Title")

# That looks odd because of the aspect ratio of the two plots. 
# Let's change the widths of the two to see what happens. 

grid.arrange(plot1, 
             plot2, 
             ncol = 2,
             widths = c(1.9,1))


## What if we want to change positions? 
# I like the cowplot package for this. 

# cowplot and plot_grid have some decent options.

library(grid)

tt <- textGrob("Text \n Here") # grobs in the grid package. 

plot_grid(plot1, tt, NULL, plot2,
          rel_widths = c(3,1,1,1),
          rel_heights = c(3,1,1,1)) # From cowplot. 

plot_grid(plot1, tt, NULL, plot2,
          scale = c(1,2,1,3)) # From cowplot. 

# Insets. Also useful with cowplot. 

# The x and y parameters in the draw_plot are relative positioning. 
# So you'd want to toy with them to get the right
# position relative to the negative space of the main plot. 

ggdraw(plot1)

ggdraw(plot1) +
  draw_plot(plot2,
            x = .6,
            y = .65, 
            width = .25,
            height = .25)

#####







