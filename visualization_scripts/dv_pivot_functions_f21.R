# Data Visualization
# Fall 2021
# pivot functions.
# Prof. Robert A. Cooper


# Pivot wider v. pivot longer. 

# Sometimes you need data to be in "long form". 
# "Long form" means each column is truly one variable. 

# Data Visualization.
# Prof. Robert A. Cooper

# Data transformation: 'wide form' to 'long form'.
#

library(tidyverse)


library(readxl)


  
wiid # World Income Inequality Database. 
#https://www.wider.unu.edu/project/wiid-world-income-inequality-database

wiid <- read_excel(file.choose())

glimpse(wiid)
head(wiid)

# Gather turns data to long form, with each column representing a variable. 
# Is being deprecated. 
# Antonym function: spread.

# Certain types of visualizations and/or statistical treatments require long form, while others...
# require wide form. 

# Long form, conceptually, is "tidy" form, where each row is an observation, and each column a variable.

head(wiid)
glimpse(wiid)
dim(wiid)


# New version is pivot_longer. Same as former, gather.
# Antonym function: pivot_wider. Same as former, spread. 

wiid %>%
  pivot_longer(values_to = "perc_inc", names_to = "quintile", q1:q5) %>%
  select(country, year, gini_reported, quintile, perc_inc, everything()) %>%
  arrange(country, year)



