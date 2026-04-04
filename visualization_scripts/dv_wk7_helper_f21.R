# Data Visualization

# Week 7 Helper Script

# Professor Robert A. Cooper

# GIFs using the magick package. 

# Magick. 

library(magick)

# First, you need to know import and export functions. 


monkeycat1 <- image_read(file.choose())
monkeycat2 <- image_read(file.choose())

monkeycat1
monkeycat2

# Working with images. Cropping. 

monkeycat1 %>%
  image_crop("150x350+230")

# You can scale down by pixels. 

image_scale(monkeycat1, "300")
#

# You can rotate. 

image_rotate(monkeycat1, 45)

# You can flip. 

image_flip(monkeycat1)


# We can manipulate the colors of our images through image_modulate.

image_modulate(monkeycat1, brightness = 80, saturation = 250, hue = 90)


# We can change base color with image_colorize.

image_colorize(youcan, color ="blue", opacity = 50)


# You can fill certain parts of the image, if you know pixel location. 

image_fill(monkeycat1, "blue", point = "+500+360", fuzz = 20) 

# You can add text wherever you like. 

bluetail <- image_fill(monkeycat1, "blue", point = "+500+360", fuzz = 20) %>%
  image_annotate(., "Hey, why is my tail blue??", size = 30, color = "white", location = "+100+55")


mc1 <- monkeycat1

mc_gif <- rep(mc1, 3)
mc_gif[2] <- bluetail
mc_gif


image_write_gif(mc_gif, "monkeycat.gif")


###############################################################################


img_doc <- "https://media.giphy.com/media/rULGb0wtaeAEM/giphy.gif" #Dr Emmett Brown. 
img_cat <-"https://media.giphy.com/media/mlvseq9yvZhba/giphy.gif" # cat.
img_bomb <- paste0("https://media.giphy.com/media/wFmJu7354Csog/giphy.gif")
img_bron <- paste0("https://media3.giphy.com/media/3o72F9VC4WjFDCPTag/",
                   "giphy.gif?cid=ecf05e470ceb6cd8542e8c243d0e0a2282c3390e5c",
                   "72fd17&rid=giphy.gif")

bron <- magick::image_read(img_bron)
bomb <- magick::image_read(img_bomb)
cat <- magick::image_read(img_cat)
doc <- magick::image_read(img_doc)

# Show image. Or reverse of image. 

doc
bomb # Let's say we want to rescale the size of the image. 
cat
bron

length(doc)
length(bron)


# image_crop(dunkbomb, "100x200")

bomb2 <- image_scale(bomb, "490x280")
bomb2.1 <- image_scale(bomb, "x288") 

bomb2
bomb2.1

# rev(img) is a fun option for reversing GIFs. 

rev(bron)
rev(bomb)

# LeBron plus bomb. 

dunkbomb <- c(bron, bomb2.1) # Combine two GIFs back-to-back.
dunkbomb

length(dunkbomb)

dunk_sub <- dunkbomb[1:5]



dunkbomb[30:34] <- image_annotate(dunkbomb[30:34], 
                                  "WOW", 
                                  size = 70,
                                  gravity = "southwest", 
                                  color = "green")

dunkbomb

# Dr. Emmett Brown plus a-bomb. 

docbomb <- c(rep(doc, 2), bomb)
docbomb # Some editing required here for dimensions. 

# To save your GIFs. 

image_write_gif(dunkbomb, "/Users/robertcooper/Desktop/dunkbomb.gif")

# There are a host of image transformations available to you. Way too many to show. 

cat

image_trim(cat, fuzz = 2)
image_scale(cat, "300")
image_charcoal(cat)


# GIFs broken down by frame, so you can do some neat pause and reverse stuff. 

length(bron)
bron

# Combo of slowing down, reversing, etc. Very Missy Elliott. 

bron[c(1:44, rep(c(rep(44, times = 30), 43:30, 
                   rep(30, times = 5), 31:43), 
                 times = 2), rev(1:44))]


bron[rep(1:44, each = 4)]

# You can slow down your GIF. 

bron[c(1:30, rep(31:44, each = 3))]

##########

library(tidyverse)
library(gganimate)

# Animated plots are really just flipping through slide decks. 
# To begin, set up a normal plot. 

# Pay attention to which variable you want to animate on. 
# Almost always, it is either a grouping variable or your time variable(s).

# Key elements to an animated plot:
# 1: transitions. These are the most fundamental to an animation. 
# 2: views. These allow your plotting window to change along with the data. 
# 3: shadows. Do you want traces or memory? Shadows are where you create those. 
# 4: enters and exits: How should the data enter the plot and leave the plot? 
# 5: easings: the movement during the transition, defined by some function. 


# The first thing you need is a transition. 

# some notes on transitions.
# transition_states # think like a faceting. Needs to be categorical.
# transition_reveal # time-based, but calculates intermediary values.
# transition_time # time-based, discrete time points. 
# transition_manual # discrete states, with no animation allowed.     

# transition_states example. 


glimpse(wiid)

wiid_anim1 <- wiid %>%
  filter(year > 2000 & region_un_sub == "Northern America") %>%
  group_by(country, year) %>%
  summarize(mean_gini = mean(gini_reported)) %>%
  ggplot(aes(x = year, y = mean_gini, color = country)) +
  geom_path() +
  geom_point(size = 0.5) +
  labs(x = "Year", y = "Gini Index") +
  theme(legend.position = "none") +
  transition_reveal(along = year) + 
  shadow_wake(wake_length = 0.2, size = 1, alpha = FALSE, colour = 'grey92') +
  theme_minimal()

# Then we feed it into the animate() function.

# Extra arguments determine the length of the animation and rendering. 

# Duration refers to total time to cycle. 
# nframes is the number of total frames (including, thus, copies)
# fps is the frames per second. 
# renderer is format. Default is gif. 

animate(wiid_anim1, nframes = 80, fps = 2, duration= 10) # too slow.

animate(wiid_anim1, nframes = 20, fps = 2, duration= 10) # about right.

animate(wiid_anim1, nframes = 20, fps = 2, duration= 20) # too slow. 

animate(wiid_anim1, nframes = 20, fps = 2, duration= 19) # too slow. 

animate(wiid_anim1, nframes = 20, fps = 2, duration= 11) # too slow. 

# Then we save the animated plot. 

anim_save("wiid_anim1.gif")

##### Let's take some of our old examples and animate them. 

data('mtcars')
head(mtcars)

ggplot(mtcars, aes(wt, mpg)) + 
  geom_point() +
  ggtitle('{closest_state}',
          subtitle = 'Frame {frame} of {nframes}') +
  
  # gganimate code starts here.
  
  transition_states(
    gear, # similar to a 'faceting' variable.
    transition_length = 2, # timing of transition.
    state_length = 1 # timing of state. 
  ) +
  enter_fly() + 
  exit_shrink() +
  ease_aes('sine-in-out') # sets the 'easing' (how to transition)


# There's something wrong with this plot, conceptually. Can you guess? 

# Technically speaking we shouldn't transition between different groups.
# Especially across units that cannot change from group to group.
# Can cars morph from one type of engine to another?
  # Technically, yes. But

# Your title can animate along with your plot. 

ggplot(mtcars, aes(wt, mpg, group = gear)) + 
  geom_point() +
  ggtitle('{closest_state}',
          subtitle = 'Frame {frame} of {nframes}') +
  theme_minimal() +
  
  # gganimate code starts here.
  
  transition_states(
    gear, # similar to a 'faceting' variable.
    transition_length = 2, # timing of transition.
    state_length = 1 # timing of state. 
  ) +
  enter_fly(loc = -1) + 
  exit_shrink() 


### Some options work better than others depending on grouping/animating.
# You wouldn't really use an easing with discrete groups, for example. 

mtcars %>%
  mutate(cyl_fact = factor(cyl)) %>%
  ggplot(aes(x = wt, y = mpg, color = cyl_fact)) +
  geom_point() +
  theme(legend.position = "none") +
  transition_states(cyl_fact,
                    transition_length = 2,
                    state_length = 1) +
  # enter_fly(x_loc = -1) +
  # exit_shrink() +
  theme_minimal()

anim_save("mtcars_anim.gif")

# Or, if you want to render the animation in a different way. 
# Save the animation plot as an object; then animate and render it.
# You can 'render' the animation in different formats. movie, gif, etc. 

mtcars %>%
  mutate(cyl_fact = factor(cyl)) %>%
  ggplot(aes(x = wt, y = mpg, color = cyl_fact)) +
  geom_point() +
  theme(legend.position = "none") +
  transition_states(cyl_fact,
                    transition_length = 2,
                    state_length = 1) +
  #ease_aes("cubic-in-out") +
  #shadow_wake(wake_length = 0.2, size = 1, alpha = FALSE, colour = 'grey92') +
  #enter_fly(x_loc = -1) +
  #exit_shrink() +
  theme_minimal()


plot1dat <- wiid %>%
  filter(year > 1990) %>%
  mutate(population2 = population/1000000,
         log_gdppc = log(gdp_ppp_pc_usd2011)) %>%
  group_by(country, year, region_un, population2) %>%
  mutate(mean_gini = mean(gini_reported, na.rm = TRUE),
         year2 = as.integer(year)) %>%
  summarize(mean_gini = mean(gini_reported, na.rm = TRUE),
            mean_loggdp = mean(log_gdppc, na.rm = TRUE))

head(plot1dat)


p1 <- plot1dat %>%
  ggplot(., aes(x = mean_loggdp, mean_gini, size = population2, color = region_un)) +
  geom_point(alpha = 0.7) +
  #scale_colour_manual(values = country_colors) +
  # scale_size(range = c(2, 12)) +
  # scale_x_continuous(trans = "log") +
  scale_y_continuous(limits = c(15, 65)) +
  # Here comes the gganimate specific bits
  #labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'Gini') +
  transition_states(year2,
                    transition_length = 50,
                    state_length = 100) +
  transition_time(year) +
  labs(title = 'Income Inequality and Per Capita Income in {frame_time}',
       y = "Gini Index", x = "Logged Per Capita Income",
       color = "UN Region", size = "Population \n in Millions") +
  ease_aes('sine-in-out') +
  theme_minimal()

anim1 <- animate(p1,
                 duration = 100,
                 fps = 10)
anim1
anim_save("wiid_anim.gif", anim1)

magick::image_write(anim1, "anim1.gif")

## ANIMATING PLOTS USING THE MAGICK LIBRARY ONLY.

# In the event that gganimate is not working, magick can still animate your plot. 

library(magick)

# Work the data as needed. 

wiid2 <- wiid %>%
  filter(year >= 2000) %>%
  group_by(country, year) %>%
  summarize(mean_gini = mean(gini_reported))

# Create an 'empty' magick image.
img <- image_graph(600, 340, res = 96)

# Split the data by the animated variable (often time for example)
data_list <- split(wiid2, wiid2$year) # Makes separate lists by year.
data_list # Check out what split did.

# lapply takes a function and applies it to a list.
out <- lapply(data_list, function(data){
  p <- ggplot(data, aes(x = country, y = mean_gini)) +
    geom_point() + ylim(20, 90) +
    ggtitle(data$year) +
    theme_minimal()
  print(p)
})

dev.off() # Closes the current plotting environment.

animation <- image_animate(img, fps = 2) # Animates image.
image_write(animation, "animate.gif") # Saves animation to a file.

# image_write will save to your current directory if you do not specify otherwise. 
