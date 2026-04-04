# Data Visualization: 
# Fall 2021
# Introduction to geographic data and mapping. 
# Professor Robert A. Cooper

# MAPPING: ALL ABOUT POINTS, LINES, AND POLYGONS. 

library(tidyverse) # for data work and plotting. 
library(sf) # for working with 'simple feature' format. 

library(rgdal) # For reading in sp objects. 
library(ggspatial) # For sp and sf to data frame. Use rarely. 
library(USAboundaries) # For a set of US map data points. 
library(USAboundariesData) #  Datasets related to USAboundaries.
library(tmap) # One way to easily map sf and sp objects.
library(rnaturalearth) # For great mapping data. 
library(rnaturalearthhires) # For high-resolution natural earth data.


# We will discuss three types of mapping objects. 

# data frame/spatial data frames. Easiest, but easiest to screw up.
# sf. simple features. Best to work with, in my opinion.
# sp. spatial polygon data. GIS style. Complicated, nested structure. 


# By levels of complexity: sp > sf > data frame. 


# For sp objects, you are importing shapefiles, which are folders of files, including a .shp file. 
# DO NOT EVER REMOVE THE .SHP FILE FROM THE FOLDER WITH THE OTHER SPATIAL FILES. 

# Mapping in r. A few object classes to be familiar with: sp, sf, and spatial data frames. 
# sp objects: S4 object, extra-nested list-like object. A list on steroids. 
# sf objects: S3: data frame + "geometry", a list object.  
# spatial data frames: s3: regular data frames with longitude and latitude variables. 


# Mapping data: so many sources, it is impossible to list them all. 

# ggplot2: has its own map data.
# maps: has many data sets. 
# USAboundaries: many data sets.
# USAboundariesData: many data sets. 
# the list goes on...

 # https://www.naturalearthdata.com/downloads/

# Back to spatial data objects. 
# REPEAT: 
# sp: spatial objects. 'S4' class objects with different nesting structure. 
# sf: simple feature objects. Have a 'geometry' variable for coordinates.
# data frames: polygon data with long and lat as separate variables.

###
# sp objects. sp objects are 'S4' class. All others you are working with in this course are 'S3'
# Thus, sp objects look different. Only going to focus on basics here. 
# Subsetting looks different. We have slots (fields).
# The '$' is essentially replaced with '@', and slot() replaces [[]]

# From rgdal package.

# First line requires rgdal; second requires sf. 

spdat1 <- readOGR("/Users/robertcooper/Desktop//US_Climate/US_Climate.shp") # rgdal.

sp_sfdat <- st_read("/Users/robertcooper/Desktop/US_Climate/US_Climate.shp") # sf.

spdat1

sp_sfdat # sf object

spdat1@data# sp object

class(spdat1)
class(sp_sfdat)

head(sp_sfdat)
glimpse(sp_sfdat)
str(spdat1) # Watch all the crazy subsetted data flow from the structure of spdat1.


sp_sfdat$geometry[1]

# Subsetting an 'sp' uses "slots" with the '@' symbol, for starters.

spdat1@data # Features about the climate stations here. 
spdat1@bbox

# Getting down to smallest subset looks different, for sure. 

spdat1@bbox # There will always be a 'bbox': a "bounding box" (smallest box encompassing all points in set)
spdat1@proj4string # There will always be a projection string. 

# Like a normal list, you can keep subsetting further and transform/tidy data. 

spdat1@data$STATE

# So, how do you make a map with an sp object? You can use tmap. Or spplot.
# OR... convert the sp object to sf or spatial data frame. 
# I generally recommend the latter. sf objects are flexible and
# easier to work with. 

#####
# sf objects. These look and act like data frames, except for the geometry. 
# If you have trouble finding USAboundariesData, then...
# dev.off()

# library(devtools)
# devtools::install_github("https://github.com/ropensci/USAboundariesData")

library(USAboundariesData)
library(USAboundaries) # A number of levels of mapping data available. Investigate. 

# library(usmap) # This can also work with ggplot2.


state_dat <- us_states() #map data. 
state_dat

class(state_dat)

state_dat$geometry[1]

state_dat %>%
  ggplot() +
  geom_sf() +
  coord_sf(xlim = c(-135, -60)) +
  theme_minimal()

sp_sfdat %>%
  ggplot() +
  geom_sf() +
  coord_sf() +
  theme_minimal()

# Let's say I wanted to map the stations for June temperatures.

sp_sfdat %>%
  ggplot() +
  geom_sf(aes(col = T06)) +
  theme_minimal() +
  coord_sf()

# Data frame with x and y long & lat variables. 
# This is fine, but instructions 

# Let's actually add a map!



world <- map_data("world2")
head(world)
class(world)

states1 <- map_data("state") # from ggplot2. Normal data frame.
head(states1)

states2 <- us_states() # from USAboundaries. sf object (has 'geometry').
class(states2)
class(states1)

# Simple map of US from a data frame. 

states1 %>%
  ggplot(aes(x = long, y = lat, group = group)) +
  geom_polygon() +
  coord_map()

# Two sf data sets. One for the map, and one for the data set. 

states2 %>%
  ggplot() +
  geom_sf(size = 0.2) +
  geom_sf(data = sp_sfdat, aes(col = T06), size = 1) +
  theme_minimal() +
  coord_sf(xlim = c(-130, -55), ylim = c(20, 55))

###########
# Another way: mix data frame and sf together!

ggplot(data = states1) +
  geom_polygon(aes(x = long, y = lat, group = group)) +
  geom_sf(data = sp_sfdat, aes(col = T01))  +
  labs(title = "U.S. Climate Data: Measurement Stations",
       Color = "Temp") +
  theme_minimal() +
  coord_sf(xlim = c(-130,-60), ylim = c(23, 50)) +
  scale_color_gradientn(colors = c("blue", "yellow"))


#########
#####
# sf objects. These look and act like data frames, except for the geometry. 

# If you have trouble finding USAboundariesData, then...

library(devtools)
devtools::install_github("https://github.com/ropensci/USAboundariesData")

library(USAboundariesData)
library(USAboundaries) # A number of levels of mapping data available. Investigate. 
library(ggspatial) # Easily transform sp and sf objects into data frames. 

class(state_dat)

glimpse(state_dat)

state_dat # US states, sf object. 

statez <- df_spatial(state_dat)

class(statez)
glimpse(statez)

# From the converted data frame object...

statez %>%
  ggplot(aes(x = x, y = y, group = feature_id)) +
  geom_polygon()

# The above fails across various grouping variables. So just use sf!!!!!

state_dat %>%
  ggplot() +
  geom_sf() +
  coord_sf()

# library(usmap) # This can also work with ggplot2.

state_dat <- us_states()
glimpse(state_dat)

library(tmap)

state_dat %>%
  tm_shape() +
  tm_borders()

# USABoundaries. Historical data. 

usa <- us_boundaries("1755-01-01")
class(usa)
head(usa)

# tmap takes sf objects or sp objects. 

usa %>%
  tm_shape() +
  tm_borders()

# ggplot can take data frames or sf objects. 

usa %>%
  ggplot() +
  geom_sf()+
  coord_sf()

###

cty_dat <- us_cities() # sf

glimpse(cty_dat)
class(cty_dat) # See class 'sf' and 'data.frame'. 
class(cty_dat$geometry) # new/odd 'sfc' and "MULTIPOLYGON"
cty_dat$geometry[2]

# geom_sf() is smart and knows where the long/lat and grouping data are: inside the 'geometry'

ak_hi_pr <- c("Alaska", "Hawaii", "Puerto Rico")

cty_dat %>%
  filter(!state_name %in% ak_hi_pr) %>%
  ggplot() +
  geom_sf(size = 0.1) +
  theme_minimal()

# Using usmap package instead. One line, don't need to drop AK & HI.
# Arguments become slightly different, but it works with ggplot functions fine.

library(tidyverse)
library(usmap)

# Swipe the county data and use, or maybe add your own data to it. 
ctydat_new <- usmap::countypop
head(ctydat_new)

# You can add data to the existing county data.
ctydat_new$logpop <- log(ctydat_new$pop_2015) # Why log? Reduce outliers.

# The 'values' argument adjusts to both continuous and categorical scales.

plot_usmap(data = ctydat_new, values = "logpop", size = 0.1) +
  theme(legend.position = "none")

##########
##### Spatial data frames. 
# These are normal data frames with longitude and latitude as variables.
# You need to be especially careful about grouping. 
# Now we can make a map with geom_polygon. 

# Let's grab some map data from ggplot2. 
# Finding the grouping variable won't always be this easy.

world <-map_data("world")
head(world)

county <- map_data("county")
head(county)

county %>%
  ggplot(aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "gray80", color = "black", size = 0.1) +
  theme_minimal() +
  coord_map(projection = "polyconic")

####################
# You can create your own 'sp' objects.

ln1 <- Line(matrix(runif(6), ncol=2))
ln2 <- Line(matrix(runif(6), ncol=2))
class(ln1) # Class sp.
ln1@coords # Subset to coordinates through the slot '@'
spacedat <- SpatialLines(list(ln1, ln2))



##
#  Mapping historical U.S. Districts. 

library(rgdal)
library(tmap)
library(sf)
library(ggspatial)

dist1 <- readOGR("/Users/robertcooper/Desktop/districtShapes/districts001.shp") 

dist1.1 <- st_as_sf(dist1)
dist1.2 <- df_spatial(dist1)

class(dist1.1)
glimpse(dist1.2)


# dis12 <- dist1.2 %>%
#  filter(STATENAME == "Virginia") %>%
#  mutate(dist_cols = ifelse(DISTRICT == 5, 1, 0))

# 'feature_id' is not the right grouping variable. 

dist1.2 %>%
  filter(STATENAME == "Virginia") %>%
  ggplot(aes(x = x, y = y, group = ID)) +
  geom_polygon(size = 0.1, fill = "gray90", color = "gray50") +
  labs(title = "Virginia's 1st House Election",
       subtitle = "Madison v. Monroe: the 5th District") +
  coord_map() +
  theme_minimal()

# Virginia's 1st House of Representatives election. 

text1 <- "The campaign between James Madison \n and James Monroe was the only contest \n between future presidents."

dist1.1 %>%
  filter(STATENAME == "Virginia") %>%
  ggplot() +
  geom_sf(size = 0.1) +
  annotate("text", label = text1, x = -87, y = 40, size = 1.5) +
  coord_sf() +
  labs(title = "Virginia's 1st House Election: Madison v. Monroe") +
  theme_minimal() +
  theme(plot.margin = margin(0, 1, 0, 1, "cm"),
        plot.title = element_text(size = 5.5),
        axis.text = element_text(size = 3.5),
        axis.title = element_blank())

############################

library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium",
                      returnclass = "sf") 

world %>%
  filter(region_un)

glimpse(world)

world %>%
  tm_shape() +
  tm_borders() 

world %>%
  ggplot() +
  geom_sf() +
  coord_sf()

################################################################################
#  tmap package. 
# 

# tmap takes sf or sp objects. 
# tmap takes many other types of spatial classes. 

library(rnaturalearth)
library(devtools)

# devtools::install_github("ropensci/rnaturalearthhires")

library(rnaturalearthhires)

glimpse(wiid)

# The default is small. 

world <- rnaturalearth::ne_countries(scale = 'large')
class(world)

world2 <- st_as_sf(world)

tm_shape(world) +
  tm_fill() +
  tm_borders()

canada <- ne_states(country = "Canada")
class(canada)

ne_states(country = "Canada") %>%
  tm_shape() +
  tm_fill() +
  tm_borders() 

####################################################################################

## MAP CALIFORNIA TWO-PART GRID PLOT.  
## California Education Data. Average SAT scores for math and writing.  
#cal_counties <- us_counties(state_name = 
#                              "California")


cal_cos <- map_data("county") %>%
  filter(region == "california")

class(cal_cos)

sat16 <- read.csv(file.choose(), stringsAsFactors = FALSE)
head(sat16); glimpse(sat16)

sat16.2 <- sat16 %>%
  filter(rtype == "C") %>% 
  mutate(cname = tolower(cname)) %>%
  mutate(av_math = str_replace_na(avgscrmath),
         av_math2 = str_replace(av_math,"\\*",""),
         av_math3 = as.numeric(av_math2),
         av_read = str_replace_na(avgscrread),
         av_read2 = str_replace(av_read, "\\*",""),
         av_read3 = as.numeric(av_read2))

caldat <- full_join(cal_cos, sat16.2, by = c("subregion" = "cname"))

gsat1 <- ggplot() +
  geom_polygon(data = caldat, aes(x = long, y = lat,fill = av_math3, group = group)) +
  labs(title = "Average Math SAT Scores",
       x = "Longitude", y = "Latitude", caption = "") +
  scale_fill_gradientn(colors = c("#ffa500", "#0f00b2"), name = "Score") +
  theme_minimal() +
  coord_map()
# gsat2

gsat2 <- ggplot() +
  geom_polygon(data = caldat, aes(x = long, y = lat,fill = av_read3, group = group)) +
  labs(title = "Average Reading SAT Scores",
       x = "Longitude", y = "Latitude", caption = "Source: California Department of Education") +
  scale_fill_gradientn(colors = c("#67f48d", "#0f00b2"), name = "Score") +
  theme_minimal() +
  coord_map()
grid.arrange(gsat1, gsat2, ncol = 2, top = "California 2015-2016 SAT Scores by County")


###############################################################################################
##  Trail of Tears map.  

library(rgdal)
library(ggspatial)
library(USAboundaries)
library(USAboundariesData)

tot <- readOGR("/Users/robertcooper/Desktop/Teaching/data_teaching/trail_of_tears/trte_nht_100k_line.shp")
class(tot) # Starts as 'sp' object. 

## OPTIONS: just use sp object; convert to sf object; convert to data frame. 
# Convert from 'sp' object to 'sf' object. 
tot_2 <- st_as_sf(tot) 

# Code below converts to data frame. 
tot_3.1 <- df_spatial(tot_2)
tot_3.2 <- df_spatial(tot)

# Code below also converts to data frame.
tot_3 <- fortify(tot) # This works. Can feed right into ggplot as data.frame. 
class(tot_3) # Check to prove. 

us_1830 <- us_boundaries("1830-05-28")

glimpse(us_1830)

head(us_1830); class(us_1830) # sf and data.frame
# Date: day of Indial Removal Act signature. 

usa <- us_boundaries()

us_boundaries( "1830-05-28", states = c("Georgia","alabama", "mississippi",
                                        "tennessee", "oklahoma",
                                        "arkansas","missouri", "kentucky",
                                        "illinois", "north carolina","unorg. fed. terr." )) %>%
  tm_shape() +
  tm_fill() +
  tm_borders(col = "gray70") +
  tm_text("state_name", col = "gray70", size = 0.6) +
  tm_shape(tot) +
  tm_lines(col = "red")  +
  tm_compass() +
  tm_layout(main.title = "Trail of Tears, 1830-1850",
            main.title.size = 1.2,
            main.title.fontface = "bold")

## Using ggplot instead. 
## ggplot version, both with geom_line() AND geom_path()

us_boundaries( "1830-05-28", states = c("georgia","alabama", "mississippi",
                                        "tennessee", "oklahoma",
                                        "arkansas","missouri", "kentucky",
                                        "illinois", "north carolina","Unorg. Fed. Terr." )) %>%
  ggplot() +
  geom_sf(size = 0.1) + 
  geom_line(data = tot_3, aes(x = long, y = lat, group = id), color = "red", size = 0.1) +
  labs(title = "Trail of Tears, 1830-1838",
       x = "Longitude",
       y = "Latitude") +
  theme_minimal()
