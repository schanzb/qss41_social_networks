# Data Visualization.
# Fall 2021

# Week 6 Helper Script.
# Prof. Robert A. Cooper

library(tidyverse)
library(ggwaffle)
library(ggridges)


#####

# geom_waffle.
# Install directly from the github using the 'devtools' package. 

devtools::install_github("liamgilbey/ggwaffle")

library(ggwaffle)

?waffle_iron

# This does not work. Factors get coerced to numerics by waffle_iron.

wafdat <- mtcars %>%
  mutate(factcyl = factor(cyl)) %>%
  waffle_iron(., aes_d(group = factcyl))

# Convert your group variable to character strings. 

wafdat2 <- mtcars %>%
  mutate(cyl2 = as.character(cyl)) %>%
  waffle_iron(., aes_d(group = cyl2))

wafdat2

wafdat2 %>%
  ggplot(., aes(x, y, fill = group)) +
  geom_waffle() +
  scale_fill_waffle() + # Waffle colors, ha. 
  labs(fill = "Cylinders",
       title = "Engine Cylinders in mtcars",
       x = "", y = "") +
  theme_waffle()

## One more example for you.

iris$Species <- as.character(iris$Species)
waffle_data <- waffle_iron(iris, aes_d(group = Species))

ggplot(waffle_data, aes(x, y, fill = group)) + 
  geom_waffle() + 
  coord_equal() + 
  scale_fill_waffle() +
  labs(fill = "Species") +
  theme_waffle() +
  theme(legend.position = "top")

## Ridgeline plot. 

library(ggridges)

#  Density plot without separating the y axis.

wiid %>%
  ggplot(aes(x = gini, fill = region_un)) +
  geom_density(alpha = 0.3) +
  labs(x = "Gini Index Density",
       y = "UN Region",
       fill = "UN Region") +
  theme_minimal()

# With separating the y-axis. 

wiid %>%
  ggplot(aes(x = gini, y = region_un, fill = region_un)) +
  geom_density_ridges(alpha = 0.4) +
  labs(x = "Gini Index Density",
       y = "UN Region",
       fill = "UN Region") +
  theme_minimal()

## Violin plot. Easy peasy. 

wiid %>%
  ggplot(aes(x = region_un, y = gini)) +
  geom_violin(aes(fill = region_un)) +
  labs(x = "UN Region",
       y = "Gini Score") +
  theme_minimal() +
  theme(legend.position = "none")

#########
## Functional stuff. 

# Making our own functions. Then using purrr. 


library(purrr) # v. 0.3.2 # NOTE PURRR HAVING ISSUES 10/21. 
library(repurrrsive)

## First function. 
# Start with arguments needed, then brackets. 
# Always print the things you want. 

func1 <- function(z){
  multiply <- z*7
  print(multiply)
}

func1(29)

myfunc <- function(a, b){
  avg <- (a + b )/ 2
  sqrtavg <- sqrt(avg)
  print(avg)
  print(sqrtavg)
}

myfunc(9, 4389)

# Just another example with different object types and data. 

basic <- function(data){
  datasub <- data %>%
    select(starts_with("q")) 
  print(datasub)
}

basic(wiid)

# The map() function from purrr. Vectorized functions applied to lists. 
# Especially powerful if you combine with your own functions. 

wdlist <- wiid %>%
  group_by(region_un) %>%
  group_split() # The tidyverse version of a base R split. 

class(wdlist); length(wdlist)

wdlist[1] # Check our first element. 

wdlist %>%
  map(basic)

# All map() functions either accept function, 
# formulas, 
# a character vector (used to extract components by name), 
# or a numeric vector (used to extract by position).

wdlist %>% # Base R function. There's also a group_split version (NEW) from tidyverse/dplyr. 
  map(~ lm(gini_reported ~ gdp_ppp_pc_usd2011, data = .)) %>%
  map(predict)


## Coding your own dice game or deck of cards!
#
## Simple function rolling two dice. 

roll <- function(){
  die <- 1:6
  dice <- sample(die, 2, replace = TRUE)
  print(dice) # Need to print the results you want to see!
  sum(dice) # Sum also produces a printed output. 
  output <- list(dice = dice, sumdice = sum(dice))
  print(output)
}

roll() # You need the parentheses to activate the function and run it. 

## Rewrite the above function, but add an argument. 

roll2 <- function(bones = 1:6){
  die <- 1:6
  dice <- sample(bones, 2, replace = TRUE)
  print(dice) # Need to print the results you want to see!
  sum(dice) # Sum also produces a printed output. 
}
roll2(bones = 1:10) 

# FOR MAP FUNCTION TO WORK, FUNCTION HAS TO APPLY TO A LIST. 
# LISTS CAN HAVE ANY OBJECT CLASS AS ELEMENTS. 

