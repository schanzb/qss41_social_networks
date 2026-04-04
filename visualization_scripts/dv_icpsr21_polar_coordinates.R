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
 
pie1 <-  mtcars %>%
    ggplot(aes(x = factor(1), fill = factor(cyl))) +
    geom_bar() +
    coord_polar(theta = "y",
                start = pi) 

mtcars2 <- mtcars %>%
   mutate(cylfact = factor(cyl)) %>%
   group_by(cylfact) %>%
   summarize(nn = n()) %>%
   ungroup() %>%
   mutate(prop = nn/sum(nn)*100) %>%
   select(nn, prop, everything())


 mtcars2 %>%
   ggplot(aes(x = factor(1), fill = cylfact, y = nn)) +
   geom_bar(stat = "identity") +
   geom_text(aes(label = paste0(round(prop, 2), "%"), x = 1),
                 position = position_stack(vjust = 0.5)) +
   coord_polar(theta = "y", start = 1) +
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
  geom_bar(width = 1, stat = "identity", position = "identity", alpha = 0.4) +
  labs(title = "Color, Cut, and Carat: Diamonds",
       x = "Color (D (Best) to J (Worst)",
       y = " Average Carat",
       fill = "Cut") +
  coord_polar(theta =  "x") +
  theme_minimal()
# 

# Just for fun, we can glimpse into the future of the course...

library(gganimate)

plot3 +
   transition_states(color)

# We can also keep the states shown. 

plot3 +
   transition_manual(color,
                     cumulative = TRUE)


############# transition_filter. 
# Data = iris


data("iris")

anim <- ggplot(iris, aes(Petal.Width, Petal.Length, colour = Species)) +
   geom_point() +
   transition_filter(
      transition_length = 2,
      filter_length = 1,
      Setosa = Species == 'setosa',
      Long = Petal.Length > 4,
      Wide = Petal.Width > 2
   ) +
   ggtitle(
      'Filter: {closest_filter}',
      subtitle = '{closest_expression}'
   ) +
   enter_fade() +
   exit_fly(y_loc = 0)

animate(anim)

# result of the exit function)

anim2 <- ggplot(iris, aes(Petal.Width, Petal.Length, colour = Species)) +
   geom_point() +
   transition_filter(
      transition_length = 2,
      filter_length = 1,
      Setosa = Species == 'setosa',
      Long = Petal.Length > 4,
      Wide = Petal.Width > 2,
      keep = TRUE
   ) +
   ggtitle(
      'Filter: {closest_filter}',
      subtitle = '{closest_expression}'
   ) +
   exit_recolour(colour = 'grey') +
   exit_shrink(size = 0.5)

animate(anim2)
    