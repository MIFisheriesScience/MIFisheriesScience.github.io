# Minimal Reproducible Example Exercise

# FISH 6002: Week 3 Markdown and Workflow
# Authored 23 Sept 2019

#Install a data package from Derek Ogle's FishR page
install.packages("fishkirkko2015")

# Load the data into memory
library(fishkirkko2015)
library(dplyr)

# data() enables use of data from pre-loaded packages
data(fishkirkkojarvi2015) 
data(fishnames)

# data are:
#fishname Fish name in Finnish
#fishID Fish unique identifier for this dataset
#sl Standard Length in mm
#fl Fork Length in mm
#tl Total Length in mm
#wt Weight in g

head(fishkirkkojarvi2015)

# let's append names 
fishdata <- left_join(fishkirkkojarvi2015, fishnames, by="fishID")

head(fishdata) #this is the dataset we will work with

# TASK:
# CREATE A MINIMALLY REPRODUCIBLE EXAMPLE OF ONE OF THE BUGS BELOW
# POST ON MICROSOFT TEAMS - ASK FOR HELP
# HELP SOMEONE ELSE, USING MRE 

# Remember to:
# - state your goal and intended behaviour
# - enclose a minimally reproducible code snippet
# - ask for help nicely

# When responding:
# - Enclose minimally reproducible code snippet

###############################
# SAMPLE BUG (used in class)  #
###############################

plot(tl ~ fl, data = fishdata)

############# 
# BUG 1     #
#############

# Goal: Make a basic plot of total legnth (y) by weight (x)

plot(tl ~ wt
     data=fishdata)


############# 
# BUG 2     #
#############

# Goal: Tell me how many times each species appeared in the dataset

# hint: use table() to get counts

table(fishdata$english)


############# 
# BUG 3     #
#############

# Goal: Make a histogram of each fishID (i.e. how many times
# does each fish appear in the dataset?)

# hint: use hist() to make histograms

hist(fishID, data=fishdata)

#############
# BUG 4     #
#############

# Goal: show the data type enclosed within each variable of fishnames

sapply(fishdata, Class)

#############
# BUG 5     #
#############

# Goal: make a boxplot of fish weight by scientific name

plot(wt ~ binomial.name, data=fishdata)





