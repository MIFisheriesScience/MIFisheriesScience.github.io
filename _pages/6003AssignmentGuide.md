---
layout: single
title: "FISH 6003 Assignment Guide"
permalink: /courses/6003Stats/6003Assignmentguide/
author_profile: false
---

** I am redesigning the grading scheme somewhat. The major assignment will proceed largely as described. Remainder TBD **

10% of your course grade is earned by participation. Just show up, be yourself, and participate!

The remainder will be earned by completing assignments. These fall into three categories:

- Major assignment (60%)
- Minor assignments (30%)

This document outlines the details and grading criteria for each assignment.

**All assignments should be submitted via your assigned OneDrive folder. All feedback and grades will be returned via your OneDrive folder**

## Submitting Assignments

Memorial University uses OneDrive for file sharing. At the start of each semester, I will make a OneDrive folder for each student in the class. All assignments will be deposited into your personal OneDrive folder, and all assignment feedback will be returned the same way.

# Major Assignment
 
In the Major Assignment, you will conduct a regression-type analysis on data that you obtain (i.e. what is the impact of X on Y?)

These data may be something that you have collected yourself for your research, from a public database, or as attached by another publication.

Essentially, the major assignment is to do all the basic groundwork that would need to be done to prepare an analysis for publication.
 
## Part 1: Obtaining and Describing Data

The goal of part 1 is to obtain and describe data. Key questions, which will be answered in two pages or less (single-spaced, 12-point Times New Roman):

- Where are the data from?
- What are the data? (i.e. how many points? What are they measuring? How are they measured?)
- If you got the data from someone else, are there any constraints around using them?
- What are **three key research questions** you will ask of these data? In other words: *What are your biological hypotheses* that you will be testing?

The purpose of this section is to determine whether the data you obtained will be sufficient for the major project. 

*In addition* you will, at this stage, create an R Project for your major assignment, with appropriate sub-folders. The above document should be inserted in a /Part1 subfolder. Details to be provided in-class.

**The actual data file should be included at this stage as well.**

### Timeline and Submission

**Part 1 is due by the end of week 4**

### Grading

* Accurately describes the data source: /2
* Accurately describes the data itself (number of points, what they are measuring, etc.): /2
* Three research questions, answerable by these data, are stated: /4
* R Project folder is correctly created and organized: /2

While these are essentially completion marks, the instructor may require at this state that more or different data be incorporated into your project. 

If the dataset is too limited it can be challenging to produce an interesting project. Further, if the data are too complex, it may represent a challenge that is beyond the scope of this course.

## Part 2: Data Exploration

In Part 2, you will conduct a data exploration, following a slightly modified version of the procedure explained in [Zuur et al. 2009](http://onlinelibrary.wiley.com/doi/10.1111/j.2041-210X.2009.00001.x/full). You should report the results of each step. These steps include:

A. Re-stating the biological hypotheses (in case they changed from Part 1)
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
D. Specify the statistical model that you intend to use, and why.

### Timeline and Submission

**Part 2 is due by the end of week 8** 

The deliverables for Part 2 should be organized as follows:

* A properly-organized R project folder with separate subfolders for analysis code, data, output, etc.
* A document that includes everything, including plots and relevant R output. You should both show the direct output from R, and interpret it in your own words
* A separate .R script that includes all necessary code to conduct the data exploration

While it is not a requirement, I encourage you to use R Markdown for this assignment, so that diagnostic plots can be embedded directly with the text. See: [https://mifisheriesscience.github.io/courses/6002Data/6002Week3/](https://mifisheriesscience.github.io/courses/6002Data/6002Week3/)

### Grading

* Biological hypotheses are clearly stated and sensible, given data: /3
* Experimental design is **clearly visualized with a diagram**, including any nested structure: /3
* Steps 1-8: /3 each. Note that many of these steps should include a plot. (1 mark for the plot, 2 for the explanation).

Specifying your intended statistical model:

* Model is identified and explained: /3
* Your choice is defended using literature: /3

Total: /36

## Part 3: Conducting and Reporting the Analysis

In Part 3, you will conduct a regression-type data anlaysis, following the reporting procedure explained in [Zuur and Ieno, 2016](http://onlinelibrary.wiley.com/doi/10.1111/2041-210X.12577/full). The steps to this assignment include:

1. Identify the dependency structure in the data
2. Present the statistical model
3. Fit the model
4. Validate the model
5. Interpret and present the numerical output of the model
6. Create a visual representation of the model
7. Simulate from the model 

Note that Part 3 comes immediately after Part 2. There is no need to re-do your data exploration in part 3, as it will already be completed in part 3. 

### Timeline and Submission

**Part 3 is due by the end of week 12** and should be submitted by email to the instructor.

The deliverables for Part 3 should be organized as follows:
* A properly-organized R project should be created that contains all data and scripts
* A document that includes everything, including plots and relevant R output. You should both show the direct output from R, and interpret it in your own words
* A separate .R script that includes all necessary code to conduct the data exploration

It is recommended that you simply add to the project folder that you created for Part 2. Place everything into a zip file and submit to the instructor.

While it is not a requirement, I encourage you to use R Markdown for this assignment, so that diagnostic plots can be embedded directly with the text. See: [https://mifisheriesscience.github.io/courses/6002Data/6002Week11/](https://mifisheriesscience.github.io/courses/6002Data/6002Week11/)

### Grading

Steps 1-7: 

* Each should include a chunk of R code, output, and intepretation. /5 for each step

Total: /35

**Between parts 1, 2, and 3, the Major Assignment is worth a total of 81 marks, which correspond to 60% of the course grade.**

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
- Submit ONLY THE HTML FILE your OneDrive folder

### Rubric and Grading

Assignment value:

3 marks for each step of the data exploration (8 steps total)

/1 All relevant variables are assessed at that step 
/1 Appropriate plots are used 
/1 Description of findings is defensible 

Total: /24, **scaled to 10% of course grade**

### Due date

Please submit your completed HTML file to your OneDrive folder by **Jan 30**


# OTHER Minor Assignments
** STAND BY: THIS SECTION INCOMPLETE **
The minor assigment asks you to take a paper, determine its key hypothesis, and design a model to test that hypothesis.

**In pairs** select one of the following papers:

1. [Virgili, M., Vasapollo, C., & Lucchetti, A. (2018). Can ultraviolet illumination reduce sea turtle bycatch in Mediterranean set net fisheries?. Fisheries Research, 199, 1-7.](https://www.sciencedirect.com/science/article/pii/S016578361730320X)
2. [Levesque, J. C., Hager, C., Diaddorio, E., & Dickey, R. J. (2016). Commercial fishing gear modifications to reduce interactions between Atlantic sturgeon (Acipenser oxyrinchus oxyrinchus) and the southern flounder (Paralichthys lethostigma) fishery in North Carolina (USA). PeerJ, 4, e2192.](https://peerj.com/articles/2192/?utm_source=TrendMD&utm_campaign=PeerJ_TrendMD_0&utm_medium=TrendMD)
3. [Utne-Palm, A. C., Breen, M., Løkkeborg, S., & Humborstad, O. B. (2018). Behavioural responses of krill and cod to artificial light in laboratory experiments. PloS one, 13(1), e0190918.](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0190918)
4. [Robbins, W. D., Peddemors, V. M., Kennelly, S. J., & Ives, M. C. (2014). Experimental evaluation of shark detection rates by aerial observers. PloS one, 9(2), e83456.](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0083456)

If none of these papers appeal to you, you may also select a different paper that would be analyzable by a regression-type model. If you choose to do this please show the paper to Brett by March 9 for approval.

It is okay for multiple pairs to do the same paper.

Read the paper and do the following:

1. Define the hypothesis in words.  /4
2. Describe Y. Is it a count, proportion, etc? /2
	- How was it measured? /1
3. Identify all covariates. What types of data are they? /4
4. Sketch the study design, indicating any dependency structure. /4
	- Note the number of replicates within each treatment group. /2
5. Brainstorm: What sources of uncertainty might there be in the measurements of each covariate, and Y? (At least one per variable) /5
6. Define each of three parts of the GLM:
	- Write the equation for the predictor function. /10
	- What distribution defines Y? /4
	- What is the link function? /4
7. Write the syntax to run this model in R(e.g. mod <- lm(Y_var ~ Covariate1 + Covariate2)) /10
8. Did the authors run the model you specified? If not, what did they do instead? Critique their approach versus yours. /10

Total: / 60, scaled to xx% of course grade

## Assessment Criteria

All of the above papers are analyzable by a regression-type analysis that we will have covered by the end of Week 9 of the class. 
 
Point-form is acceptable where it facilitates clarity. The study design may be hand-drawn and scanned, or done in Powerpoint. Regardless it must be legible. 

For the critique (step 8) please focus on the fundamentals. Are assumptions likely to be violated by any of the models? How does YOUR model address that? 

Note that I am not asking you to actually run the model or perform a validation (that will be done in the Major Assignment).

## Due Date

Please submit by xxx. I recommend you try to complete it earlier so as to allow you to focus entirely on the major assignment by the end of the course.
