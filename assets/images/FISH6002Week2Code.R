# R Code for Week 2: Introduction to R
# FISH 6002

# Started Feb 27, 2017
# Updated Sept 16, 2019

# Math operators are:
# + - * / ^ log(X) ()

# In R Studio, CTRL+ENTER runs a line of code
#Try this here

2

2+2

2*(2+2)

# Let's define a variable

X <- 1 # Define X, give it value of 1
X #What's the value of X?

#It's 1. 
# Now, let's ask some questions using logical operators.
# Logical operators are 
# < > == != <= >=

X == 2 # Does X equal 2?
#nope

X != 2 # Does X NOT equal 2?
#yes, because it's 1.

X + 1 # Let's add 1 to X
#Cool, it's 2!

X #What's the value of X again?
#What? Why is it 1?

X <- X + 1 
X #ahh, now it's 2. See the difference?

#Fun with variables
number_of_fish <- 1
number_of_fish + number_of_fish

fishname <- "Swimmy"

fishname + fishname #oops doesn't work. Why not?

# Okay, let's do a little script now. 
#Imagine rolling two regular six-sided dice

#First, let's make a variable for each one
Die1 <- 0 
Die2 <- 0

NumRolls <- 10 #Here, we specify number of rolls

Die1 <- sample(1:6, NumRolls, replace = T) 
Die2 <- sample(1:6, NumRolls, replace = T)

plot(Die1+Die2) #Basic plot command
# more later

# Woohoo! We've got cumulative dice value across ten rolls

#What's in each variable?
Die1
head(Die1)
summary(Die1)

#So Die1 is a VECTOR, with ten values. 
Die1[3] #What's in the FIRST position of Die1?

Die1
Die2
Die1 + Die2
Die1 * Die2
Die1 == Die2

#Die1 <- c(3,1,2,5,2,2,5,4,5,1) #Use if you want your plots to look the same as mine
#Die2 <- c(5,2,3,2,2,2,4,5,5,3)  

#Scenario 1: Build a data frame from above

RollNum <- c(1:NumRolls) #Let's make a counter for each roll
DiceData <- data.frame(RollNum, Die1,Die2) #Create a data frame with results of both sets of
#dice rolls
DiceData

#A quick data manipulation step to get it into 'long form' 
install.packages("tidyr")

require(tidyr)

DiceData_long <- gather(DiceData, 
                        key="DiceName", 
                        value="Score", 
                        Die1:Die2)

#In case you're curious this is:
#1) Declaring a new data frame called DiceData_long
#2) Assigning it the value of everything to the right of the arrow
#3) gather, from the tidyr package makes wide data long
#4) First parameter (DiceData) specifies the data frame to operate on
#5) Second parameter (DiceName) creates the new column, made from names of data columns
#6) Third parameter (Value) is the actual value column
#7) Fourth parameter specifies which columns to draw values from
# Result is a long-format dataframe that retains everything not specified above

head(DiceData_long) #did it work?
summary(DiceData_long)

#lets plot
plot(DiceData_long) #Doesn't work!

plot(DiceData_long$Score) #The $ specifies a variable WITHIN a data frame

plot(DiceData_long$Score ~ DiceData_long$RollNum)

# DATA TYPES:

#What do rolls look like across dice?
plot(DiceData_long$Score ~ DiceData_long$DiceName)

#Why isn't this working? Let's start by seeing what all the data types are in our data frame
sapply(DiceData_long, class)
?sapply #Hmm... Score is a character

#Compare the two outputs. What's different?
DiceData_long$Score 
as.factor(DiceData_long$Score) #Express this variable as a factor

#Factors use text to describe something that is basically just numbered levels.
#Die 1 is the first level. Die 2 is the second level. And so on. The default
#levelling is done alphabetically.

# If we were to eliminate the text labels:
as.numeric(as.factor(DiceData_long$DiceName))

# Seen this way, Die1 = 1. Die2 = 2. This is essentially how R treats the factor

#If you want to see what the levels are of a given factor, use levels()
#This is really important for error-checking!

levels(as.factor(DiceData_long$DiceName)) 

#Okay, enough fooling around. Let's reclassify DiceName as a factor

DiceData_long$DiceName <- as.factor(DiceData_long$DiceName)

#Did it work?
is.factor(DiceData_long$DiceName)
#great


plot(DiceData_long$Score ~ DiceData_long$DiceName)

#############
# Scenario 2: bringing DiceData in from a CSV
#############

#Let's assume that, instead of using R to generate the Dice data, we entered
#it into an external spreadsheet and want to bring it into R

# If you're using base R, you need to set your working directory using setwd("C:/MYDIRECTORY")
# FYI some people hate setwd. http://plantarum.ca/code/setwd/
# We'll talk about workflow best practices later. For now we will use setwd anyway.

# What is your default working directory? use getwd() to check

setwd("C:/Users/bfavaro/Google Drive/MI SOF Courses/FISH 6002 - Data collection mgmt and display/Week 2 - Introduction to R") #Only use if you must

getwd() #this tells you what the current working directory is

DiceData <- read.csv("6002Week2-DiceData.csv")
#DiceData <- read.csv("6002Week2-DiceData.csv", stringsAsFactors=F) #Use this version if you want 
# to disable the automatic assignment of strings as factors

head(DiceData)

sapply(DiceData, class) #woohoo, it worked!

plot(DiceData$Score ~ DiceData$DiceName)

#Fun!
