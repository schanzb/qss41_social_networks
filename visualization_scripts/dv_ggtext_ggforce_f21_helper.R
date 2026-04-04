# Data Visualization.
# Fall 2021

# Prof. Robert A. Cooper

# Updating some of our plot details. Discussing differences. 

library(ggtext) # More details available for text labels. 
library(ggforce) # General added stuff to ggplot2.
library(ggdist) # To show some new distribution plots. 

# An updated scatterplot of mtcars data using ggtext and ggforce. 


data("mtcars") 

mtcars %>%
  mutate(cylfact = factor(cyl)) %>%
  ggplot(aes(x = wt, y = mpg, color = cylfact)) +
  geom_point() +
  # geom_richtext(aes(label = cylfact)) +
  geom_mark_ellipse(aes(fill = cylfact, label = cylfact)) + # Shape can vary. 
  labs(x = "Weight", y = "Fuel Efficiency (Miles Per Gallon",
       title = "Weight and Fuel Efficiency by Car Cylinders") +
  expand_limits(x = c(1,6)) +
  theme_minimal() +
  theme(legend.position = "plot")
