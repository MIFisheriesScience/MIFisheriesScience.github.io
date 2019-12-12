---
layout: single
title: "FISH 6003 Assignment Guide"
permalink: /courses/6003Stats/6003Assignmentguide/
author_profile: false
---

10% of your course grade is earned by participation in in-class activities and assignments. 

The remainder will be earned by completing assignments. These fall into three categories:

- Major assignment (60%)
- Minor assignments (30%)

This document outlines the details and grading criteria for each assignment.

**All assignments should be submitted via Teams. Specific directions for submission will be available on the Teams link**

# Major Assignment
 
In the Major Assignment, you will conduct a regression-type analysis on data that you obtain (i.e. what is the impact of covariates (i.e. things that go on X) on Y?)

These data may be something that you have collected yourself for your research, from a public database, or as attached by another publication.

Essentially, the major assignment is to do all the basic groundwork that would need to be done to prepare an analysis for publication.
 
## Part 1: Obtaining and Describing Data

The goal of part 1 is to obtain and describe data. Key questions, which will be answered in two pages or less (single-spaced, 12-point Times New Roman):

- Where are the data from?
- What are the data? (i.e. how many points? What are they measuring? How are they measured?)
- If you got the data from someone else, are there any constraints around using them?
- What are **three key research questions** you might ask of these data? In other words: *What are your biological hypotheses* that you may test?

The purpose of this section is to determine whether the data you obtained will be sufficient for the major project. 

In addition, I want you to get in the habit of working in Rprojects. While this is not an R course, and I will not be grading your code, I WILL be asking you to complete assignments in Markdown.

Hence, in Part 1, I would also like you to set up an R Project folder that you will use for the rest of the semester. I have [produced a template you can download](/assets/images/LASTNAME_6003_Major.zip).

Your deliverable in Part 1 is:

* A zip file, containing a properly laid-out R project with appropriate subfolders
* Within the /data subfolder, a copy of your CSV file containing the raw data to be used in this project
* The answers to the above questions should be contained in the DESCRIPTION.TXT file in the root project folder

### Timeline and Submission

**Part 1 is due by the end of week 4**. Submit via Teams.

### Grading

The following pieces will be assessed (Rubric contained on Teams)

* Accurately describes the data source
* Accurately describes the data itself (number of points, what they are measuring, etc.)
* Three research questions, answerable by these data, are stated
* R Project folder is correctly created and organized

While these are essentially completion marks, the instructor may require at this state that more or different data be incorporated into your project. 

If the dataset is too limited it can be challenging to produce an interesting project. Further, if the data are too complex, it may represent a challenge that is beyond the scope of this course.

**The more relevant the data are to your thesis, the more satisfying this project will be to your development as a scientist.**

## Part 2: Data Exploration

In Part 2, you will conduct a data exploration, following a slightly modified version of the procedure explained in [Zuur et al. 2009](http://onlinelibrary.wiley.com/doi/10.1111/j.2041-210X.2009.00001.x/full). You should report the results of each step. These steps include:

A. State, in words, the biological hypothesis you intend to test. List the covariates and response being investigated.
B. Visualize the experimental design, **with a diagram**
C. Conducting the data exploration:
	1. Outliers Y and X
	2. Homogeneity Y
	3. Normality Y
	4. Zeroes Y
	5. Collinearity X
	6. Relationships Y and X
	7. Interactions
	8. Independence of Y
	
### Timeline and Submission

**Part 2 is due by the end of week 8** 

The deliverable for Part 2 is a rendered markdown document, as a PDF or HTML file. **In addition** you must submit an file visualizing your study design. I recommend Powerpoint for this.

If you are unfamiliar with Markdown: [https://mifisheriesscience.github.io/courses/6002Data/6002Week3/](https://mifisheriesscience.github.io/courses/6002Data/6002Week3/)

Note that I have enclosed a template in the /Part2 subfolder that will get you started.

### Grading

Rubric contained on Teams. The following will be assessed: 

* Biological hypothesis is clearly stated and sensible, given data
* Experimental design is **clearly visualized with a diagram**, including any nested structure.
* Steps 1-8 will each be assessed too. Note that many of these steps should include a plot. 

The rendered Markdown file should, for each step, show your R code, the output, and your interpretation. 

## Part 3: Conducting and Reporting the Analysis

In Part 3, you will conduct a regression-type data anlaysis, following the reporting procedure explained in [Zuur and Ieno, 2016](http://onlinelibrary.wiley.com/doi/10.1111/2041-210X.12577/full). The steps to this assignment include:

1. Identify the dependency structure in the data
2. Present the statistical model
3. Fit the model
4. Validate the model
5. Interpret and present the numerical output of the model
6. Create a visual representation of the model
7. Simulate from the model 

### Timeline and Submission

**Part 3 is due by the end of week 12** 

The deliverable for Part 3 is a rendered markdown document, as a PDF or HTML file. 

### Grading

The rendered Markdown file should, for each step, show your R code, the output, and your interpretation. 

Rubric enclosed in Teams.

**Between parts 1, 2, and 3, the Major Assignment is worth 60% of the course grade.**

# Minor Assignment 1

### Conduct a Simple Data Exploration

For your first minor assignment, your task is to perform a simple data exploration.

The data are from Derek Ogle's fishR website: http://derekogle.com/fishR/data/data-html/YERockfish.html

Imagine you have been given this dataset and you are asked: **To what extent can you predict the maturity stage of Yelloweye Rockfish from their age and length?**

Please download this R Project: 
- [6003_MinorAssignment1.zip](/assets/images/6003/6003_MinorAssignment1.zip)

Complete the following steps:

- Open the file LASTNAME_MinorAssignment1.rmd
- This document will provide you a template to do your data exploration, and includes code for relevant plots at each step
- Complete the document, including explanations for your interpretation of the plots at each step
- Render your Markdown document as an HTML file (replace LASTNAME with your actual last name)
- Submit ONLY THE HTML FILE via Teams

### Rubric and Grading

Assignment value:

3 marks for each step of the data exploration (8 steps total)

/1 All relevant variables are assessed at that step  
/1 Appropriate plots are used  
/1 Description of findings is defensible  

Total: /24, **scaled to 10% of course grade**

# Minor Assignment 2

### Describe a model from a published study

The purpose here is to make sure you’ve followed everything up until Week 6’s lecture content. The primary objectives of this assignment are:
-	To practice reading a study and accurately reporting what it was that they actually tested, and how they tested it
-	To demonstrate understanding of different types of data
-	To correctly identify the three components of a GLM
-	To think critically about the things being measured

Please read: Lovely CM, O’Connor NJ, Judge ML. 2015. Abundance of non-native crabs in intertidal habitats of New England with natural and artificial structure. PeerJ 3:e1246 https://doi.org/10.7717/peerj.1246

Answer the following questions **for experiment 1 only**

1.	Define the hypothesis in words. /4
2.	Describe Y. Is it a count, proportion, etc? /2
- How was it measured? /1
3.	Identify all covariates. What types of data are they (e.g. count, continuous, proportion, binomial, other?) /4
4.	Sketch the study design, indicating any dependency structure. /4
-	Note the number of replicates within each treatment group. /2
5.	Brainstorm: What sources of uncertainty might there be in the measurements of each covariate, and Y? (At least one per variable) /5
6.	Define each of three parts of the GLM:
- Write the equation for the predictor function*. /10
- What distribution defines Y? /4
- What is the link function? /4

Total /40, scaled to 10% of course grade

-	You may work on this in groups, but please submit individually
-	Please be brief in your responses to each question above
-	[Here is a template you can use to complete this assignment.]((/assets/images/6003/LASTNAME_Minor2.zip)

# Minor Assignment 3

### FundaGLMMentals

In this activity, we will focus specifically on building fundamental understanding of GLMMs. I will hand out a worksheet in class and give in-class time to complete it. 

