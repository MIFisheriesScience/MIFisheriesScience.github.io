# FISH 6002: Week 10: Maps
# Part 2
# Nov 17, 2017
##########

library(tidyverse)
library(raster)
library(maptools)
library(rgdal)
#library(gridExtra)
library(plyr)

################
setwd("C:/Users/bfavaro/Google Drive/MI SOF Courses/FISH 6002 - Data collection mgmt and display/Week 10 - Maps")

#######################
# Get a map of Canada #
#######################

# getData grabs administrative boundaries from the web
# See ?getData for full functionality

# Get level 0 (i.e. JUST hte contry boundary) data
Canada <- getData("GADM", country="CAN", level=0) # download CAN level 0 map 

# Get level 1 data: Provinces
Province <- getData("GADM", country="CAN", level = 1) 

# Get level 2 data: Specific regions
Regional <- getData("GADM", country="CAN", level = 2)

# Plot all of Canada
a <- ggplot() +
  geom_polygon(data=Canada, aes(long, lat, group=group))
a

# Plot all of Canada from provincial data
a <- ggplot() +
  geom_polygon(data=Province, aes(long, lat, group=group))
a

# Notice they are the same. That's because level 1 contains everything in level 0
# Likewise, level 2 contains everything in level 1 and level 0

names(Province) #itemize all the variables contained within Province

Province$NAME_0 # It's all Canada because we downloaded Canada's data
Province$NAME_1

# You will have noticed that the map is squished. Fix the coordinate system:
# (Recall you could use data frames Canada or Fogo for this too)

a <- ggplot() +
  geom_polygon(data=Province, aes(long, lat, group=group)) +
  coord_map() # Alter the map projection. Mercator = default
            
a

# All available projections are listed by running the next line:
?mapproj::mapproject 

# Fun with a few projections
a <- ggplot() +
  geom_polygon(data=Province, aes(long, lat, group=group)) +
  coord_map(projection="cylindrical") 
a 

a <- ggplot() +
  geom_polygon(data=Province, aes(long, lat, group=group)) +
  coord_map(projection="ortho") 
a 

a <- ggplot() +
  geom_polygon(data=Province, aes(long, lat, group=group)) +
  coord_map(projection="hex") 
a 

# The further north you go, the worse many of these projections look

a <- ggplot() +
  geom_polygon(data=Province, aes(long, lat, group=group)) +
  coord_map(xlim = c(-100,-60), ylim=c(60,90)) # Focus on the high Arctic

a

# Recommended Arctic projections: 
# 1. Stereographic

a <- ggplot() +
  geom_polygon(data=Province, aes(long, lat, group=group)) +
  coord_map(projection = "stereographic", 
            xlim = c(-100,-60), ylim=c(60,90)) 

a

# 2. Albers equal area

a <- ggplot() +
  geom_polygon(data=Province, aes(long, lat, group=group)) +
  coord_map(projection = "albers", lat0 = 60, lat1 = 90, # Mess around with the latitudes to get different maps
            xlim = c(-100,-60), ylim=c(60,90)) 

a

# More info about projections: 
# https://rud.is/b/2015/07/24/a-path-towards-easier-map-projection-machinations-with-ggplot2/

##########################################
# Let's zoom in on a specific province   #
##########################################

# Recall we need to look up the province names
Province$NAME_1

# We have to use this awkward subsetting method because the tidyverse doesn't yet know
# how to handle spatial polygons

NL <- (Province[Province$NAME_1=="Newfoundland and Labrador",]) 

a <- ggplot() +
  geom_polygon(data=NL, aes(long, lat, group=group)) +
  coord_map() 
  
a


########################################
# Plotting our field sites on Fogo     #
########################################

# Use the dataset with all administrative boundaries so we can work with a small map

Fogo <-(Regional[Regional$NAME_1=="Newfoundland and Labrador",]) #See http://gadm.org/maps/CAN_2_5.html
Fogo <-(Fogo[Fogo$NAME_2=="Division No. 8",]) #See http://gadm.org/maps/CAN_2_5.html

a <- ggplot() +
  geom_polygon(data=Fogo, aes(long, lat, group=group)) +
  coord_map() 

a

# Zoom in on Fogo Island

longmin <- -54.35
longmax <- -53.95
latmin <- 49.5
latmax <- 49.77

# , colour="grey10",fill="#fff7bc"

a <- ggplot() +
  geom_polygon(data=Fogo, aes(long,lat, group=group)) +
  coord_map(xlim=c(longmin, longmax), ylim=c(latmin, latmax)) +
  theme_bw()

a

# Improve the colouration, fix axis labels

a <- ggplot() +
  geom_polygon(data=Fogo, 
               aes(long,lat, group=group), 
               colour="grey10",fill="#fff7bc") +
  coord_map(xlim=c(longmin, longmax), 
            ylim=c(latmin, latmax)) +
  xlab("Longitude") +
  ylab("Latitude") +
  theme_bw()

a

# Fix the axis labels so they look nicer
# Make them say degree N and degree W. Note absolute value for long:
# we don't want -## degree W

a <- ggplot() +
  geom_polygon(data=Fogo, 
               aes(long,lat, group=group), 
               colour="grey10",fill="#fff7bc") +
  coord_map(xlim=c(longmin, longmax), 
            ylim=c(latmin +0.01, latmax)) + #Nudge it up a bit to make for nicer axis labels
  xlab("Longitude") +
  ylab("Latitude") +
  theme_bw() +
  theme(axis.text=element_text(size=12), axis.title = element_text(size=14)) +
  scale_x_continuous(breaks=seq(longmin,longmax, 0.1), 
                     labels=c(paste(abs(seq(longmin,longmax, 0.1)),"°W", sep=""))) +
  scale_y_continuous(breaks=seq(latmin,latmax, 0.1), 
                     labels=c(paste(seq(latmin,latmax, 0.1), "°N", sep="")))

a

# Add scale bar and north arrow
# NOTE: YOU MUST RUN THE FUNCTIONS AT THE END OF THE CODE FOR THIS TO WORK

a <- ggplot() +
  geom_polygon(data=Fogo, 
               aes(long,lat, group=group), 
               colour="grey10",fill="#fff7bc") +
  coord_map(xlim=c(longmin, longmax), 
            ylim=c(latmin+0.01, latmax)) +
  xlab("Longitude") +
  ylab("Latitude") +
  theme_bw() +
  theme(axis.text=element_text(size=12), axis.title = element_text(size=14)) +
  scale_x_continuous(breaks=seq(longmin,longmax, 0.1), 
                     labels=c(paste(abs(seq(longmin,longmax, 0.1)),"°W", sep=""))) +
  scale_y_continuous(breaks=seq(latmin,latmax, 0.1), #Nudge it up just a bit, to make axis nicer
                     labels=c(paste(seq(latmin,latmax, 0.1), "°N", sep=""))) +
  scaleBar(lon=longmin+0.03, lat=latmin+0.015, 
           distanceLon=5, distanceLat=0.75, distanceLegend=1.25, 
           dist.unit="km") +
  scaleBar(lon=longmax-0.03, lat=latmax-.06, distanceLon=0, distanceLat=0, distanceLegend=0, dist.unit="km", 
           orientation=TRUE, arrow.length=4, arrow.distance=2, 
           legend.colour="white") +
  geom_point(size=3, aes(x=-54.173329, y=49.615394), size=2, colour="brown")+
  geom_text(label="Seldom", aes(x=-54.187, y=49.630394), colour="brown")#+
  #geom_point(size=3, data=PotDeploy, aes(LongDecDeg, LatDecDeg))

a

################################
# Preparing an inset           #
################################

b <- ggplot() +
  geom_polygon(data=NL, aes(long, lat, group=group), 
               colour="grey10",fill="#fff7bc") +
  coord_map(ylim=c(46, 61)) +
   theme_bw()+xlab("")+ylab("") +
  theme(axis.text.x=element_blank(),
        axis.text.y= element_blank(), 
        axis.ticks=element_blank(),
        axis.title.x =element_blank(),
        axis.title.y= element_blank(), 
        panel.grid.major=element_blank(), 
        panel.grid.minor=element_blank()) +
  theme(plot.margin=unit(c(0,0,0,0), "cm")) +
  labs(x=NULL, y=NULL) +
  geom_rect(aes(xmin = longmin-.33, xmax = longmax+.37, 
                ymin = latmin-.35, ymax = latmax+.35), 
            alpha = 0, colour="red", size = 2, linetype=1)

b 


###########################
# Combine the plots       #
###########################

grid.newpage()

v1<-viewport(width = 1, height = 1, x = 0.5, y = 0.5)          #plot area for the main map
v2<-viewport(width = 0.25, height = 0.3, x = 0.85, y = 0.25)   #plot area for the inset map
print(a,vp=v1) 
print(b,vp=v2)

##########################################
# Let's add some actual data to this map #
##########################################

PotDeploy <- read.csv("potdata.csv")

# Data:
# FleetID: Identifier. One value per fleet
# PotID: Identifier for pot deployment
# PotName: Identifier for specific pot (i.e. most pots were deployed more than once).
# NOR pots are numbered. NL pots are lettered
# PotType: The pot type (NOR or NL)
# LatDeg: Latitude in degrees
# LatMinSec: Latitude in Minutes.seconds
# LongDeg: Longitude in degrees
# LongMinSec: Longitude in minutes.seconds

head(PotDeploy)

# Decimal Degrees = Degrees + minutes/60 + seconds/3600
# Latitudes are positive. Longitudes are negative here, because they're W rather than E. 

PotDeploy <- PotDeploy %>%
  mutate(LatDecDeg = LatDeg + (LatMinSec/60)) %>%
  mutate(LongDecDeg = -1 * (LongDeg + (LongMinSec/60)))

head(PotDeploy)

a + geom_point(size=3, data=PotDeploy, aes(LongDecDeg, LatDecDeg))

#####################
# NAFO ZONES        #
#####################
#WORK IN PROGRESS


install.packages("NAFOtools")
# Not available for R 3.3.3 :(
# https://archive.nafo.int/open/sc/2013/scs13-22.pdf

# We have to manually download and load the shape files
# See https://github.com/tidyverse/ggplot2/wiki/plotting-polygon-shapefiles

# Get NAFO zones from https://www.nafo.int/Data/GIS

# Prepare the spatial object:
#NAFO <- readOGR("dsn=".", "layer="Divisions")

NAFO <- readOGR("Divisions.shp")

# Shape files have "Attributes" 
# To examinbe attributes
head(NAFO@data)

class(NAFO)



a <- ggplot() +
  geom_path(data=NAFO.df, aes(long, lat, group=group)) +
  coord_map()

a

a <- ggplot() +
  geom_polygon(data=NL, aes(long, lat, group=group)) +
  geom_path(data=NAFO, aes(long, lat, group=group)) +
  annotate("text", x = coordinates(NAFO)[,1], 
           y = coordinates(NAFO)[,2], 
           label=NAFO[["ZONE"]]) +
  coord_map() 

a

#Zoom in

a <- ggplot() +
  geom_polygon(data=NL, aes(long, lat, group=group)) +
  geom_path(data=NAFO, aes(long, lat, group=group)) +
  annotate("text", x = coordinates(NAFO)[,1], 
           y = coordinates(NAFO)[,2], 
           label=NAFO[["ZONE"]]) +
  coord_map() + ylim(c(46.5, 48.5)) + xlim(c(-55, -52.5))

a

# Note: Good to check datums. THey aren't the same here
crs(NAFO)
crs(NL)

#########################
# Fun with PBSmapping   #
#########################

#install.packages("PBSmapping")
library(PBSmapping)

# Ran out of time. Self-study: https://github.com/pbs-software/pbs-mapping/blob/master/documentation/PBSmapping-UG.doc


########################
# LOAD THESE FUNCTIONS #
########################

# Function for scale bar from http://editerna.free.fr/wp/?p=76
#
# Result #
#--------#
# Return a list whose elements are :
#   - rectangle : a data.frame containing the coordinates to draw the first rectangle ;
# 	- rectangle2 : a data.frame containing the coordinates to draw the second rectangle ;
# 	- legend : a data.frame containing the coordinates of the legend texts, and the texts as well.
#
# Arguments : #
#-------------#
# lon, lat : longitude and latitude of the bottom left point of the first rectangle to draw ;
# distanceLon : length of each rectangle ;
# distanceLat : width of each rectangle ;
# distanceLegend : distance between rectangles and legend texts ;
# dist.units : units of distance "km" (kilometers) (default), "nm" (nautical miles), "mi" (statute miles).
createScaleBar <- function(lon,lat,distanceLon,distanceLat,distanceLegend, dist.units = "km"){
  # First rectangle
  bottomRight <- gcDestination(lon = lon, lat = lat, bearing = 90, dist = distanceLon, dist.units = dist.units, model = "WGS84")
  
  topLeft <- gcDestination(lon = lon, lat = lat, bearing = 0, dist = distanceLat, dist.units = dist.units, model = "WGS84")
  rectangle <- cbind(lon=c(lon, lon, bottomRight[1,"long"], bottomRight[1,"long"], lon),
                     lat = c(lat, topLeft[1,"lat"], topLeft[1,"lat"],lat, lat))
  rectangle <- data.frame(rectangle, stringsAsFactors = FALSE)
  
  # Second rectangle t right of the first rectangle
  bottomRight2 <- gcDestination(lon = lon, lat = lat, bearing = 90, dist = distanceLon*2, dist.units = dist.units, model = "WGS84")
  rectangle2 <- cbind(lon = c(bottomRight[1,"long"], bottomRight[1,"long"], bottomRight2[1,"long"], bottomRight2[1,"long"], bottomRight[1,"long"]),
                      lat=c(lat, topLeft[1,"lat"], topLeft[1,"lat"], lat, lat))
  rectangle2 <- data.frame(rectangle2, stringsAsFactors = FALSE)
  
  # Now let's deal with the text
  onTop <- gcDestination(lon = lon, lat = lat, bearing = 0, dist = distanceLegend, dist.units = dist.units, model = "WGS84")
  onTop2 <- onTop3 <- onTop
  onTop2[1,"long"] <- bottomRight[1,"long"]
  onTop3[1,"long"] <- bottomRight2[1,"long"]
  
  legend <- rbind(onTop, onTop2, onTop3)
  legend <- data.frame(cbind(legend, text = c(0, distanceLon, distanceLon*2)), stringsAsFactors = FALSE, row.names = NULL)
  return(list(rectangle = rectangle, rectangle2 = rectangle2, legend = legend))
}
# North Arrow
#
# Result #
#--------#
# Returns a list containing :
#  - res : coordinates to draw an arrow ;
#	- coordinates of the middle of the arrow (where the "N" will be plotted).
#
# Arguments : #
#-------------#
# scaleBar : result of createScaleBar() ;
# length : desired length of the arrow ;
# distance : distance between legend rectangles and the bottom of the arrow ;
# dist.units : units of distance "km" (kilometers) (default), "nm" (nautical miles), "mi" (statute miles).
createOrientationArrow <- function(scaleBar, length, distance = 1, dist.units = "km"){
  lon <- scaleBar$rectangle2[1,1]
  lat <- scaleBar$rectangle2[1,2]
  
  # Bottom point of the arrow
  begPoint <- gcDestination(lon = lon, lat = lat, bearing = 0, dist = distance, dist.units = dist.units, model = "WGS84")
  lon <- begPoint[1,"long"]
  lat <- begPoint[1,"lat"]
  
  # Let us create the endpoint
  onTop <- gcDestination(lon = lon, lat = lat, bearing = 0, dist = length, dist.units = dist.units, model = "WGS84")
  
  leftArrow <- gcDestination(lon = onTop[1,"long"], lat = onTop[1,"lat"], bearing = 225, dist = length/5, dist.units = dist.units, model = "WGS84")
  
  rightArrow <- gcDestination(lon = onTop[1,"long"], lat = onTop[1,"lat"], bearing = 135, dist = length/5, dist.units = dist.units, model = "WGS84")
  
  res <- rbind(
    cbind(x = lon, y = lat, xend = onTop[1,"long"], yend = onTop[1,"lat"]),
    cbind(x = leftArrow[1,"long"], y = leftArrow[1,"lat"], xend = onTop[1,"long"], yend = onTop[1,"lat"]),
    cbind(x = rightArrow[1,"long"], y = rightArrow[1,"lat"], xend = onTop[1,"long"], yend = onTop[1,"lat"]))
  
  res <- as.data.frame(res, stringsAsFactors = FALSE)
  
  # Coordinates from which "N" will be plotted
  coordsN <- cbind(x = lon, y = (lat + onTop[1,"lat"])/2)
  
  return(list(res = res, coordsN = coordsN))
}
#
#
# Result #
#--------#
# This function enables to draw a scale bar on a ggplot object, and optionally an orientation arrow #
# Arguments : #
#-------------#
# lon, lat : longitude and latitude of the bottom left point of the first rectangle to draw ;
# distanceLon : length of each rectangle ;
# distanceLat : width of each rectangle ;
# distanceLegend : distance between rectangles and legend texts ;
# dist.units : units of distance "km" (kilometers) (by default), "nm" (nautical miles), "mi" (statute miles) ;
# rec.fill, rec2.fill : filling colour of the rectangles (default to white, and black, resp.);
# rec.colour, rec2.colour : colour of the rectangles (default to black for both);
# legend.colour : legend colour (default to black);
# legend.size : legend size (default to 3);
# orientation : (boolean) if TRUE (default), adds an orientation arrow to the plot ;
# arrow.length : length of the arrow (default to 500 km) ;
# arrow.distance : distance between the scale bar and the bottom of the arrow (default to 300 km) ;
# arrow.North.size : size of the "N" letter (default to 6).
scaleBar <- function(lon, lat, distanceLon, distanceLat, distanceLegend, dist.unit = "km", rec.fill = "white", rec.colour = "black", rec2.fill = "black", rec2.colour = "black", legend.colour = "black", legend.size = 3, orientation = TRUE, arrow.length = 500, arrow.distance = 300, arrow.North.size = 6){
  laScaleBar <- createScaleBar(lon = lon, lat = lat, distanceLon = distanceLon, distanceLat = distanceLat, distanceLegend = distanceLegend, dist.unit = dist.unit)
  # First rectangle
  rectangle1 <- geom_polygon(data = laScaleBar$rectangle, aes(x = lon, y = lat), fill = rec.fill, colour = rec.colour)
  
  # Second rectangle
  rectangle2 <- geom_polygon(data = laScaleBar$rectangle2, aes(x = lon, y = lat), fill = rec2.fill, colour = rec2.colour)
  
  # Legend
  scaleBarLegend <- annotate("text", label = paste(laScaleBar$legend[,"text"], dist.unit, sep=""), x = laScaleBar$legend[,"long"], y = laScaleBar$legend[,"lat"], size = legend.size, colour = legend.colour)
  
  res <- list(rectangle1, rectangle2, scaleBarLegend)
  
  if(orientation){# Add an arrow pointing North
    coordsArrow <- createOrientationArrow(scaleBar = laScaleBar, length = arrow.length, distance = arrow.distance, dist.unit = dist.unit)
    arrow <- list(geom_segment(data = coordsArrow$res, aes(x = x, y = y, xend = xend, yend = yend)), annotate("text", label = "N", x = coordsArrow$coordsN[1,"x"], y = coordsArrow$coordsN[1,"y"], size = arrow.North.size, colour = "black"))
    res <- c(res, arrow)
  }
  return(res)
}
