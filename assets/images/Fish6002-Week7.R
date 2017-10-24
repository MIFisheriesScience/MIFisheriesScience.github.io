##########################
# FISH 6002: Week 7 code #
#                        #
# Started Oct 19, 2017   #
#                        #
# Brett Favaro           #
#                        #
##########################

library(tidyverse)
library(rio) # To export SPSS files
# rio vignette: https://cran.r-project.org/web/packages/rio/vignettes/rio.html 


setwd("C:/Users/bfavaro/Google Drive/MI SOF Courses/FISH 6002 - Data collection mgmt and display/Week 7 - Collecting and managing tidy data")

# This was how I turned the CSV into SPSS file format .sav
PartC <- read.csv("PygmyWFBC-PartC.csv")
export(PartC, "PygmyWFBC-PartC.sav")



#################
# Preamble
################

# In this exercise we will build a tidy data frame and combine some different types of data.

# The data are from http://derekogle.com/fishR/data/data-html/PygmyWFBC.html

# Target Variables:

#year: Year of capture (2000, 2001)
#month: Month of capture
#week: Week within a month of capture
#net_no: Unique net identification number
#fish_no: Unique fish identification number
#fl: Fork length (cm)
#wt: Weight (g)
#sex: Sex code (F=Female, M=Male, Imm=immature)
#mat: Maturity code (Imm=immature, MG=maturing, MT=mature)
#scale_age: Scale age (in years)


# The datasheets provided to students have a few extra variables. 

###########################################
#                                         #
# 1. Data entry                           #
#                                         #
###########################################

# No code here - students will enter data from supplied papers

# Shortcut: Import the data

PartA <- read.csv("PygmyWFBC-PartA.csv")

# Data cleaning:
# 1. Did it load correctly? Any extra variables or rows?

head(PartA)
tail(PartA) # no extra columns or rows. All goode

# 2. Are variables correct data types?

sapply(PartA, class)

# Scale_age is wrong but that's because no data are entered there yet
# Everything else seems fine

# 3. Any impossible numerical values?

range(PartA$year)
range(PartA$week)
range(PartA$net_no)
range(PartA$fish_no)
range(PartA$fl)
range(PartA$wt) # There's a missing value
range(PartA$wt, na.rm=TRUE) #Without NA's it seems fine
plot(PartA$wt) #confirmed

# One weight is pretty small. Does that seem correct?
# Let's look at other variables

PartA %>%
  filter(wt == 3.4) #Fish 17 also has the lowest fork length. all good

# How many missing weights are there?
table(is.na(PartA$wt)) # Two missing weights. 

# 4. Any erroneous factor levels?

levels(PartA$month)
levels(PartA$sex)
levels(PartA$mat) #all good

######################################################
# Part B: Combining data                             #
######################################################

PartB <- read.csv("PygmyWFBC-PartB.csv")

# Data cleaning:
# 1. Did it load correctly? Any extra variables or rows?

head(PartB)
tail(PartB) # no extra columns or rows. All goode

# 2. Are variables correct data types?

sapply(PartB, class)

# Scale_age is now an integer
# All seems fine

# 3. Any impossible numerical values?

range(PartB$year)
range(PartB$week)
range(PartB$net_no)
range(PartB$fish_no)
range(PartB$fl)
range(PartB$fl, na.rm=TRUE) #Without NA's it seems fine

range(PartB$wt) # There's a missing value
range(PartB$wt, na.rm=TRUE) #Without NA's it seems fine

# 4. Any erroneous factor levels?

levels(PartB$month)
levels(PartB$sex)
levels(PartB$mat)


###################################
# Ready to combine                #
###################################

sapply(PartA, class)
sapply(PartB, class)

# These two datasets are identical. 

# Combine rows:
PartAB <- bind_rows(PartA, PartB)

# Error messages occurred. What gives?

sapply(PartAB, class)
# month and mat have been changed into characters
# This is because the two dataframs had different factor levels

PartAB$month <- as.factor(PartAB$month)
PartAB$mat <- as.factor(PartAB$mat)

sapply(PartAB, class) # That's better

#################################################################
# What if the two spreadsheets DIDNT have the same columns?     #
#################################################################

#e.g. here's some code that switches up column names
# and re-codes some of the variable names

PartB_Broken <- PartB %>%
    mutate(Netno = net_no) %>%
    select(-net_no) %>%
    mutate(Week = week) %>%
    select(-week) %>%
    mutate(FORKLENGTH = fl) %>%
    select(-fl) %>%
    mutate(Weight = wt) %>%
    select(-wt) %>%
    mutate(FORKLENGTH = FORKLENGTH*10) #Simulating the use of mm instead of cm

####
    
head(PartB_Broken)
head(PartA)

bind_rows(PartA, PartB_Broken) #What happens?

# Need to correct the column names

# Manually go through and fix each column

PartB_Fixed <- PartB_Broken %>%
  mutate(net_no = Netno) %>%
  select(-Netno) # Drop the old column

PartB_Fixed <- PartB_Broken %>%
  mutate(week = Week) %>%
  select(-Week) # Drop the old column

PartB_Fixed <- PartB_Broken %>%
  mutate(wt = Weight) %>%
  select(-Weight) # Drop the old column

# For fork length we need to convert it back to cm. We can both
# convert AND rename in one step:

PartB_Fixed <- PartB_Broken %>%
  mutate(fl = FORKLENGTH/10) %>%
  select(-FORKLENGTH) # Drop the old column

head(PartB_Fixed)

# If the factor levels were wrong, you can change them with this code: 

# levels(PartB_Fixed$FACTOR) <- list("Level1"=c("LEVEL1", "Level1"), 
#        "Level2"=c("LEVEL2", "Level2"))

##################################
# Part C: Adding SPSS data       #
##################################

# Scenario: We discovered a part C, but it's stored as an SPSS file. 

# Whenever you have a weird file format start by Googling that format
# to determine what the extension is associated with

# In our case, we discovered PartC.sav

# Googling reveals this to be an SPSS file. We can't open that with Excel.

# There are many packages we can use here. Today, we will use the rio package

PartC <- import("PygmyWFBC-PartC.sav")

head(PartC) #It's literally that easy. You just use a different input function.

# But we can see a few issues - months are recorded as numbers for example.
# Option 1: Clean up PartC BEFORE binding
# Option 2: Bind, then clean up. 

# Either works - the key is that column names are the same

# What needs to change?
head(PartB)

# All the factor levels have been converted to numbers
head(PartC)

# Need to fix month, sex, and mat

# We have NaN's instead of NA. We should fix that.

# NaN = Not A Number, i.e. and is defined as x/0.
# NA = Missing value.

# Those aren't the same thing. However see below:

is.na(NaN)
is.na(NA)

is.nan(NA)
is.nan(NaN)

# is.na returns true whether it says NaN OR NA. 
# is.nan only returns true in the face of NaN
# is.nan only returns a single value. is.na can be applied to vectors. 

is.na(PartC) # To prove NaNs show up as TRUE
 
PartC[is.na(PartC)] # This returns only the values of PartC that returned true under is.na

PartC[is.na(PartC)] <- NA #Assign a value of NA to every value in the data frame wherein R found a NA or NaN

head(PartC) # Note that the NaNs have all switched over

#####
# Now let's recode. The only way to do this is to go back to the source
# and figure out what the numbers correspond to. Here:
# Months 1, 2, and 3 are
# August, October, November, respectively
# 
# Sex 1 = F, Sex 2 = M
# 
# mat 1 = IMM, mat 2 = MG, mat 3 = MT
###

# Prep for modification
PartC$month <- as.character(PartC$month)
PartC$sex <- as.character(PartC$sex)
PartC$mat <- as.character(PartC$mat)

# Execute modification

PartC <-  PartC %>%
  mutate(month = factor(ifelse(month==1, "August", 
                                ifelse(month==2, "October", "November")))) %>%
  mutate(sex = factor(ifelse(sex==1, "M", "F"))) %>%
  mutate(mat = factor(ifelse(mat==1, "IMM", 
                             ifelse(mat==2, "MG", "MT")))) 

head(PartC) # Note that NAs stay as NA 

# Now we combine

PartABC <- bind_rows(PartAB, PartC) 

# You still must go through all data verification steps!
sapply(PartABC, class) #oops month coerced to character

PartABC$month <- as.factor(PartABC$month)

# All set - now we can work with PartABC

####################################
# Part D: Add another variable     #
####################################

# We have discovered a new variable! 

Otoliths <- read.csv("PygmyWFBC-OtolithAges.csv")

head(Otoliths)

# oto_age is the age in years, as determined by otoliths. 
# The data frame includes fish_no as well as oto_age

# fish_no is the same across the otoliths dataframe, and the full ABC dataframe we put together earlier

# We need to do a JOIN, based on fish_no

Joined <- left_join(PartABC, Otoliths, by="fish_no") #It's that simple!

# Fin


