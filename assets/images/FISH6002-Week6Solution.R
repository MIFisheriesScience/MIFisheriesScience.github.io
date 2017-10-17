# Fish 6002 - Week 6 assignment
# Solution

# Oct 14, 2017

library(lubridate)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(tidyr)

setwd("C:/Users/bfavaro/Google Drive/MI SOF Courses/FISH 6002 - Data collection mgmt and display/Week 6 - Working with messy data/")
#setwd("YOURPATH")

InchLake <- read.csv("InchLake2-Broken.csv")

##################
# 1. Data types  #
##################

#netID: A unique identifier for the sampling event (more than one can share)
#fishID: A unique identifier for the individual fish (can't be duplicated)
#species: Species name
#length: Total length (inches to nearest 0.1)
#weight: Wet weight (grams to nearest 0.1)
#year: Year of capture

head(InchLake)
tail(InchLake)

InchLakeFixed <- InchLake %>%
  select(-X) %>% 
  slice(1:516) # Note: Check to see if this was a result of shifting down

head(InchLakeFixed)
tail(InchLakeFixed)

sapply(InchLakeFixed, class)

# Problems with weight and possibly year

levels(InchLakeFixed$year)
levels(InchLakeFixed$year) <- list("2007"=c("2007", "2O07"), "2008"=c("2 008", "2048", "2008"))

InchLakeFixed$year <- as.numeric(as.character(InchLakeFixed$year))

levels(InchLakeFixed$weight)

InchLakeFixed$weight <- as.character(InchLakeFixed$weight)
InchLakeFixed$weight <- gsub(",", 
                       "", 
                       InchLakeFixed$weight)

InchLakeFixed$weight <- as.numeric(InchLakeFixed$weight)

# Data types now fine

head(InchLakeFixed)


##################################
# 3. Check for impossible values #
##################################

range(InchLakeFixed$weight) #seems fine
plot(InchLakeFixed$weight) # there are big species and smaller species. Not crazy

range(InchLakeFixed$length) #negative value?
# also length is in inches. 800 inches is 66 feet - an impossible value (even whale sharks max out at ~40 ft) 

plot(InchLakeFixed$length)

# Let's get rid of the negative, and remove two zeroes from 800

InchLakeFixed <- InchLakeFixed %>%
  mutate(length = ifelse(length < 0, length*-1, length)) %>% 
  mutate(length = ifelse(length == 800, 8, length))

# Are there duplicates in Fish ID?

plot(
  table(InchLakeFixed$fishID)
  ) #uh oh

InchLakeFixed %>% 
  group_by(fishID) %>% 
  filter(n()>1) # Problem is Fish 517

#Change two to unique values. In my case, I'll use the real values. 

InchLakeFixed <- InchLakeFixed %>%
  mutate(fishID = ifelse(fishID==517 & length==2.2, 516, fishID)) %>% 
  mutate(fishID = ifelse(fishID==517 & length==9.0, 222, fishID))


##################################################
# STEP 4: Check for typos and broken factors     #
##################################################
head(InchLakeFixed)

levels(InchLakeFixed$species)
plot(InchLakeFixed$weight ~ InchLakeFixed$species)

levels(InchLakeFixed$species) <- list("Black Crappie"=c("Black Crapie", "Black Crappie"), 
                                   "Bluegill"=c("bluegill", "Bluegill", "Bluegill "),
                                   "Bluntnose Minnow" = c("Bluntnose Minnow"), 
                                   "Fathead Minnow" = c("Fathead Minnow"),
                                   "Iowa Darter" = c("Iowa Darter", "Iowa_Darter "),
                                   "Largemouth Bass" = c("Largemout Bass", "Largemouth Bass"),
                                   "Pumpkinseed" = c("Pumpkinseed"),
                                   "Tadpole Madtom" = c("Tadpole Madtom"),
                                   "Yellow Perch" = c("Yellow Perch")
                                   )

################################################
# Step 5: Check for correctness                #
################################################

InchLakeClean <- read.csv("InchLake2-Clean.csv")

all.equal(InchLakeClean, InchLakeFixed)
