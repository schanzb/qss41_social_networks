# Data Visualization: 
# ICPSR 2021
# GIFs using the magick package. 
# Robert A. Cooper

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

