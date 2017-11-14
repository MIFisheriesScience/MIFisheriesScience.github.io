# Week 10: Maps
# Started Nov 13, 2017

install.packages("marmap")
#sf documentation: http://pebesma.staff.ifgi.de/pebesma_sfr.pdf

#marmap: http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0073051

library(ggplot2)
library(raster)
library(maptools)
library(GISTools)
library(rgdal)
library(marmap)
library(grid)

##############################################
# http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html

# Simple map of NL
######################

NL <- getNOAA.bathy(lon1 = -60, lon2 = -52,
              lat1 = 46, lat2 = 52, resolution = 2) # reduce resolution number to get finer details

summary(NL)

#png("test.png") #Use these when you're ready to prep a figure for a paper
#dev.off()

# Note, the R studio preview looks quite different from the plot saved to PNG

plot(NL, xlim=c(-60, -52), ylim=c(46, 52),
     deepest.isobath = 0, #Try: c(-500, -250, 0), 
     shallowest.isobath = 0, #Try: c(-500, -250, 0),
     col="black", # With above, try: c("grey80", "grey40", "black")
     step=1, # c(1,1,1),
     lty=1, #c(1,1,1), 
     lwd=0.6, # c(0.6,0.6,1.2), 
     drawlabels=F) #With above, try: c(T,T,F))

scaleBathy(NL, deg=2, y=46.5, x=-60) #add a scale
north.arrow(xb=-59, yb=49.5, len=0.22, lab="N") 

# Annotate some key reference points

text(x = -56, y = 48.5, "Newfoundland")
text(x = -51.75, y = 47.25, "St. John's")
points(x = -52.712, y = 47.56, pch=16)

rect(xleft = -54, xright = -52,
     ybottom = 50, ytop = 52, 
     col=NA,
     border="red")

# Invent some fishing sites and plot them 

lat <- c(50, 50.5, 52, 51)
lon <- c(-54, -53, -52.5, -54)
OffshoreSites <- data.frame(lon, lat)

points(OffshoreSites, col="blue")

#
plot(NL, xlim=c(-60, -52), ylim=c(46, 52),
     image=T,
     deepest.isobath = 0, #Try: c(-500, -250, 0), 
     shallowest.isobath = 0, #Try: c(-500, -250, 0),
     col="black", # With above, try: c("grey80", "grey40", "black")
     step=1, # c(1,1,1),
     lty=1, #c(1,1,1), 
     lwd=0.6, # c(0.6,0.6,1.2), 
     drawlabels=F) #With above, try: c(T,T,F))

###########################################################
# Figure 2: Zoomed in map, hypothetical Fogo Island study #
###########################################################

lat <- runif(20, 49.8, 50)
lon <- runif(20, -54.5, -53.9)
FogoSites <- data.frame(lon, lat)

FogoMap <- getNOAA.bathy(lon1 = -54.75, lon2 = -53.75,
                    lat1 = 49.25, lat2 = 50, resolution = 1) # reduce resolution number to get finer details


plot(FogoMap, xlim=c(-54.75, -53.75), ylim=c(49.25, 50),
     deepest.isobath = c(-200, -50, 0), 
     shallowest.isobath = c(-200, -50, 0),
     col= c("grey80", "grey60", "black"),
     step=c(1,1,1),
     lty=c(1,1,1), 
     lwd=c(0.6,0.6,1.2), 
     drawlabels=c(T,T,F))

scaleBathy(FogoMap, deg=0.25, y=49.25, x=-54.7) #add a scale
north.arrow(xb=-54.7, yb=49.9, len=0.025, lab="N") 

text(x = -54.2, y = 49.675, "Fogo Island")
text(x = -54.42, y = 49.52, "Farewell")
points(x = -54.469, y = 49.57, pch=16, cex=2)
rect(xleft = -54.5, xright = -53.9,
     ybottom = 49.8, ytop = 50, col=NA, border="red")

points(FogoSites, col="blue")

############################
# What about a NAFO map?   #
############################

install.packages("NAFOtools")
library(NAFOtools)



#The inset map at lower resolution

#InsetMap <- getNOAA.bathy(lon1 = -60, lon2 = -52,
                     #     lat1 = 46, lat2 = 52, resolution = 3) 

#plot(InsetMap, xlim=c(-60, -52), ylim=c(46.5, 52),
     #deepest.isobath = 0, 
     #shallowest.isobath = 0,
     #col= "black",
     #step=1,
     #lty=1, 
     #lwd=1.2, 
     #drawlabels=F,
     #axes=FALSE, frame.plot=FALSE, xlab="", ylab="")

#rect(xleft = -54.75, xright = -53.75,
     #ybottom = 49.25, ytop = 50, 
     #col=NA,
     #border="red")




#####################################################
# Same as above, but with different projection
# All projection types are listed here: http://proj4.org/projections/index.html
##########################################################
# CODE NOT WORKING YET

#r1 <- as.raster(NL)
#projection <- "+proj=merc"
#r2 <- projectRaster(r1, crs=projection)

#projectedNL <- as.bathy(r2)

#plot(projectedNL, xlim=c(-60, -52), ylim=c(46, 52),
     #deepest.isobath = 0, 
     #shallowest.isobath = 0, 
     #col="black",
     #step=1, 
     #lty=1, 
     #lwd=0.6,
     #drawlabels=F) 

#scaleBathy(NL, deg=2, y=46.5, x=-60) #add a scale
#north.arrow(xb=-59, yb=49.5, len=0.22, lab="N") 









trans1 <- trans.mat(hawaii,min.depth=-1000)
trans2 <- trans.mat(hawaii,min.depth=-4000)

out1 <- lc.dist(trans1,sites,res="path")
out2 <- lc.dist(trans2,sites,res="path")

plot(hawaii, xlim=c(-161,-154), ylim=c(18,23), 
     deep=c(-4000,-1000,0), shallow=c(-4000,-1000,0), 
     col=c("grey80","grey40", "black"), step=c(1,1, 1), 
     lty=c(1,1,1), lwd=c(0.6,0.6,1.2), draw=c(F,F,F))


points(sites,pch=21,col="blue",bg=col2alpha("blue",.9),cex=1.2)
text(sites[,1],sites[,2],lab=rownames(sites),pos=c(3,4,1,2),col="blue")
lapply(out2,lines,col=col2alpha("blue",alpha=0.3),lwd=1,lty=1) -> dummy
lapply(out1,lines,col=col2alpha("red",alpha=0.3),lwd=1,lty=1) -> dummy




# Zoomed-in map with inset

# Add an inset

# Add some points, corresponding with a hypothetical field site

# Map with NAFO regions 


#
# Bathymetric map
# Bathymetric data

data(nw.atlantic)

?marmap

NL <- getNOAA.bathy(lon1=-61,lon2=-41,lat1=41,lat2=53, resolution=1) 


###############################################
### 

blues <- colorRampPalette(c("purple","lightblue","cadetblue2","cadetblue1","white"))

atlantic <- as.bathy(nw.atlantic)
?as.bathy

plot(atlantic, image=T, bpal=blues(100), deep=c(-6500,0), shallow=c(-50,0), step=c(500,0), 
     lwd=c(0.3,0.6), lty=c(1,1), col=c("black","black"), drawlabels=c(F,F))

scaleBathy(atlantic, deg=3, y=42.5,x=-74)



###############################################

### Figure 1B (middle left, 2D)
get.transect(atl,x1=-67.9, y1=41.2,x2=-55.2,y2=33.6, loc=FALSE, dis=TRUE) -> test
points(test$lon,test$lat,type="l",col=col2alpha("blue", alpha=0.5),lwd=2,lty=1)
points(min(test$lon),max(test$lat),col="blue")
points(max(test$lon),min(test$lat),col="blue")
plotProfile(test)

###############################################

### Figure 1C (middle left, 3D)
get.box(atl,x1=-67.9, y1=41.2,x2=-55.2,y2=33.6, width=2,col=2) -> out
wireframe(out, shade=T, zoom=1.1,
          aspect=c(1/4, 0.1), 
          screen = list(z = -20, x = -50),
          par.settings = list(axis.line = list(col = "transparent")),
          par.box = c(col = rgb(0,0,0,0.1)))

###############################################

### Figure 1D (bottom left, 3D)	
wireframe(unclass(atl), shade=T, aspect=c(1/2, 0.1),
          screen = list(z = 0, x = -50),
          par.settings = list(axis.line = list(col = "transparent")),
          par.box = c(col = rgb(0,0,0,0.1)))

###############################################

### Figure 1E (top right)
colorRampPalette(c("red","purple","blue","cadetblue1","white")) -> blues 
plot(papoue, image=T, bpal=blues(100), #xlim=c(141,155),
     deep=c(-9000,-3000,0), shallow=c(-3000,-10, 0), step=c(1000, 1000, 0),
     col=c("lightgrey","darkgrey","black"), lwd=c(0.3,0.3,0.6), lty=c(1,1,1),
     drawlabel=c(F,F,F))

###############################################

### Figure 1F (middle right)
sites <- hawaii.sites[-c(1,4),] ; rownames(sites) <- 1:4

trans1 <- trans.mat(hawaii,min.depth=-1000)
trans2 <- trans.mat(hawaii,min.depth=-4000)

out1 <- lc.dist(trans1,sites,res="path")
out2 <- lc.dist(trans2,sites,res="path")

plot(hawaii, xlim=c(-161,-154), ylim=c(18,23), 
     deep=c(-4000,-1000,0), shallow=c(-4000,-1000,0), 
     col=c("grey80","grey40", "black"), step=c(1,1, 1), 
     lty=c(1,1,1), lwd=c(0.6,0.6,1.2), draw=c(F,F,F))
points(sites,pch=21,col="blue",bg=col2alpha("blue",.9),cex=1.2)
text(sites[,1],sites[,2],lab=rownames(sites),pos=c(3,4,1,2),col="blue")
lapply(out2,lines,col=col2alpha("blue",alpha=0.3),lwd=1,lty=1) -> dummy
lapply(out1,lines,col=col2alpha("red",alpha=0.3),lwd=1,lty=1) -> dummy

###############################################

### Figure 1G (bottom right)
plot(hawaii, lwd=0.2)

get.area(hawaii, level.inf=-4000, level.sup=-1000) -> bathyal
get.area(hawaii, level.inf=min(hawaii), level.sup=-4000) -> abyssal

image(bathyal$Lon, bathyal$Lat, bathyal$Area, col=c(rgb(0,0,0,0), rgb(.7,0,0,.3)),    add=T)
image(abyssal$Lon, abyssal$Lat, abyssal$Area, col=c(rgb(0,0,0,0), rgb(.7,.7,0.3,.3)), add=T)

round(bathyal$Square.Km, 0) -> ba
round(abyssal$Square.Km, 0) -> ab

legend(x="bottomleft",legend=c(paste("bathyal:",ba,"km2"), paste("abyssal:",ab,"km2")), 
       bty="n", fill=c(rgb(.7,0,0,.3), rgb(.7,.7,0,.3)))
