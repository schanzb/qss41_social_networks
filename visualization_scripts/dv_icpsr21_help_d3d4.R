## Data Visualization: ICPSR 2021: Tidyverse and Basic Plotting.
## Prof. Robert A. Cooper

# Don't forget to load your packages!

library(tidyverse)

# In the first week, we did no plotting. In Week 2, we introduce plotting. 

# We introduce plotting via ggplot2 and the tidyverse.
# In addition, I will introduce a few more pieces of code for data transformation, etc.

# Some terms: aesthetics, mapping, themes, fill v. color, histograms,
# bar plots, line plots, etc. 


# First, an important bit of code for data work: the pipe operator

# Load the mtcars data. Already in base R. 

data("mtcars")
head(mtcars)

# Piping with magrittr (part of the Tidyverse).
# Piping replaces turducken-style coding.
# Instead of stuffing functions inside functions. 
# You'll see it below. 

# Here is some sad, turducken coding: 

summarize(group_by(mutate(mtcars, newwt = wt*1000, factcyl = factor(cyl)), factcyl), mean_wt = mean(wt))

# Here is some awesome, piped coding:

mtcars %>%
  mutate(newwt = wt*1000,
         factcyl = factor(cyl)) %>%
  group_by(factcyl) %>%
  summarize(mean_wt = mean(wt))

# The difference in the options above is pretty darned obvious.

# Tibbles. Just a different way to present a data frame or data table. 
# Compare mtcars to car_tibble just to see the difference. 

car_tibble <- as_tibble(mtcars); car_tibble

mtcars
car_tibble

#  Filtering. How do I know the inputs for the filter are working??

mtcars %>% # The '%>%' is the pipe operator. 
  filter(cyl == 6) # Subset the data to cars with 6 cylinders only. 

mtcars %>% # The '%>%' is the pipe operator. 
  filter(cyl == 6 & gear == 4) # Subset the data by 2 variables instead of 1. 

mtcars %>%
  filter(wt > 2.8)

# Arranging. This just changes the view of the data. 

mtcars %>%
  arrange(wt) # Arrange data in ascending order of weight in tons. 

mtcars %>%
  arrange(desc(wt))

# Mutate. 
# Mutate is how you create a new variable in the tidyverse.
# Mutate attaches the new variable to the end of the data frame/tibble.
# MUST: name new variable, then define it. See below. 

mtcars %>%
  mutate(mean_weight = mean(wt), # New variable created with mean weight of all cars. 
         fact_cyl = factor(cyl)) # New variable created turning 'cyl' into a factor variable. 


# Note: I did not save as a new object above. Thus, the code is temporary and unsaved.
# If I open mtcars again, I will not see these new variables. 

mtcars2 <- mtcars %>%
  mutate(mean_weight = mean(wt), # New variable created with mean weight of all cars. 
         fact_cyl = factor(cyl)) # New variable created turning 'cyl' into a factor variable. 

mtcars; mtcars2


# Select.
# Select subsets your data by choosing columns to keep/discard. 
# Select works with `tidyselect` functions in addition to variable names. 
# Select can also be used to rearrange your variables. 

mtcars2 %>%
  select(fact_cyl, wt, mpg) # Just subsetting by these variables. 

# We can also use tidyselect helpers. 

mtcars2 %>%
  select(contains("cyl")) # Subset using a tidyselect helper. Like a stringr for variable names.

mtcars2 %>%
  select(starts_with("m")) # Another tidyselect helper. 

# We can use the tidyselect helper everything() with select to rearrange the whole data frame.

mtcars2 %>%
  select(wt, mpg, fact_cyl, mean_weight, everything()) # Tell it which goes first, followed by everything. 

# group_by.
# group_by sets a quiet rule. 
# only a tibble will show you if a grouping rule has been set.
# Otherwise, you have to follow it with a summarize() or mutate() to see it work. 

mtcars2 %>%
  group_by(fact_cyl)

mtcars2 %>% # Without grouping, no line at top identifying number of groups.
  tibble()

# group_by will produce different results, depending on mutate v. summarize.

mtcars2 %>%
  group_by(fact_cyl) %>%
  mutate(mean_mpg = mean(mpg, na.rm = TRUE))

mtcars2 %>%
  group_by(fact_cyl) %>%
  summarize(mean_mpg = mean(mpg, na.rm = TRUE))

# group_by can group on multiple variables.

mtcars2 %>%
  group_by(fact_cyl, am) %>%
  summarize(mean_mpg = mean(mpg, na.rm = TRUE))


# summarize. 
# summarize() creates new variables, but it also kicks you out of the data frame/tibble.
# summarize creates a new tibble altogether.
# What does summarize bring forward into the new tibble?
# ONLY: (1) the variables you group on and (2) the new variables you create. 

mtcars2 %>%
  group_by(fact_cyl, am) %>%
  summarize(mean_mpg = mean(mpg, na.rm = TRUE),
            max_mpg = max(mpg, na.rm = TRUE),
            min_mpg = min(mpg, na.rm = TRUE))


##### PLOTTING AND GGPLOT2. 

# ggplot2 works differently from base R. 

# Key: THE AESTHETIC IS THE MOST IMPORTANT THING TO KNOW. 
# Key 2: THE GEOM IS THE NEXT MOST IMPORTANT THING TO KNOW. 

# The aesthetic connects the variation in your variables to you plot.
# It 'maps' a variable on to some element of your plot: size, color, line, etc. 
# If you make an arbitrary choice in a plot (line color = red, for example)...
# then that does NOT go inside the aesthetic. 
# ALL aesthetics are tied to variables. 

# On geoms. Geoms are all the geometric/physical ways our data can be expressed. 
# The list of possible geoms expands with each package added. 
# In this course, we will focus on a subset, but feel free to explore others.

# https://ggplot2.tidyverse.org/reference/

# Example 1: Simple plot of car weight against fuel efficiency.

# Simple scatterplot, ggplot-style.
# Kind of ugly, but just because there are so many features not yet discussed.
# In this workshop, we start simple and unadorned and slowly add features.

glimpse(mtcars)

mtcars %>%
  ggplot(., aes(x = wt, y = mpg)) +
  geom_point()

# Let's try a bar plot for fun. 
# Count up the number of cars with 4, 6, and 8 cylinders. 
# geom_bar does the count automatically for you!

mtcars %>%
  ggplot(aes(x = cyl)) +
  geom_bar()

# NOTE: X-axis looks a little odd. Why do you think that is? 

glimpse(mtcars)

# First real lesson in object classes!
# How do we fix this?

mtcars %>%
  ggplot(aes(x = factor(cyl))) +
  geom_bar()

# Line plot. 
# For these to be most useful, sometimes we might want to add a THIRD aesthetic. 

# The following example looks odd, on purpose. 

mtcars %>%
  ggplot(aes(x = wt, y = mpg)) +
  geom_line()

# Let's go back to scatterplot, but let's keep the third aesthetic. 
# This is probably the most sensible format for visualization.

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point()

# 'Faceting'. We could also break up the plot into multiple windows.
# There is little difference between facet_grid and facet_wrap.
# Won't really see it until you have more categories. 

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  #facet_grid( ~ cyl) +
  facet_wrap( ~ cyl)

# Histograms and frequency polygons. 
# Characterize individual continuous variables, but in buckets or bins. 
# The plot below will be more appropriate with larger datasets. 

mtcars %>%
  ggplot(aes(x = mpg)) +
  geom_histogram(bins = 10) +
  geom_freqpoly(bins = 10)

# GEOMS. General note on geoms. Wide variety. MANY not covered here. 

df1 <- data.frame(x = c(1, 2, 3),
                  y = c(13, 4, 17),
                  label = c("a", "b", "c"))

# Different geoms, same data. 
# Exercise: turn one geom on, and comment out others. Then rotate. 
# *Don't forget to comment out the plus signs as well, when needed.

df1 %>%
  ggplot(aes(x, y, label = label)) 
  geom_point() +
  # geom_text() #+
  # geom_area() +
  # geom_path() 
  # geom_polygon()

    
    
    
    
    
    
  
  
  
# Geom example 2. Data analysis and uncertainty. 
# When producing a point estimate for some data analysis...
# you also produce some estimate of uncertainty.
# To make a nice plot of these, you need 4 pieces of information: 
# 
# 
# There are a number of geoms for this: pointrange, errorbar, linerange, etc.
# 

df2 <- data.frame(x = c(1, 2, 3),
                  y = c(10, 4, 7),
                  ylow = c(9.5, 3.5, 6.5),
                  yhigh = c(10.5, 4.5, 7.5),
                  label = c("a", "b", "c"))


ggplot(df2, aes(x = x, y = y, ymin = ylow, ymax = yhigh)) +
  #geom_linerange() +
  geom_pointrange() 
  # geom_errorbar()



########################################################################


## New package: ggpattern!

devtools::install_github("https://github.com/coolbutuseless/ggpattern")


library(ggpattern)
library(tidyverse)


data("mtcars")

mtcars %>%
  ggplot(., aes(x = factor(cyl), pattern_fill = factor(am))) +
  geom_bar_pattern(pattern = 'stripe',
                   fill = 'white') +
  theme_minimal()
