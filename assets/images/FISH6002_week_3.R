# R Code for Week 3: Tidy Data
# FISH 6002

# Started March 7, 2017

#Note the use of the rep function... this makes R repeat each of the things
# in c() three times

TrapType <- rep(c("BigTrap", "MediumTrap", "SmallTrap"), each = 3)

# Also try: TrapType <- rep(c("BigTrap", "MediumTrap", "SmallTrap"), time = 3)

CatchNum <- c(5, 4, 6, 2, 3, 2, 1, 1, 0)

TrapData <- data.frame(TrapType, CatchNum)

#Let's plot
plot(CatchNum ~ TrapType, data = TrapData) #Note use of data = ... to clean up code
#Wow! It's easy to plot tidy data!

#setwd("C:/Users/bfavaro/Google Drive/MI SOF Courses/FISH 6002 - Data collection mgmt and display/Week 3 - Intro to Tidy Data")

setwd("C:/YOURPATH")
MessyData <- read.csv("6002Week3_WideFormat.csv")

#First, let's load the appropriate package 

library(dplyr)
library(tidyr)

# Use the gather() function to go turn colums into rows

TidyData <- gather(MessyData, TrapType, Catch, BigTrap:SmallTrap)
#What is this doing?
# First, we're directing it to apply the function to MessyData
# Second, we're asking it to create a new variable called TrapType
# Third, we're asking it to create a new variable called Catch
# TrapType will be populated by the headers in columns between BigTrap and SmallTrap
# Catch will be populated by the numerical values included in those columns
# Note that Deployment is retained. We didn't tell the function to do anything to that
# so it just stays there, unaltered.

#let's make TrapType a factor...
TidyData$TrapType <- as.factor(TidyData$TrapType)

head(TidyData)
head(MessyData)

#see the difference?

#Here's how to plot TidyData
plot(TidyData$Catch ~ TidyData$TrapType)

#how would you plot MessyData? Not clear!

#Let's go back to wide format

WideFormat <- spread(TidyData, TrapType, Catch)
print(WideFormat)

############
# aside: xtable
############
install.packages("xtable")

library(xtable)

# xtable is a package that lets you create formatted output tables. 
# Most journals have specific formats required for this, but if you need a quick, nice
# table (e.g. for a presentation) you can use this.

WideFormatXtable <- xtable(WideFormat) #This gives you an xtable object

#Now, let's render this as an HTML file
print.xtable(WideFormatXtable, typ="html", file="FormattedTable.html")  

# Navigate to your working directory and open that html file. Boom, formatted table!
# You can now paste that into Word, Powerpoint, or whatever else. 

#######################
#Things you might want to do with data:

#Select only a subset that meets a given criteria:
# ONLY observations from Big Traps
TempData <- filter(TidyData, TrapType == "BigTrap")

print(TempData)

# ONLY observations from Big Traps AND with catch 6 or higher
TempData <- filter(TidyData, TrapType == "BigTrap" & Catch >= 6)

print(TempData)

# ONLY observations from Big Traps AND with catch 6 or higher OR 4 or lower
TempData <- filter(TidyData, TrapType == "BigTrap" & Catch >= 6 |
                     TrapType == "BigTrap" & Catch <= 4)

# Why wasn't it just TrapType == "BigTrap" & Catch >= 6 | Catch <= 4 ?
print(TempData)

# Paste together two columns
TempData <- unite(TidyData, DeploymentAndTrapType, Deployment, TrapType, sep=".")
#This is creating a new column called DeploymentAndTrapType, merging the old
#Deployment and TrapType columns, and separating with a period.
TempData
# Let's separate it back out.

TempData <- separate(TempData, DeploymentAndTrapType, c("Deployment", "TrapType"))

print(TempData)
# FYI, by default separate and unite both eliminate the original columns in favour of your 
# new ones. You can disable that:

TempData <- unite(TidyData, DeploymentAndTrapType, Deployment, TrapType, sep=".", remove=FALSE)
TempData <- separate(TempData, DeploymentAndTrapType, c("Deployment", "TrapType"), remove=FALSE)

# Rename a column

names(TidyData) #Tells you all the variables in TidyData

TempData <- rename(TidyData, NumberOfFishCaught = Catch) 
print(TempData) #wowee!

TempData <- select(TidyData, NumberOfFishCaught = Catch) #What does this do?
print(TempData)

#Select a column

#Here, we are selecting only TrapType and Catch
TempData <- select(TidyData, TrapType, Catch)

print(TempData) #Note this time we didn't change any names

# Play with some helper functions

# Select the rows with top 3 catch rates

TempData <- top_n(TidyData, 3, Catch)
print(TempData)

# Select columns that START WITH Trap...
TempData <- select(TidyData, starts_with("Trap"))
print(TempData)

# ... or that end with "ment" (as in deployment)
TempData <- select(TidyData, ends_with("ment"))
print(TempData)

#Select everything BUT a column:
TempData <- select(TidyData, -Deployment)

print(TempData)

################
# Okay, so we can manipulate data. Now, let's do some basic operations on it.
#
# We often need to create summary tables. Make me a table that includes two values:
# 1. The average Catch across all rows
# 2. The number of deployments (i.e. the unique values of Deployment)

#Method one: 
avg <- mean(TidyData$Catch) #Self-explanatory

NumDeployments <- length(table(TidyData$Deployment)) #Whoa, what's this??

# First, it's creating a frequency table out of TidyData$Deployment (Try it yourself)
# Next, it's calculating how many values there were in the frequency table. There are three.
# Therefore, length(table(TidyData$Deployment)) returns a value of 3. 

# Concept: What would happen if your deployments were labelled 1, 2, and 4?

SummaryTable <- data.frame(avg, NumDeployments)
print(SummaryTable)

#Okay, that worked. But can we streamline?

#Method two:

SummaryTable <- summarise(TidyData, avg=mean(Catch), NumDeployments=n_distinct(Deployment))

#n_distinct is a dplyr function that tells you the number of DISTINCT values in a vector

print(SummaryTable) #Same thing, but done in one line of code. Both equally valid approaches

# A bunch of summary functions. Try em all out
#These take a bunch of values and return ONE value

n_distinct(TidyData$Deployment)
first(TidyData$Deployment)
last(TidyData$Deployment)
min(TidyData$Deployment)
max(TidyData$Deployment)
nth(TidyData$Deployment, 4) #Gives the 4th value in the vector
summarise(TidyData, n()) #Gives the number of rows (i.e. observations)

mean(TidyData$Catch)
median(TidyData$Catch)
var(TidyData$Catch)
sd(TidyData$Catch)

#How would you get SE?
# Recall: SE = SD / Square Root of N, where N = sample size
sd(TidyData$Catch) / sqrt(summarise(TidyData, n())) 

# Window functions take a bunch of values, and return an equal number of values. e.g.

lead(TidyData$Catch) #This moves every value one space earlier in the vector
lag(TidyData$Catch) #As above, but it shifts everything one space later
#Compare each with TidyData$Catch

#Play with each of these, always comparing with TidyData$Catch:
dense_rank(TidyData$Catch)
min_rank(TidyData$Catch)
percent_rank(TidyData$Catch)
row_number(TidyData$Catch)
cumall(TidyData$Catch)
cumany(TidyData$Catch)
cummean(TidyData$Catch) #This one is particularly useful - how does 
#each additional value in the vector affect the mean?
cumsum(TidyData$Catch)
cummax(TidyData$Catch) #What's the maximum value experienced at each part of the vector?
cummin(TidyData$Catch)
cumprod(TidyData$Catch) #Note what zeroes do to this
pmax(TidyData$Catch)
pmin(TidyData$Catch)


###################
# Joins
###################

#So let's say you've got two data frames with related information to TidyData. 
# Let's say we have temperature for each deployment. I'll just make it up here:

TemperatureData <- data.frame(
  Deployment = c(1,2,3, 4), 
  TemperatureC = c(23, 25, 21, 20)
) #Note that we have one more deployment in TemperatureData than we do in TidyData
#This will matter in a second...

print(TemperatureData)

# Here, Deployment is the same as Deployment in TidyData. But what if we wanted to plot
# catch vs. temperature? We need to JOIN the two data frames

# It's super easy in R - literally one line of clear code:

CombinedData <- left_join(TidyData, TemperatureData, by="Deployment")

print(CombinedData)

#Here, the 'left' means you're adding the second frame to the first frame.
#That is, you're adding data from TemperatureData to TidyData, and putting the new
#data frame into Combined Data.

#What if we wanted to do it the other way around? i.e. add data from TidyData to 
#TemperatureData?
#To do that, use right_join:

CombinedData <- right_join(TidyData, TemperatureData, by="Deployment")

print(CombinedData)
# Notice anything different? 

# Let's say we only wanted CombinedData to include rows with no missing values. 

CombinedData <- inner_join(TidyData, TemperatureData, by="Deployment")

print(CombinedData)

# ...or if we wanted to include everything, regardless of missing values.

CombinedData <- full_join(TidyData, TemperatureData, by="Deployment")

print(CombinedData)

# Now you know how to join data frames! Easy!
########
# Let's say you have a data frame with some additional observations
# That is - more rows, not more columns. Add this by BINDING

#First, let's make up some more observations

ExtraData <- data.frame(
  Deployment = c(4,4,4),
  TrapType = c("BigTrap", "MediumTrap", "SmallTrap"),
  Catch = c(6,3,1)
)

# Now, let's BIND these rows to TidyData
LargerData <- bind_rows(TidyData, ExtraData)

print(LargerData) #Cool, it worked!

####################
# Cleaning up your code
####################

# tidyR uses a thing called 'piping' to make code more readable
# Demonstrated here:

LargerData <- TidyData %>%
    bind_rows(ExtraData)

CombinedData <- TidyData %>%
  inner_join(TemperatureData, by="Deployment")

# See the pattern? 
# Piping can really clear up code, especially when running multiple operations. e.g.

PipedData <- TidyData %>%
  bind_rows(ExtraData) %>%
  inner_join(TemperatureData, by="Deployment")

