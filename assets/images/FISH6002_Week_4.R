# R Code for Week 4: Displaying Data Visually
# FISH 6002

# Started March 13, 2017
# Major revision, Sept 29, 2017

######################
# LOAD PACKAGES      #
######################

#install.packages("lubridate") #Run if needed
#install.packages("ggplot2")
library(lubridate)
library(ggplot2)
library(dplyr)
library(reshape2)


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

CarData <- read.csv("/MYPATH/6002Week4_BrettsCar.csv")

head(CarData) #Did it load?

sapply(CarData, class) #Are the data types right?

# A few problems here:
# First, mixed characters in TimeIdle_Percent

plot(TimeIdle_Percent ~ TripDistance_KM, data=CarData) 
# oh no!

CarData$TimeIdle_Percent <- as.numeric(
     sub("%", "", CarData$TimeIdle_Percent)
  )
# 1. Return a NUMERIC value of...
# 2. The variable TimeIdle_Percent, within CarData, wherein we have...
# 3. SUBstituted every instance of the "%" character, for nothing (as expressed by "")
# 4. Assign the above numeric value (without the %) to TimeIdle_Percent, thereby overwriting the original variable in the dataframe

head(CarData$TimeIdle_Percent) #phew
class(CarData$TimeIdle_Percent)

plot(TimeIdle_Percent ~ TripDistance_KM, data=CarData) 


# Second, there are missing values in TotalEConsumed_Lper100KMeq. Let's just leave that alone for now

# Third, Date and Duration are both factors. What happens when we try to plot date vs. temperature, for example?

plot(AmbientTemperature_C ~ Date, data=CarData) 
# Yuck

# This is a very common problem. Fix with the lubridate package:


#Lubridate converts date and time items into usable data types in R

head(CarData$Date)

#Here we see that our dates are expressed as Month, Day, Year, followed by Hour, Minute, Second.

#Convert it to a Lubridate object as follows:
CarData$Date <- mdy_hms(CarData$Date, tz="America/St_Johns")

# Lubridate is smart enough to interpret September, Sept, or 08 all as the eighth month of the year.
# Furthermore, by setting the time zone (tz) it retains the correct time zone (data were collected here in St. John's)
# If you needed to convert to another time zone, you could do so by going with_tz(VARIABLE, tz = "OTHER TIMEZONE")
# To see all locales, type OlsonNames()

#Let's see what R says the data type is now: 
class(CarData$Date) 
CarData$Date

plot(AmbientTemperature_C ~ Date, data=CarData) #Much better!
# Now it's treating the date and time like an actual continuous variable.

# You can do a LOT with the data in this format: https://rpubs.com/davoodastaraky/lubridate

# It's an even bigger problem with dateless durations:

plot(ElectricityConsumed_KWH ~ Duration, data=CarData) 

# It's treating each individual duration as a factor. When there is more than one occurence at a specific
# duration it makes a little boxplot :(

# Let's fix it
CarData$Duration <- hms(CarData$Duration)
CarData$Duration

plot(ElectricityConsumed_KWH ~ Duration, data=CarData) #wee much better!
# Lubridate was great because it interpreted a weird text format correctly for us
# But mathematically it would be nice to just deal in seconds
# So let's convert it from a Lubridate item to a standard numeric value:

CarData$Duration <- as.numeric(CarData$Duration)

head(CarData$Duration)
# Each value is now the number of seconds the car was operating for.
# This enables easy calculation of the duration in minutes and hours:

CarData <- CarData %>%
    mutate(DurationM = Duration/60) %>%
    mutate(DurationH = Duration/3600) 


# Recall that 'mutate' ADDS a new variable and populates it as specified
 #Note use of pipes to build two variables as above

plot(ElectricityConsumed_KWH ~ DurationM, data=CarData) # Minutes
plot(ElectricityConsumed_KWH ~ DurationH, data=CarData) # Hours

sapply(CarData, class) #Are the data types right?

# Let's add one more variable, which we will use later

CarData <- CarData %>%
  mutate(IsItCold = ifelse(AmbientTemperature_C <= 11, "Cold", "Not cold"))
#IsItCold: It's cold if it's less than or equal to 11 C, otherwise not cold.       

############################################ 
# Okay, everything is loaded. Let's begin  #
############################################

# Going forward, we will replicate some plots in base and ggplot2.

#########################
# Plotting ONE variable #
#########################

#By default, the plot command will pick a plot type for you based on the variables you include
plot(CarData$AverageSpeed_kmh)

hist(CarData$AverageSpeed_kmh)

hist(CarData$AverageSpeed_kmh, breaks=20)

hist(CarData$AverageSpeed_kmh, breaks=20, right=FALSE) 

#What does this do?

hist(CarData$AverageSpeed_kmh, breaks=c(0,10,20,30,40,50,60,70,80,90,100,110))

hist(CarData$AverageSpeed_kmh, breaks=c(0,10,20,30,40,50,60,70,80,90,100))
hist(CarData$AverageSpeed_kmh, breaks=c(0,1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100))

hist(CarData$AverageSpeed_kmh, breaks=20)

# how is hist calculating things?
HistInfo <- hist(CarData$AverageSpeed_kmh)
HistInfo

hist(CarData$AverageSpeed_kmh)

# Okay, now it's GGPLOT2 time!

a <- ggplot(CarData, aes(AverageSpeed_kmh)) +
  geom_histogram()

a

a <- ggplot(CarData, aes(AverageSpeed_kmh)) +
  geom_histogram() +
  coord_flip()

a

#Other one-variable plots

a <- ggplot(CarData, aes(AverageSpeed_kmh)) +
  geom_density() 

a

a <- ggplot(CarData, aes(AverageSpeed_kmh)) +
  geom_dotplot() 

a

a <- ggplot(CarData, aes(AverageSpeed_kmh)) +
  geom_freqpoly() 

a
###
# Let's plot one variable, where that variable is discrete
###

# How often was it cold, versus not cold? First, base plot

head(CarData$IsItCold)

plot(CarData$IsItCold) 
#This won't work. Why?

table(CarData$IsItCold) #Returns count in each level
barplot(table(CarData$IsItCold)) 

class(CarData$IsItCold) #oh right, it's a character

plot(as.factor(CarData$IsItCold))

# GGplot is easier, let's use that instead

a <- ggplot(CarData, aes(IsItCold)) +
  geom_bar()

a

# Let's MISuse a barplot

# Data prep:

# Perform an operation on CarData
temp <- CarData %>%
  #First, group by the variable IsItCold
    group_by(IsItCold) %>%
  #Next, summarize both groups as specified (here, we want the average top speed per trip).
  # Call this calculated variable AverageMaxSpeed
  # Also calculate standard error
    summarize(AverageMaxSpeed = mean(MaxSpeed_kmh), SE = (sd(MaxSpeed_kmh)/sqrt(length(MaxSpeed_kmh))) )

# Store the output in temp

a <- ggplot(temp, aes(x=IsItCold, y=AverageMaxSpeed)) +
  geom_bar(stat="identity") 
#Stat = identity tells us to use the VALUE not the count

a

# 

# Really, only the height matters
a <- ggplot(temp, aes(x=IsItCold, y = AverageMaxSpeed)) +
  geom_point() +
  scale_y_continuous(limits = c(0,70))

a

# Emphasizing contrast
a <- ggplot(temp, aes(x=IsItCold, y = AverageMaxSpeed)) +
  geom_point() 

a
# add information

a + geom_errorbar(aes(ymax = AverageMaxSpeed+SE, ymin = AverageMaxSpeed-SE),position = "dodge")

## Okay, let's move into a formal exploration of two-variable plots.

###########################
# Two-variable plots      # 
###########################

# X: Is it cold? DISCRETE
# Y: Average max speed CONTINUOUS
# Go back to the full dataset)

a <- ggplot(CarData, aes(x=IsItCold, y=MaxSpeed_kmh)) +
  geom_boxplot()

# Boxplot with raw dots overlaid, with jitter

a <- ggplot(CarData, aes(x=IsItCold, y=MaxSpeed_kmh)) +
  geom_boxplot(outlier.colour="NA") + # Do not show outliers
  geom_jitter(width=0.2, alpha=0.6) #What happens if we use geom_point?

# Other variants

a <- ggplot(CarData, aes(x=IsItCold, y=MaxSpeed_kmh))

a + geom_violin()
a + geom_dotplot(binaxis="y", stackdir="center", dotsize=0.3)

#Base plot version

boxplot(MaxSpeed_kmh ~ IsItCold, data=CarData)

#########################################
# TWO VARIABLE CONTINUOUS VS CONTINUOUS #
#########################################


#Let's see if effiency is related to temperature
plot(TotalEConsumed_Lper100KMeq ~ AmbientTemperature_C, data=CarData)

#ggplot2 version
a <- ggplot(CarData, aes(y=TotalEConsumed_Lper100KMeq, x=AmbientTemperature_C))
a + geom_point()

#This is a continuous variable by a continuous variable. Default is a SCATTERPLOT

plot(TotalEConsumed_Lper100KMeq ~ TripDistance_KM, data=CarData)

plot(TotalEConsumed_Lper100KMeq ~ ElectricityConsumed_KWH, data=CarData)

#What if you want to compare several scatterplots?
pairs(~TotalEConsumed_Lper100KMeq+
        TripDistance_KM+
        AmbientTemperature_C+
        AverageSpeed_kmh, data=CarData)



