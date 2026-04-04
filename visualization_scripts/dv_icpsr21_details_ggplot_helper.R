# Data Visualization
# ICPSR 2021
# Robert A. Cooper
# Details in ggplot2: scales, themes, labs, guides, etc. 


################################
## Labels. 
# One quick and easy way to clean labels is with the labs() function. 
# Another is the ggtitle() function, if you want to keep that separate. Usually no need.
# See first example below in scales. 

################################
## Scales. 

# Scales define our mapping of variables to aesthetics. 
# There is a scale for every aesthetic. You just don't see all of them. 

# All plots start with x (and y, usually) aesthetics.
# As a result, x (and y, usually) automatically get a scale.

# Think of the x-axis and the y-axis as legends for x and y. 
# All remaining aesthetics get an actual legend, unless you suppress it on purpose.


# General scale formula: scale_(aesthetic type here)_(scale/variable)

# Every plot has two position scales: x and y. 
# The remainder of scales depend on if you are mapping any other aesthetics. 
# Unless you are making some change to the scale of the x or y axis,
# ... you generally don't need to invoke a scale_x or scale_y.
# It can be useful in some cases, however. 

# Thus, the plot above can also be seen as: 

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  labs(color = "Cylinders") #+
#  scale_x_continuous() +  # Usually this is set quietly.
#  scale_y_continuous() +  # Usually this is set quietly. 
#  scale_color_manual(values = ...)

# The most likely scale you'd use above would be the scale_color_manual. 

# You could change your x and y axis labels in the scale. 

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  labs(color = "Cylinders") +
  scale_x_continuous("Hey, look at this label!") # Usually this is set quietly.

# In fact, you can do things like add math into your axis labels. Use quote().

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  labs(color = "Cylinders") +
  scale_x_continuous(expression(paste("Look at this math! ", pi^{x[i]})))

# The "values" argument is where you feed in your color scheme. 
# Don't ask me why the argument is isn't "color". I have yet to read a rationale.

# You can transform scale_x... or scale...y with a "trans" argument. 

data("diamonds")
glimpse(diamonds)

diamonds %>%
  ggplot(aes(x = carat, y = price, color = color)) +
  geom_point() +
  scale_y_continuous(trans = "log") +
  scale_x_continuous(trans = "log")

# The scale_x_... for continuous variables works very well with dates in 
# date object formats. Dates are continuous data with breaks and labels,
# and you would manipulate those arguments within a scale_x...

# scale_x_date or datetime would allow us to manipulate our date labels and breaks. 
# We will discuss this more next week when we talk a bit about the lubridate package.

##
# Using scales to set colors. 

# You can use scale_color_brewer for selecting from good preset palettes. 

# scale_..._brewer = discrete data.
# scale_..._distiller = continuous data.
# scale_..._fermenter = discretized continuous data. 

mtcars %>%
  mutate(cylfact = factor(cyl)) %>%
  ggplot(aes(x = wt, y = mpg, color = cylfact)) +
  geom_point() +
  labs(color = "Cylinders") +
  scale_color_brewer(type = "qual", palette = 6) +
  theme_minimal()

# There are other palettes in packages. One fun one is the wesanderson package. 
# The colorspace package also has some nice data-specific color palettes. 
# More generally, colorspace package has a lot of interesting functions related
# to color that I won't discuss today. 

library(colorspace)
colorspace::terrain_hcl() # For terrain-style colors. 2d density plots, raster, etc.
colorspace::rainbow_hcl() # For muted rainbow/spectral colors.
rainbow

# Be warned: the followed colors are in max intensity. Like Flaming Hot Cheetos.
# Generally don't plot colors this intense. This is a teaching exercise only.

# The rainbow palette below comes from base R grDevices. 

diamonds %>%
  ggplot(aes(x = carat, y = price, color = color)) +
  geom_point() +
  scale_color_manual(values = rainbow(7)) +
  theme_minimal()

# This terrain_hcl is from colorspace. 

diamonds %>%
  ggplot(aes(x = carat, y = price, color = color)) +
  geom_point() +
  scale_color_manual(values = terrain_hcl(7)) +
  theme_minimal()

# The diamonds data defaults to scale_color_viridis. 
# Why? Because it is the default scale for ordered factors. 

glimpse(diamonds)

diamonds %>%
  ggplot(aes(x = carat, y = price, color = color)) +
  geom_point() +
  scale_color_viridis_d() + # This is actually the default below. 
  theme_minimal()

diamonds %>%
  ggplot(aes(x = carat, y = price, color = color)) +
  geom_point() +
  theme_minimal()

# Let's pull in a package and see what it's palettes look like. 

install.packages("wesanderson")
library(wesanderson)

mtcars %>%
  mutate(cylfact = factor(cyl)) %>%
  ggplot(aes(x = wt, y = mpg, color = cylfact)) +
  geom_point() +
  labs(color = "Cylinders") +
  scale_color_manual(values = wes_palette("BottleRocket2")) +
  theme_minimal()

# As always, we can make our own palette!
# Recall: we don't need to set a scale unless we are overriding a default.

rc_pal <- colorRampPalette(c("#dd4f30", "#6098ff", "#ffd460"))

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  labs(color = "Cylinders") +
  # scale_color_manual(name = "Pretty colors!", labels = c("Very red!", "Kinda blue!", "Mellow Yellow!"), values = rc_pal(3)) + # making your own colors. 
  # scale_color_manual(name = "Pretty colors!", labels = c("Very red!", "Kinda blue!", "Mellow Yellow!"), values = rc_pal(3)) + # making your own colors. 
  #  scale_color_brewer(palette = "Purples") + # using a colorBrewer palette.
  # scale_x_continuous(quote(hat(e)^{2*e^pi})) +
  scale_x_continuous(breaks = c(2.5, 4.5), labels = c("a", "b")) +
  # scale_x_continuous(quote(hat(e)^{2*e^pi})) +
  theme_minimal() +
  guides(x = guide_axis(n.dodge = 2, angle = 90))

# Scale are also where you can change axes/legends in some ways.
# Titles for legends/axes
# Labels for the legend key.

################################
# Themes. Themes control many of the details of your plots. 

# Base ggplot has a gray background, variable-based labels.

# "Themes" allow you to control many, many details about
# the plotting environment. ELements NOT related to data. 

# There are many based themes in R. Including theme_minimal(), the best!
# https://ggplot2.tidyverse.org/reference/ggtheme.html

# You can take a base theme and manipulate and make it your own. 
# Start with a canned theme line, like theme_minimal().
# 

# Note: if there is negative space available for a legend, might be wise to use it. 

# The difference between + and %+replace%. 


mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 0.5) +
  labs(title = "Car Fuel Efficiency by Weight", 
       color = "cylinders") +
  theme_minimal() %+replace%
  theme()

theme_frankenstein <- theme(axis.title = element_text(color = "red"),
                            plot.title = element_text(family = "Courier"),
                            axis.text.x = element_text(color = "blue"),
                            axis.text.y = element_text(color = "orange"),
                            axis.ticks.length.x = unit(7, "mm"),
                            axis.ticks.length.y = unit(3, "mm"),
                            panel.background = element_rect(fill = "#e8c8ff"),
                            panel.grid.major = element_line(size = .5, color = "gray95"),
                            panel.grid.minor = element_line(size = .3, color = "gray95"),
                            legend.text = element_text(size = 6),
                            legend.key = element_rect(fill = "white", size = 0.3),
                            legend.title = element_text(size = 6),
                            legend.position = c(.7, .7),
                            legend.background = element_rect(fill = "#e8c8ff"),
                            legend.box.background = element_rect(color = "blue"),
                            legend.key.size = unit(1, "mm"))

# https://ggplot2.tidyverse.org/reference/theme.html

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 0.5) +
  labs(title = "Car Fuel Efficiency by Weight", color = "CYLINDERS") +
  theme_frankenstein +
  theme_set(best)

###############
# 'Faceting'. We could also break up the plot into multiple windows.
# There is little difference between facet_grid and facet_wrap.
# Won't really see it until you have more categories. 
# facet_wrap doesn't allow NA panels, but facet_grid does. 
# Generally, stay with facet_grid. 

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  facet_grid( ~ cyl) 

# You can facet on two variables at once, for additional grouping.  

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  facet_grid(am ~ cyl) 

# It is worthwhile to switch the faceting variables to see if the resulting 
# plot is more intuitive. 

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  facet_grid(cyl ~ am)

# Investigate some of the facet arguments. 
# You can free up the y-axis scales. 
# Be careful. Rarely a good idea. 

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  facet_grid(cyl ~ am, 
             scales = "free") # How does this look to you? 

# Facets can get a bit complicated. You can facet on three variables. 

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  facet_grid(vs + am ~ gear, margins = "vs")


# Facets have some new functionality. They can now work with the vars(function).
# This can be useful if the variables have labels/text. Then the facets will
# already be named correctly. 

mtcars %>%
  ggplot(aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  facet_grid(rows = vars(factor(cyl)),
             cols = vars(am))



############################################################################

