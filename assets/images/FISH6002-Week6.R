# R Code for Week 6: Working with Messy Data
# FISH 6002

# Started Oct 14, 2017

library(lubridate)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(tidyr)

# Load data

# Read the file LakeTroutALTER-broken.csv into R
# These data are derived from Derek Ogle's FSA data resources:
# http://derekogle.com/fishR/data/data-html/LakeTroutALTER.html

# I have deliberately introduced errors into this dataset, so we can clean it up. 

# setwd("C:/Users/bfavaro/Google Drive/MI SOF Courses/FISH 6002 - Data collection mgmt and display/Week 6 - Working with messy data/")
setwd("YOURPATH")

LakeTrout <- read.csv("LakeTrout-broken.csv")

# These are lengths, weight, age, and sex of lake troute from an Arctic Long Term Ecological REserach Location

# Variables are:
# id: A unique ID number for each fish
# tl: Total Length (mm) at capture
# fl: fork length (mm) at capture
# w: weight (g) at capture
# otorad: Otolith radius (mm) at capture
# age: completed growing seasons at capture (years)
# sex: F - female, M - male

##################################
# STEP 1: Did it load correctly? #
##################################

head(LakeTrout) #Any extra columns? (yes - X)
tail(LakeTrout) 

#Any extra rows? (no)

LakeTrout$X 


# Checking the CSV file, there was no such column there. Must be a space.

LakeTrout <- LakeTrout %>%
  select(-X)

head(LakeTrout)

#################################
# STEP 2: Check data types      #
#################################

# First Question: What are the data types?
sapply(LakeTrout, class)
# Does this look right?

# Problem: tl and w are factors. They should be numeric or integer

levels(LakeTrout$tl)

# Looks like there might be some typos in there, with non-numeric characters

##############################################################################
# I like to work from a "Fixed" data frame, so we don't change the original  #
##############################################################################

LakeTroutFix <- LakeTrout               

# First, we need to find all values that include non-numeric values. 
# But that's not easy to do with factors. Easiest is to convert to character first,
# and look for non-numeric values

LakeTroutFix$tl <- as.character(LakeTroutFix$tl)

# If you use as.numeric() on a character that includes non-numeric values, it will return NA
# So, let's start by filtering only values with NA

LakeTroutFix %>%
  filter(is.na(as.numeric(tl))==TRUE)

# This demonstrated that we have at least two problems. For ID 62, tl has an O!
# For ID 306, TL has an f in it

# At this stage you could go correct your CSV file, OR you could fix the values right from R:

LakeTroutFix <- LakeTroutFix %>%
  mutate(tl = ifelse(tl=="2O8", 208, tl)) %>%
  mutate(tl = ifelse(tl=="215f", 215, tl)) # Each line fixes a specific issue

# Great, let's turn it back to a number 

LakeTroutFix$tl <- as.numeric(LakeTroutFix$tl)

#############################################################################
# When making conversations like this, always check values before moving on #
#############################################################################

range(LakeTroutFix$tl)
plot(LakeTroutFix$tl)

# There is a major outlier. Did we introduce an error?
# Re-load the original data 

# We know this part was right:
LakeTroutFix$tl <- LakeTrout$tl
LakeTroutFix$tl <- as.character(LakeTroutFix$tl)
LakeTroutFix <- LakeTroutFix %>%
  mutate(tl = ifelse(tl=="2O8", 208, tl)) %>%
  mutate(tl = ifelse(tl=="215f", 215, tl)) # Each line fixes a specific issue

# Before converting back to a number, let's have another look

LakeTroutFix$tl

# Here, you will likely spot the 56e8.
# What happens when you convert a character like this into a number?

as.numeric("56e8")

# It treats e as an exponent!!! Our detection system didn't work!

LakeTroutFix <- LakeTroutFix %>%
  mutate(tl = ifelse(tl=="56e8", 568, tl))

# Convert to a number
LakeTroutFix$tl <- as.numeric(LakeTroutFix$tl)

# Check
range(LakeTroutFix$tl)
plot(LakeTroutFix$tl)

# Thank goodness, it worked. 
# Now we need to fix weight

levels(LakeTroutFix$w)

# Two problems:
# 1. Numbers have commas
# 2. There's a blank

# 1. Get rid of the commas

# First, convert to character

LakeTroutFix$w <- as.character(LakeTroutFix$w)

# Next, remove the commas using gsub
# we're telling it to find a COMMA
# replace the COMMA with NOTHING
# do it to LakeTroutFix$w
# and write into LakeTroutFix$w

LakeTroutFix$w <- gsub(",", 
                       "", 
                       LakeTroutFix$w)

###################################################
# Note:
# Sub replaces the first instance only
# Gsub replaces every instance
# Compare:

sub(",", 
    "", 
    "1,000,000")

gsub(",", 
    "", 
    "1,000,000")
###################################################

LakeTroutFix$w #commas are gone

#Convert back to a number

LakeTroutFix$w <- as.numeric(LakeTroutFix$w)

range(LakeTroutFix$w) # We still have a missing value

# What to do?
# - Assign that fish a value of zero (careful with this - here, it would screw up our stats)
# - Go to source, ask to review original datasheets
# - Remove that fish altogether. Better luck next time. Don't lose data.

# Let's remove the incomplete row:

LakeTroutFix <- LakeTroutFix %>%
  filter(!is.na(w)) # This is an important piece of code

# is.na returns TRUE if it's an NA, false if it's not
# Here, we're saying: Return all rows that are NOT NA

range(LakeTroutFix$w) # All good

sapply(LakeTroutFix, class)

# Great - Let's move on

##################################################
# STEP 3: Check for missing or impossible values #
##################################################

# What constitutes impossible depends on the data under examination

# Let's go through eacn numerical value and check the range of values reported
# (We'll skip ID for a moment)

range(LakeTroutFix$tl) # Total lengths ranging from 206 to 568 mm. Seems fine
plot(LakeTroutFix$tl) # Seems fine

range(LakeTroutFix$fl) # Whoa, hold on. Fork langes range from 188 mm to 2970?
# You can't have a bigger fork length than total length. Something must be wrong.

plot(LakeTroutFix$fl) #Yup, one single outlier

# Locate in the dataset:

LakeTroutFix %>%
  filter(fl > 568) #Recall fork length can't be longer than total length. Assuming the TL column is correct, this 
# will filter out any impossible values of fl

# We see that fish 17 has an impossible fl of 2970, with tl of 328. What do we do?
# Option: Remove the row
# Option: Contact the data creator to get correct value
# Option: Assume that the typo was an erroneous zero, and that the real value is 297

# 297 is a bit less than the tl of 328. It seems reasonable to assume a zero was added by accident.
# We will document that we made this change, and assign the value of 327.

LakeTroutFix <- LakeTroutFix %>%
  mutate(fl = ifelse(id=="17", 297, fl)) #Note that I'm doing it differently this time
# I'm searching by ID number this time. Just showing that you can search by whatever you want. 

range(LakeTroutFix$fl) # now the range is 188 to 510. Seems fine
plot(LakeTroutFix$fl)

# Next, standard length

range(LakeTroutFix$sl)
plot(LakeTroutFix$sl) #Ack, not again. A single outlier

#As before, we'll assume the true value was 410, not 4100

LakeTroutFix <- LakeTroutFix %>%
  mutate(sl = ifelse(sl==4100, 410, sl)) #Note that I'm doing it differently this time

range(LakeTroutFix$sl)
plot(LakeTroutFix$sl)

range(LakeTroutFix$w)
plot(LakeTroutFix$w) #all good. 

range(LakeTroutFix$otorad) #uh oh
plot(LakeTroutFix$otorad) #We have a single negative number

# Where this is a measurement, the value MUST be positive. Negative values impossible
# Therefore: 

# Option: Remove the row
# Option: Contact the data creator to get correct value
# Option: Assume that the negative sign was just a typo. 

# Let's pick the third one. If it were positive, 1.165 seems like a reasonable value

LakeTroutFix <- LakeTroutFix %>%
  mutate(otorad = ifelse(otorad < 0, otorad*-1, otorad))

range(LakeTroutFix$otorad) 
plot(LakeTroutFix$otorad) #all better

# Moving on:

range(LakeTroutFix$age)
plot(LakeTroutFix$age)

# Hmm... there are outliers in both directions
# Starting with the top outliers, how long can trout live? Does 40+ seem reasonable?

# Go to fishbase.org
# Look up Salvelinus namaycush
# http://fishbase.org/Summary/SpeciesSummary.php?ID=248&AT=lake+trout
# max reported age = 50 years. And if we click the link we find that it's actually an Arctic
# population that reached that! So all good

# What about at the lower end of the range? Does age of 1 seem reasonable?

# Hard to say. Trout <1 year old are "parr" and aren't quite adults. It seems unlikely that the authors
# would lump a parr into a dataset about adults

# If there IS a very small trout, it should also be very small on other dimensions
# Let's find that observation

LakeTroutFix %>%
  filter(age == 1)

# This is a big fish on every other dimension. Everything else seems right, but there's 
# no way this is age 1

# So what do we do? 
# We can't infer what the typo would have been

# Need to go to original source, or discard. 

# In actual fact, the real value was 13. I introduced the typo.
# Let's reassign it back to 13.

LakeTroutFix <- LakeTroutFix %>%
  mutate(age = ifelse(age == 1, 13, age))

range(LakeTroutFix$age)
plot(LakeTroutFix$age) #all better. 

# ID number is the last numerical value

# It's a unique identifier for each fish
# That means:
# The value is a number, but could also have been a name. Not important that it's a #
# SO no restrictions on negatives, etc.
# However, there should be NO DUPLICATES.

# To check for duplicates:

LakeTroutFix %>%
  count(n_distinct(id)) # We're asking it to show the count, and the number of distinct values
# Only 84 distinct values? One must be a duplicate!

# Another way:
plot(table(LakeTroutFix$id)) #plot the frequencies of each ID

# Find the duplicate as follows:

LakeTroutFix %>% 
  group_by(id) %>% # Group the data by ID
  filter(n()>1) #Report the groups with more than one value
# ID 41 is repeated twice!

# So:
# 1. Should we discard? 
# Probably not - which one? Do we discard both? The rest of the data seem fine
# 2. Should we keep as is? 
# Not a good idea. What if we need to manipulate the data in some way, based on ID number?
# 3. Can we reassign one of the ID numbers to something different?
# PROVIDED WE DO NOT HAVE TO CONNECT TO ANOTHER DATASET then yes, that works

# We will assign one of these two fish an ID of Reassigned1

# Note this time we have to use more than one parameter to find the value we want to change
LakeTroutFix <- LakeTroutFix %>%
  mutate(id = ifelse(id == 41 & tl == 484, "Reassigned1", id))

plot(table(LakeTroutFix$id)) #perfect! one of each

##################################################
# STEP 4: Check for typos and broken factors     #
##################################################

# Aside from ID, which we already looked at, we are down to one variable: sex

LakeTroutFix$sex #on visual inspection there are some issues that are obvious. 
#How many different levels do you see?

# Let's check:

levels(LakeTroutFix$sex)

# Bet you missed a couple. It's essential to always check your factor levels. 
# The only possible values should be F or M. We have:
# f
# female
# Female
# Male
# We even have an F with a space after it - totally invisible to visual inspection.

#Fix everything as follows:

levels(LakeTroutFix$sex) <- list(F=c("f", "F", "F ", "female", "Female"), 
                                 M=c("M", "Male"))

# A list is a vector that can contain other objects (http://www.r-tutor.com/r-introduction/list)
# As written, this statement re-assigns all the levels so everything included in the F = part becomes F
# and everything in the M = part becomes M. 

# Check that it worked:

levels(LakeTroutFix$sex)

# There you have it! The dataset is clean!!
# Now we can plot stuff

a <- ggplot(LakeTroutFix, aes(x = tl, y = w)) + 
  geom_point() +
  theme_bw() +
  xlab("Total length (mm)") + 
  ylab("Weight (g)") +
  theme(axis.text = element_text(size=16),
        axis.title = element_text(size=18)
  ) +
  stat_smooth()

a

######################
# Compare dataframes #
######################

LakeClean <- read.csv("LakeTrout-clean.csv")

all.equal(LakeClean, LakeTroutFix)



###########################################################################################
################################################################
# Reference code: Run if you just want to clean the dataset    #
################################################################

LakeTroutFix <- LakeTrout               

LakeTroutFix$tl <- as.character(LakeTroutFix$tl)

LakeTroutFix <- LakeTroutFix %>%
  mutate(tl = ifelse(tl=="2O8", 208, tl)) %>%
  mutate(tl = ifelse(tl=="215f", 215, tl)) %>%
  mutate(tl = ifelse(tl=="56e8", 568, tl))

LakeTroutFix$tl <- as.numeric(LakeTroutFix$tl)

LakeTroutFix$w <- as.character(LakeTroutFix$w)
LakeTroutFix$w <- gsub(",", 
                       "", 
                       LakeTroutFix$w)
LakeTroutFix$w <- as.numeric(LakeTroutFix$w)
LakeTroutFix <- LakeTroutFix %>%
  filter(!is.na(w)) 

LakeTroutFix <- LakeTroutFix %>%
  mutate(fl = ifelse(id=="17", 297, fl))  %>%
  mutate(sl = ifelse(sl==4100, 410, sl)) %>%
  mutate(otorad = ifelse(otorad < 0, otorad*-1, otorad)) %>%
  mutate(age = ifelse(age == 1, 13, age)) %>% 
  mutate(id = ifelse(id == 41 & tl == 484, "Reassigned1", id))

levels(LakeTroutFix$sex) <- list(F=c("f", "F", "F ", "female", "Female"), 
                                 M=c("M", "Male"))
####################################################################################

