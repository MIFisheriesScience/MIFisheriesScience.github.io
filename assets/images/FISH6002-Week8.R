# Week 8: Data Display 3
# FISH 6002
# 

# Started Oct 26, 2017

library(tidyverse)
library(forcats)
library(lubridate)
library(RColorBrewer)
library(png)
library(grid)
library(devtools)

#This is a FUNCTION. I got it from: http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  if (is.null(layout)) {
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    for (i in 1:numPlots) {
      
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


setwd("C:/Users/bfavaro/Google Drive/MI SOF Courses/FISH 6002 - Data collection mgmt and display/Week 8 - Data display 3")

##########################
# 1. Colours and Symbols #
##########################

# RColorBrewer

library(RColorBrewer)

display.brewer.all()

# Sequential:
display.brewer.pal(n = 6, name="OrRd")

# Divergent:
display.brewer.pal(n = 8, name="RdGy")

# Note that an even number doesn't work quite right for divergent

display.brewer.pal(n = 9, name="RdGy")

#install.packages("dichromat")
#library(dichromat)

#dichromat()


#############
# Load data #
#############

pallid <- read.csv("Pallid.csv")

# http://derekogle.com/fishR/data/data-html/Pallid.html

# A data frame with 30 observations on the following 7 variables:

#date: Date of collection
#sl: Standard length (mm)
#fl: Fork length (mm)
#tl: Total length (mm)
#w: Weight (g)
#status: Living status of fish at time of collection (Frozen, Live, Dead).
#loc: Location of fish collection (NB=Nebraska, SD=South Dakota, ND=North Dakota, MT=Montana)

# 1. Did it load?

head(pallid)
tail(pallid)

# 2. Check data types

sapply(pallid, class)

# Convert date to a lubridate object
pallid$date <- dmy(pallid$date)

# 3. Check for missing or impossible values 

plot(pallid$sl)
plot(pallid$fl)
plot(pallid$tl) 
plot(pallid$w) 
plot(pallid$date) 

# 4. Check for typos and broken factors 

levels(pallid$status)
levels(pallid$loc) 

# All good
# Begin plots:

a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point() + 
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  )

a

# Heavier fish are red

a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(colour=w), size=8) + 
  scale_colour_gradient(high="red", low="blue") +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  )

a

# Red-green colourblindness demo

a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(colour=w), size=8) + 
  scale_colour_gradient(high="darkred", low="green") +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Unmodified")

b <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(colour=w), size=8) + 
  scale_colour_gradient(high=dichromat("darkred", type = "deutan"), low=dichromat("green", type = "deutan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Deutan - Insensitive to red")

c <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(colour=w), size=8) + 
  scale_colour_gradient(high=dichromat("darkred", type = "protan"), low=dichromat("green", type = "protan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Protan - insensitive to green")

d <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(colour=w), size=8) + 
  scale_colour_gradient(high=dichromat("darkred", type = "tritan"), low=dichromat("green", type = "tritan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Tritan - blue appears green")

multiplot(a,b,c,d, cols=2)

# Same as above, but colourblind-safe
a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(colour=w), size=8) + 
  scale_colour_gradient(high="red", low="blue") +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Unmodified")

b <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(colour=w), size=8) + 
  scale_colour_gradient(high=dichromat("red", type = "deutan"), low=dichromat("blue", type = "deutan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Deutan - Insensitive to red")

c <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(colour=w), size=8) + 
  scale_colour_gradient(high=dichromat("red", type = "protan"), low=dichromat("blue", type = "protan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Protan - insensitive to green")

d <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(colour=w), size=8) + 
  scale_colour_gradient(high=dichromat("red", type = "tritan"), low=dichromat("blue", type = "tritan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Tritan - blue appears green")

multiplot(a,b,c,d, cols=2)

######
# Let's colour the stream using a qualtiative palette
######


a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc), size=8) + 
  scale_colour_brewer(palette = "Set1") +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Unmodified")

a

# Colourblind-check

a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc), size=8) + 
  scale_colour_brewer(palette = "Set1") +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Unmodified")

b <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc), size=8) + 
  scale_colour_manual(values = dichromat(brewer.pal(4, "Set1"), type="deutan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Deutan - Insensitive to red")

c <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc), size=8) + 
  scale_colour_manual(values = dichromat(brewer.pal(4, "Set1"), type="protan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Protan - insensitive to green")

d <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc), size=8) + 
  scale_colour_manual(values = dichromat(brewer.pal(4, "Set1"), type="tritan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("tritan - blue appears green")

multiplot(a,b,c,d, cols=2)

####
# Try again with a different palette
####

a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc), size=8) + 
  scale_colour_brewer(palette = "Dark2") +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Unmodified")

b <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc), size=8) + 
  scale_colour_manual(values = dichromat(brewer.pal(4, "Dark2"), type="deutan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Deutan - Insensitive to red")

c <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc), size=8) + 
  scale_colour_manual(values = dichromat(brewer.pal(4, "Dark2"), type="protan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("Protan - insensitive to green")

d <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc), size=8) + 
  scale_colour_manual(values = dichromat(brewer.pal(4, "Dark2"), type="tritan")) +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) +
  ggtitle("tritan - blue appears green")

multiplot(a,b,c,d, cols=2)

####################################
# Scale point size by fish weight  #
####################################


a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc, size=w)) + 
  scale_colour_brewer(palette = "Dark2") +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  )

a

#########################################################
# Scale point size by fish weight, AND symbol = status  #
#########################################################

a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc, size=w, shape=status)) + 
  scale_colour_brewer(palette = "Dark2") +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  )

a


### Add images

deadfish <- readPNG("deadfish.png")
deadfish_raster <- rasterGrob(deadfish, interpolate=TRUE)

livefish <- readPNG("HappyFishLogo.png")
livefish_raster <- rasterGrob(livefish, interpolate=TRUE)

frozenfish <- readPNG("Froze.png")
frozenfish_raster <- rasterGrob(frozenfish, interpolate=TRUE)

a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point(aes(color=loc, size=w, shape=status)) + 
  scale_colour_brewer(palette = "Dark2") +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14),
        title = element_text(size=16)
  ) + 
  annotation_custom(deadfish_raster, xmin=900, xmax=1000, ymin=1400, ymax=Inf) +
  annotation_custom(livefish_raster, xmin=900, xmax=1000, ymin=1250, ymax=Inf) +
  annotation_custom(frozenfish_raster, xmin=900, xmax=1000, ymin=1100, ymax=Inf) 
  
a


#################################
# 2. Multipanel plots           #
#################################
TroutRemoval <- read.csv("SimonsonLyons.csv")

# http://derekogle.com/fishR/data/data-html/SimonsonLyons.html

#A data frame of 58 observations on the following 7 variables:

#species: Species of fish.
#stream: Stream name.
#first: Catch on the first removal pass.
#second: Catch on the second removal pass.
#third: Catch on the third removal pass.
#fourth: Catch on the fourth removal pass.
#pop.cs: Population estimate by Carle-Strub method.

# 1. Did it load?

head(TroutRemoval)
tail(TroutRemoval)

# 2. Check data types

sapply(TroutRemoval, class)

# 3. Check for missing or impossible values 

plot(TroutRemoval$first)
plot(TroutRemoval$second)
plot(TroutRemoval$third) # One value is a bit of an outlier. Investigate

TroutRemoval %>% 
  filter(third>100) # Third pass is consistent with other passes. Probably fine

plot(TroutRemoval$fourth)
plot(TroutRemoval$pop.cs)

# There are some NA's but that's okay - they don't always do all four passes.

# 4. Check for typos and broken factors 

levels(TroutRemoval$species)
levels(TroutRemoval$stream) # all good

###################
# Begin plotting  #
###################

# Let's make a simple dot plot connected by lines
# on X: Removal #
# on Y: Total removed

# Problem: The data are wide format. First, must manipulate

# when doing removals, scientists do several "passes" through a river. So let's organize by a variable called
# "removalpass"

LongTrout <- gather(TroutRemoval, key = removalpass, value = "catch", 3:6) 


a <- ggplot(LongTrout, aes(x = removalpass, y = catch, colour = species, group = species)) +
  geom_point() + geom_line() +
  theme_bw() +
  xlab("Removal pass") + 
  ylab("No. individuals caught per pass") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  )

print(a)
# First problem: Fourth should be on the right.

# Explicitly order the factors
LongTrout$removalpass <- factor(LongTrout$removalpass, levels= c("first", "second", "third", "fourth"))

# It's still wrong. 

# The problem is that one species can occur in more than one stream - meaning you've got multiple dots of the same colour
# Lines, therefore, aren't being plotted correctly.

# Wrap by stream

a <- ggplot(LongTrout, aes(x = removalpass, y = catch, colour = species, group = species)) +
  geom_point() + geom_line() +
  theme_bw() +
  xlab("Removal pass") + 
  ylab("No. individuals caught per pass") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) + facet_wrap(~stream) 
a

# Log scale
a <- ggplot(LongTrout, aes(x = removalpass, y = catch, colour = species, group = species)) +
  geom_point() + geom_line() +
  theme_bw() +
  xlab("Removal pass") + 
  ylab("No. individuals caught per pass") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) + facet_wrap(~stream) + scale_y_log10()
a

# Allow scales to vary
a <- ggplot(LongTrout, aes(x = removalpass, y = catch, colour = species, group = species)) +
  geom_point() + geom_line() +
  theme_bw() +
  xlab("Removal pass") + 
  ylab("No. individuals caught per pass") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) + facet_wrap(~stream, scales = "free") 
a


# Wrap by species
a <- ggplot(LongTrout, aes(x = removalpass, y = catch, colour = stream, group = stream)) +
  geom_point() + geom_line() +
  theme_bw() +
  xlab("Removal pass") + 
  ylab("No. individuals caught per pass") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) + facet_wrap(~species) 
a

#################
# Next plot     #
#################

# What are population sizes across streams?

a <- ggplot(LongTrout, aes(x = stream, y = pop.cs)) +
  geom_point() + 
  theme_bw() +
  xlab("stream") + 
  ylab("Carle-Strub population estimate") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) 
a

# Not enough info. Let's add colour


a <- ggplot(LongTrout, aes(x = stream, y = pop.cs, colour=species, group=species)) +
  geom_point() + 
  theme_bw() +
  xlab("stream") + 
  ylab("Carle-Strub population estimate") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
a

# Still too busy

#Next:

a <- ggplot(LongTrout, aes(x = stream, y = pop.cs)) +
  geom_point() + 
  theme_bw() +
  xlab("stream") + 
  ylab("Carle-Strub population estimate") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) + 
  facet_wrap(~species) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

a

# Next

a <- ggplot(LongTrout, aes(x = species, y = pop.cs)) +
  geom_point() + 
  theme_bw() +
  xlab("stream") + 
  ylab("Carle-Strub population estimate") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) + 
  facet_wrap(~stream) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

a

# Also colour code species:
a <- ggplot(LongTrout, aes(x = species, y = pop.cs, colour=species, group=species)) +
  geom_point() + 
  theme_bw() +
  xlab("stream") + 
  ylab("Carle-Strub population estimate") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) + 
  facet_wrap(~stream) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

a

######################################################
# Next example: multipanel with two separate figures #
######################################################

# Multiplot allows you to plot more than one figure in a single plot. 

# Let's make two plots.

# 1) Boxplot comparing population sizes across streams

a <- ggplot(LongTrout, aes(x = stream, y = pop.cs)) +
  geom_boxplot() + 
  theme_bw() +
  xlab("stream") + 
  ylab("Carle-Strub population estimate") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

a

# 2) Boxplot comparing population size of each species across stream

b <- ggplot(LongTrout, aes(x = species, y = pop.cs)) +
  geom_boxplot() + 
  theme_bw() +
  xlab("species") + 
  ylab("Carle-Strub population estimate") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

b

# Plot these together with multiplot()

multiplot(a,b)

multiplot(b,a)

multiplot(a,b, cols=2)

# 3-panel plot:

multiplot(a,b,a, cols=2)

####################################
# Plotting model output in ggplot2 #
####################################

# Let's figure out a line of best fit
# base plot

plot(sl ~ tl, data = pallid)

fit <- lm(sl ~ tl, data = pallid)

abline(fit)


# Using the pallid dataset:

a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point() + 
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) +
  stat_smooth(method = "lm", col="red") 

a

# Specify the confidence interval
a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point() + 
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) +
  stat_smooth(method = "lm", col="red", level=0.95) 

a

# Specify the confidence interval
a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point() + 
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) +
  stat_smooth(method = "lm", col="red", level=0.95) 

a

#Try to plot outside the range

a <- ggplot(pallid, aes(x = tl, y = sl)) +
  geom_point() + 
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Standard length (mm)") +
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
  ) +
  stat_smooth(method = "lm", col="red", level=0.95) + #Disable CI by going se=FALSE
  xlim(0, 1700)

a


