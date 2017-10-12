# R Code for Week 5: Displaying Data Visually, Part 2
# FISH 6002

# Oct 10, 2017

library(lubridate)
library(ggplot2)
library(dplyr)
library(reshape2)
library(ggthemes)
library(tidyr)

#######################
# Load some data      #
#######################

# The dataset:
# My 2012 Chevrolet Volt plug-in hybrid has a tracker unit that records every trip the car takes
# Here, we have a subset of data from Aug 3, 2017, to Sept 29, 2017 of nearly every use of our car
# Each row of data is one observation - one TRIP taken where a trip starts when the car is turned on, 
# and stops when the car is turned off.

# The data included in the spreadsheet are as follows, and are as outputted directly by the tracker's software:

# Date: The date and time at which the trip took place
# Duration: The duration, in h:mm:ss of the trip
# TripDistance_KM: The total linear distance of the trip, in km
# FuelConsumed_L: The number of liters of gasoline consumed on the trap
# FuelConsumption_Lper100KM: The number of liters of gasoline consumed per 100 km on that trip
# ElectricityConsumed_KWH: The number of kilowatt-hours of electricity consumed on that trip
# TotalEConsumed_Lper100KMeq: The liters per 100 km-equivalent of energy consumed, as calculated by the tracker
# StartSOC: State of Charge at the start of the trip, expressed as a % of total battery capacity
# EndSOC: State of Charge at the end of the trip, expressed as a % of total battery capacity
# AmbientTemperature_C: The average air temperature during the trip
# AverageSpeed_kmh: Mean speed during the trip
# MaxSpeed_kmh: Maximum speed achieved during the trip
# AuxiliaryLoad_KWH: The number of kilowatt-hours of electricity used to power the car's auxillary systems (e.g. heating)
# HardAccel_Percent: Percentage of all acceleration on the trip classified as "hard" (i.e. accelerating quickly)	
# HardBraking_Percent: Percentage of all braking on the trip classified as "hard" (i.e. braking intensely)
# TimeIdle_Percent: Percentage of time on that trip spent idling (i.e. not making forward progress)

CarData <- read.csv("C:/Users/bfavaro/Google Drive/MI SOF Courses/FISH 6002 - Data collection mgmt and display/Week 5 - Data display 2/BrettsCar.csv")

# Remove % from time idle
CarData$TimeIdle_Percent <- as.numeric(
  sub("%", "", CarData$TimeIdle_Percent)
)

# Convert the date column to a Lubrdiate formatted date and time
CarData$Date <- mdy_hms(CarData$Date, tz="America/St_Johns")

# Read Durations as seconds
CarData$Duration <- hms(CarData$Duration)
CarData$Duration <- as.numeric(CarData$Duration)

# Make versions of Duration expressed as minutes or hours
CarData <- CarData %>%
  mutate(DurationM = Duration/60) %>%
  mutate(DurationH = Duration/3600) 

# Add IsItCold variable
CarData <- CarData %>%
  mutate(IsItCold = ifelse(AmbientTemperature_C <= 11, "Cold", "Not cold"))

CarData$IsItCold <- as.factor(CarData$IsItCold)

#####################################
# Basic plot decoration - base plot #
#####################################

# A basic plot
plot(MaxSpeed_kmh ~ TripDistance_KM, data=CarData)

# Let's start by changing the RANGE
# Let's take the log of the X value

plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData) 
#Note that I'm transforming the variable being plotted
# NOTE: need to verify transformation. See section below.

# First, let's make the axis labels meaningful

plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", #Note the comma
     ylab = "Maximum speed (km/h)"
     ) 

# Make the fonts and labels bigger

# cex

plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, #Changes the size of the POINTS
     cex.axis = 1.5, #Changes the size of the AXIS TICKS
     cex.lab = 1.5 # Changes the size of the AXIS LABELS
)

# Rotate the Y axis tick labels

plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData, 
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)", 
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5, 
     las = 2     # 1 makes all labels vertical. Try 0, and 2
  )

# Change the axis ranges
plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5,
     las = 1,
     xlim=c(0,5),
     ylim=c(0,150)
)

# Change the axis ranges
plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5,
     las = 1,
     xlim=c(0,5),
     ylim=c(150,0) #What does this do?
)


# Select different types of points
plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5,
     las = 1,
     pch = 16 # pch selects a specific type of dot
)

# You can put text into pch
plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5,
     las = 1,
     pch = "P"
)

#######################################
# A plot showing all pch symbols
y=rev(c(rep(1,6),rep(2,5), rep(3,5), rep(4,5), rep(5,5)))
x=c(rep(1:5,5),6)
plot(x, y, pch = 0:25, cex=1.5, ylim=c(1,5.5), xlim=c(1,6.5), 
     axes=FALSE, xlab="", ylab="", bg="blue")
text(x, y, labels=0:25, pos=3)
########################################



# Control colour
plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5,
     las = 1,
     pch = 16,
     col="red" #You can use words for common colours
)

plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5,
     las = 1,
     pch = 16,
     col= 2 #... you can also use numbers
)

plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5,
     las = 1,
     pch = 16,
     col= "#FF0000" #... you can also use 
     #hexadecimal RGB colours
)

plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5,
     las = 1,
     pch = 16,
     col= "#FF0000",
     col.lab="blue",
     col.axis="darkgreen"
)

# Add a colour ramp, with legend

rbPal <- colorRampPalette(c('red','blue'))
CarData$Col <- rbPal(10)[as.numeric(
  cut(CarData$TimeIdle_Percent,breaks = 20))] 

plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=CarData,
     xlab = "Trip distance (log km)", 
     ylab = "Maximum speed (km/h)",
     cex = 1.5, 
     cex.axis = 1.5, 
     cex.lab = 1.5,
     las = 1,
     pch = 16,
     col= CarData$Col,
     col.lab="blue",
     col.axis="darkgreen"
)

# We need to add a legend
legend("topleft",
       title="Time Idle (percentage)",
       legend= c("0%", "50%", "100%"),
       col=rbPal(3), 
       pch=16,
       cex=1.2
       )

# This shows a philosophy with base plot - that of layering
# You make the plot first, then you add additional elements to it. 

# Let's add some text to the above plot

#Add text within the plot space with text()
text(x=2, y=20, "hello!")

# You can plot more than one piece of text at once
text(x=c(-2, 0, 2), y=10, c("One", "one point five", "two"))

# You can plot within the MARGINS with mtext()
mtext("Margin text - top", side=3)
mtext("Margin text - left", side=2)
mtext("Margin text - bottom", side=1)
mtext("Margin text - right", side=4)

#################################################################
# Brief aside: Whenever you make a transformation ALWAYS verify #
#################################################################

range(CarData$TripDistance_KM) # We have two zero values
# that is, trips where we went nowhere, where we ONLY idled.
# What happens when you take a log of zero?

min(CarData$TripDistance_KM) #zero

log(0)

log(min(CarData$TripDistance_KM)) # returns -Inf

# When you plot the log of TripDistance_KM, it just drops Inf values
# How many INF values are there?



table(
  is.infinite(log(CarData$TripDistance_KM)) 
) 
# Returns 2. So plotting by the log of TripDistance_KM would drop TWO values.

#Contrast with:
# is.finite - to detect finite values 
# is.nan - to detect NA's (missing values)

# How do you get around this? 
#
# 1) Choose a different transformation
# 2) Accept that a few values will be lost due to transformation
# (If you're going to do 2, better to filter so you only plot range that you want)

temp <- CarData %>%
  filter(TripDistance_KM > 0)

plot(MaxSpeed_kmh ~ log(TripDistance_KM), data=temp)  

# 3) For log specifically: add a constant

plot(MaxSpeed_kmh ~ log(TripDistance_KM+0.01), 
     data=CarData) 

plot(MaxSpeed_kmh ~ log10(TripDistance_KM+0.01), 
     data=CarData) 

log(0.01)

log10(0.01)



####################################################################################


#################################
# Let's make another plot type  #
#################################

boxplot(MaxSpeed_kmh ~ IsItCold, data=CarData)

#Basic clean-up
boxplot(MaxSpeed_kmh ~ IsItCold, data=CarData,
        ylab="Maximum speed achieved in a trip (km/h)",
        xlab="Temperature",
        cex.axis=1.5,
        cex.lab=1.5,
        las=1
        )

# Hmm temperature is a bit vague, can we change it?

# Method 1: Cosmetic only
boxplot(MaxSpeed_kmh ~ IsItCold, data=CarData,
        ylab="Maximum speed achieved in a trip (km/h)",
        xlab="Temperature",
        xaxt="n",
        cex.axis=1.5,
        cex.lab=1.5,
        las=1
)

axis(1, at=1:2, 
     labels=c(expression("<= "*11~degree*C), 
              expression("> "*11~degree*C)),
     font=1,
     lwd=2
     )
                                    
# Method 2: Alter the factor

# We could change the actual factor label
CarData$IsItColdTransformed <- factor(CarData$IsItCold, levels=c("Cold", "Not cold"),
                                      labels=c("<= 11 degree C", 
                                               "> 11 degree C"))
# Note that you can't include the actual degree symbol here

boxplot(MaxSpeed_kmh ~ IsItColdTransformed, data=CarData,
        ylab="Maximum speed achieved in a trip (km/h)",
        xlab="Temperature",
        cex.axis=1.5,
        cex.lab=1.5,
        las=1
)


# What if you need to reorder?

# Method 1: Use the relevel command

CarData$IsItColdRelevelled <- relevel(CarData$IsItCold, ref = "Not cold")

boxplot(MaxSpeed_kmh ~ IsItColdRelevelled, data=CarData,
        ylab="Maximum speed achieved in a trip (km/h)",
        xlab="Temperature",
        cex.axis=1.5,
        cex.lab=1.5,
        las=1
)


# Method 2: Use the factor command again

CarData$IsItColdRelevelled <- factor(CarData$IsItCold, levels=c("Not cold", "Cold"))
# You could also add labels = c("X", "Y") to change the labels too

boxplot(MaxSpeed_kmh ~ IsItColdRelevelled, data=CarData,
        ylab="Maximum speed achieved in a trip (km/h)",
        xlab="Temperature",
        cex.axis=1.5,
        cex.lab=1.5,
        las=1
)

# Let's decorate our boxplots

# It works basically the same way as with the scatterplots

boxplot(MaxSpeed_kmh ~ IsItColdRelevelled, data=CarData,
        ylab="Maximum speed achieved in a trip (km/h)",
        xlab="Temperature",
        cex.axis=1.5,
        cex.lab=1.5,
        las=1,
        col="lightblue", # fill the boxplot
        lwd=4, #Change the width of the lines
        lty=2, # Change the line types around the boxplot
        border="red", #Change the line colour
        boxwex = 0.25 #Change the boxplot width
)

# Let's make a plot for publication:
# Figs are exported at 72 pixels per inch by default
# Most journals require 300 ppi

#Simplest possible example:

tiff("TestPlotTiff.tif", res=72)

boxplot(MaxSpeed_kmh ~ IsItColdRelevelled, data=CarData,
        ylab="Maximum speed achieved in a trip (km/h)",
        xlab="Temperature",
        las=1,
        col="lightgreen"
)

dev.off()

# PLOS One-style version:

tiff("TestPlotTiff.tif", 
     res=300, # The resolution. Must be 300 for most journals
     width = 1800, # Figure width in px
     height = 1800, # Figure height in px
     units = "px", #Default. Can also be cm, mm, or in,
     compression="lzw", #see ?tiff for more. LZW standard
     pointsize = 16
     )

boxplot(MaxSpeed_kmh ~ IsItColdRelevelled, data=CarData,
        ylab="Maximum speed achieved in a trip (km/h)",
        xlab="Temperature",
        las=1,
        col="lightgreen"
)

dev.off()




#######################################
# Okay - GGPLOT time                  #
#######################################

# ggplots are a combination of data, one or more GEOMS, and a coordinate system

a <- ggplot(CarData, aes(x = TripDistance_KM, y = MaxSpeed_kmh))

print(a)

a + geom_point()

a + scale_x_log10() #Ah ha! Doesn't work :(

# Need to plot ONLY values above zero
CarDataNoZeroes <- CarData %>%
  filter(TripDistance_KM > 0)

a <- ggplot(CarDataNoZeroes, aes(x = TripDistance_KM, y = MaxSpeed_kmh)) +
  geom_point() +
  scale_x_log10() 
  
print(a)

a + scale_y_reverse()

a <- ggplot(CarDataNoZeroes, aes(x = TripDistance_KM, y = MaxSpeed_kmh)) +
  geom_point(colour="blue",
             fill="red",
             shape=24,
             size=12) +
  scale_x_log10() 
a

a <- ggplot(CarDataNoZeroes, aes(x = TripDistance_KM, y = MaxSpeed_kmh)) +
  geom_point(alpha=0.4,
             colour="blue",
             shape=16,
             size=8) +
  scale_x_log10() +
  xlab("Trip distance (km)") +
  ylab("Maximum speed per trip (km/h)")
a

a <- ggplot(CarDataNoZeroes, aes(x = TripDistance_KM, y = MaxSpeed_kmh)) +
  geom_point(alpha=0.4, colour="blue", shape=16, size=2) + 
  scale_x_log10() +
  xlab("Trip distance (km)") +
  ylab("Maximum speed per trip (km/h)") 

a + theme(axis.text=element_text(size=12),
        axis.title = element_text(size=14)
        )

a + theme(axis.text=element_text(size=20, face="bold", angle=45),
          axis.title = element_text(size=32, face="bold")
)

#theme_grey is default

a + theme_bw()
a + theme_classic()
a + theme_minimal()

# ggthemes
# See: https://github.com/jrnold/ggthemes/blob/master/README.md 

a + theme_tufte()

a + theme_excel()
a + theme_fivethirtyeight()
a + theme_wsj()

# Customize the axes

a + theme_tufte() +
  theme(axis.text=element_text(size=16),
        axis.title = element_text(size=18)
  )

#Now, let's do a colour scale

a <- ggplot(CarDataNoZeroes, aes(x = TripDistance_KM, y = MaxSpeed_kmh)) +
  geom_point(aes(colour = CarDataNoZeroes$TimeIdle_Percent), shape=16, size=2) +
  scale_x_log10() +
  xlab("Trip distance (km)") +
  ylab("Maximum speed per trip (km/h)") 

a

# Let's fix a few things:
# 1: Make idling go from red (low) to blue (high idling)
# 2: apply the Tufte ggplot theme
# 3: Fix the axis label sizes
# 4: Fix the legend

a <- ggplot(CarDataNoZeroes, aes(x = TripDistance_KM, y = MaxSpeed_kmh)) +
  geom_point(aes(colour = CarDataNoZeroes$TimeIdle_Percent), shape=16, size=2) +
  scale_colour_gradient(low="red", high="blue", name = "Percent \ntime idle") +
  scale_x_log10() +
  xlab("Trip distance (km)") +
  ylab("Maximum speed per trip (km/h)") +
  theme_tufte() +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=18),
        legend.text = element_text(size=12),
        legend.title = element_text(size=14)
        ) 

# Fixing the colour ramp

a <- ggplot(CarDataNoZeroes, aes(x = TripDistance_KM, y = MaxSpeed_kmh)) +
  geom_point(aes(colour = CarDataNoZeroes$TimeIdle_Percent), shape=16, size=2) +
  scale_colour_gradient2(low="red",  mid="blue", high="cyan", midpoint=30, name = "Percent \ntime idle") +
  scale_x_log10() +
  xlab("Trip distance (km)") +
  ylab("Maximum speed per trip (km/h)") +
  theme_tufte() +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=18),
        legend.text = element_text(size=12),
        legend.title = element_text(size=14)
  ) 

a

########################
# Statistical elements #
########################
###################
# ggplot2 boxplot #
###################

a <- ggplot(CarDataNoZeroes, aes(x = IsItCold, y = MaxSpeed_kmh)) +
  geom_boxplot() +
  theme_tufte() +
  xlab("Temperature") +
  ylab("Maximum speed per trip (km/h)") +
  scale_x_discrete(labels = c(expression("<= "*11~degree*C), 
             expression("> "*11~degree*C))) +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=18)) 

a

a <- ggplot(CarDataNoZeroes, aes(x = IsItCold, y = MaxSpeed_kmh)) +
  geom_boxplot(outlier.colour = NA) +
  geom_jitter(width = 0.2, alpha=0.25) +
  theme_tufte() +
  xlab("Temperature") +
  ylab("Maximum speed per trip (km/h)") +
  scale_x_discrete(labels = c(expression("<= "*11~degree*C), 
                              expression("> "*11~degree*C))) +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=18)) 

a

###################################### 
# Back to scatterplots: Adding stats #
######################################

a <- ggplot(CarDataNoZeroes, aes(x = TripDistance_KM, y = MaxSpeed_kmh)) +
  geom_point() +
  scale_x_log10() +
  xlab("Trip distance (km)") +
  ylab("Maximum speed per trip (km/h)") +
  theme_tufte() +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=18),
        legend.text = element_text(size=12),
        legend.title = element_text(size=14)
  ) +
  stat_smooth()

a + stat_smooth()

#################
# Saving plots  #
#################

ggsave("TestPlot.tiff", 
       width=12, 
       height = 12,
       units="cm",
       dpi = 300,
       compression = "lzw"
       )

getwd()

################## 
# Plotting pairs #
##################

# How often do I run the battery down from start to finish?

SOCdata <- CarData %>%
  mutate(PairNumber = row_number()) %>% #Add a counter for each row
  gather(ChargeType, StateOfCharge, StartSOC:EndSOC) #

SOCdata$ChargeType <- factor(SOCdata$ChargeType, levels=c("StartSOC", "EndSOC"),
                                      labels=c("Start of trip", "End of trip"))

a <- ggplot(SOCdata, aes(x = ChargeType, y = StateOfCharge)) +
  geom_point() +
  geom_line(aes(group = PairNumber)) +
  xlab("") +
  ylab("State of Charge (percent)") +
  theme_tufte() +
  theme(axis.text = element_text(size=18),
        axis.title = element_text(size=24)
  ) 

a

# Let's add some more information
# Black = no change in charge
# Red = maximum decreases in charge
# Need a new variable

SOCdata <- CarData %>%
  mutate(PairNumber = row_number()) %>% 
  mutate(ChargeChange = EndSOC-StartSOC) %>%
  gather(ChargeType, StateOfCharge, StartSOC:EndSOC) 

SOCdata$ChargeType <- factor(SOCdata$ChargeType, levels=c("StartSOC", "EndSOC"),
                             labels=c("Start of trip", "End of trip"))


a <- ggplot(SOCdata, aes(x = ChargeType, y = StateOfCharge)) +
  geom_point(aes(colour = SOCdata$ChargeChange), shape=16, size=2) +
  scale_colour_gradient(low="red", high="black", name = "Percent change \nin charge") +
  geom_line(aes(group = PairNumber, colour=SOCdata$ChargeChange)) +
  xlab("") +
  ylab("State of Charge (percent)") +
  theme_tufte() +
  theme(axis.text = element_text(size=18),
        axis.title = element_text(size=24)
  ) 

a

#######################################
# Proportions                         #
#######################################

# What proportion of each trip's energy usage is auxillary vs. driving power?
# I am assuming auxillary load is SEPARATE (and not a subset of) 
# energy consumed during driving - need to confirm

# First, let's see how that proportion is different across cold and hot conditions

Percentages <- CarData %>%
  group_by(IsItCold) %>%
  summarise(TotalAux = sum(AuxiliaryLoad_KW), DrivingE = sum(ElectricityConsumed_KWH),
            AuxProp = TotalAux / (TotalAux + DrivingE),
            EProp = 1-AuxProp) %>%
  gather(EType, Proportion, AuxProp:EProp)

Percentages


a <- ggplot(Percentages, aes(x=IsItCold, y=Proportion, fill=EType)) +
  geom_bar(stat="identity", aes(fill=EType)) +
  xlab("Temperature") +
  ylab("Proportion of total energy consumption") +
  theme_tufte() +
  theme(axis.text = element_text(size=18),
        axis.title = element_text(size=24))

a

# Let's put Auxiliary on the bottom

Percentages$EType <- as.factor(Percentages$EType)
Percentages$EType <- relevel(Percentages$EType, "EProp")

#and plot again

a <- ggplot(Percentages, aes(x=IsItCold, y=Proportion, fill=EType)) +
  geom_bar(stat="identity", aes(fill=EType)) +
  xlab("Temperature") +
  ylab("Proportion of total energy consumption") +
  theme_tufte() +
  theme(axis.text = element_text(size=18),
        axis.title = element_text(size=24))

a


############################### 
# Exploring aux drain by trip #
###############################

# Need to know: Auxillary drain

CarData <- CarData %>%
  filter(ElectricityConsumed_KWH > 0) %>%
  mutate(rownum = row_number()) %>%
  mutate(AuxProp = AuxiliaryLoad_KW / (AuxiliaryLoad_KW + ElectricityConsumed_KWH)) #really, it should be kWh

# Order, low to high, by trip distance
a <- ggplot(CarData, aes(x = reorder(rownum, TripDistance_KM), y = AuxProp)) +
  geom_bar(stat="identity") +
  xlab("Relative trip distance") +
  ylab("Proportion of energy going to auxiliary systems") +
  theme_tufte() +
  theme(axis.text = element_text(size=18),
        axis.title = element_text(size=24),
        axis.text.x=element_blank(),
        axis.ticks.x = element_blank()) +
  annotate(geom="text", label="Low", 
           x=10, y=-0.05, size=10, color="black") +
  annotate(geom="text", label="High", 
           x=310, y=-0.05, size=10, color="black") 
a

# Reorder, low to high, based on temperature
a <- ggplot(CarData, aes(x = reorder(rownum, AmbientTemperature_C), y = AuxProp)) +
  geom_bar(stat="identity") +
  xlab("Ambient temperature") +
  ylab("Proportion of energy going to auxiliary systems") +
  theme_tufte() +
  theme(axis.text = element_text(size=18),
        axis.title = element_text(size=24),
        axis.text.x=element_blank(),
        axis.ticks.x = element_blank()) +
  annotate(geom="text", label="Low", 
           x=10, y=-0.05, size=10, color="black") +
  annotate(geom="text", label="High", 
           x=310, y=-0.05, size=10, color="black") 
a

reorder(CarData$rownum, CarData$AmbientTemperature_C)
