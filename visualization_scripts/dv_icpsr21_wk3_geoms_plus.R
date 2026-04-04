# Data Visualization
# Prof. Robert A. Cooper

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
 
 mtcars %>%
   ggplot(aes(x = 0, fill = factor(cyl))) +
   geom_bar() +
   coord_polar(theta = "y") 
 
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
                start =  2*pi)


## Pie charts rotated AND labeled by slice. 
## If you want to label your pie charts in ggplot2,
## by proportion/percent, at least, you'll have to quickly 
## mutate a new proportion/percent variable. 
 
pie1 <-  mtcars %>%
    ggplot(aes(x = factor(1), fill = factor(cyl))) +
    geom_bar() +
    coord_polar(theta = "y",
                start = pi) 

mtcars

mtcars %>%
   mutate(cylfact = factor(cyl)) %>%
   group_by(cylfact) %>%
   summarize(nn = n()) %>%
   ungroup() %>%
   mutate(prop = nn/sum(nn)*100) %>%
   select(nn, prop, cylfact)


 mtcars2 %>%
   ggplot(aes(x = factor(1), fill = cylfact, y = nn)) +
   geom_bar(stat = "identity") +
   geom_text(aes(label = paste0(round(prop, 2), "%"), x = 1),
                 position = position_stack(vjust = 0.5))  +
   coord_polar(theta = "y") +
   theme_void()
 
 ### For two-panel plots. See also the 'cowplot' package
 
 position_st
 
 library(gridExtra)
 # library(cowplot) 
 
 grid.arrange(plot1, plot2, plot3, ncol = 2,
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
   geom_bar(width = 1, stat = "identity")  +
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
  geom_bar(width = 1, stat = "identity", position = "identity", alpha = 0.7) +
  labs(title = "Color, Cut, and Carat: Diamonds",
       x = "Color (D (Best) to J (Worst)",
       y = " Average Carat",
       fill = "Cut") +
  coord_polar(theta =  "x") +
  theme_minimal()
# 
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
  ggplot(aes(x = carat, y = price)) +
  geom_hex(bins = 30) # Increase number of bins for fine tuning. 


## Waffle plot. As an alternative to pie charts.
## A strong alternative to polar coordinates. Lacks the perceptual issues of angles. 

library(waffle)
# install.packages("waffle")

# Set up basically as if you are about to make a pie chart. 

library(waffle)
data("diamonds")
glimpse(diamonds)

# remove.packages("waffle")
# install.packages("waffle")

install.packages("waffle", repos = "https://cinc.rud.is")
install_github("https://github.com/hrbrmstr/waffle")

diamonds %>%
  group_by(cut) %>%
  dplyr::summarize(nn = n()) %>%
  ungroup() %>%
  mutate(perc = nn/sum(nn)*100) %>%
  ggplot(aes(values = round(perc), fill = cut)) +
  geom_waffle()

diamonds2 <- diamonds %>%
  group_by(cut) %>%
  dplyr::summarize(nn = n()) %>%
  ungroup() %>%
  mutate(perc = round(nn/sum(nn)*100)) %>%
  select(cut, perc)

diamonds2

# Waffle package version of waffle is also currently operational. 

percs <- diamonds2$perc
names(percs)

# If you want to change the labels below, you can specify labels in 'parts'

waffle(parts = diamonds2$perc,
       title = "Percentage of Total Diamonds by Cut",
       colors = c("red", "orange", "yellow", "#1877f2", "#5551bd"))

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


