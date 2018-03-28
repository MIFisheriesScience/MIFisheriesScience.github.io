# FISH 6003: Week 11  - Intro to Bayesian Stats and Power Analysis

# Brett Favaro
# Started March 28, 2018

library(pwr)
library(tidyverse)
library(effsize)

# Visualizae how increasing sample size affects P value of a T test

# Imagine you have 25 fish that you fed, and 25 fish that you did not feed, in 50 separate aquaria
# (i.e. points are independent)

# Measure size after a month. Are fed fish bigger, on average?

Fed <- rnorm(25, mean=10, sd = 2)
UnFed <- rnorm(25, mean=9, sd = 2)
SampleNum <- 1:25
PValue <- 0

FishSizes <- data.frame(SampleNum, Fed, UnFed, PValue)

for(i in 2:25) {

  temp <- FishSizes %>%
    filter(SampleNum <= i) 

  FishSizes$PValue[i] <- t.test(x = temp$Fed, y = temp$UnFed)$p.value

}

plot(FishSizes$PValue ~ FishSizes$SampleNum, xlim=c(3,25),
     xlab="Sample size", ylab="P-value, from a T test")

temp <- filter(FishSizes, SampleNum >= 3)
lo <- loess(PValue~SampleNum, data=temp)
lines(predict(lo), col='red', lwd=2)

#########
# Demonstrate a power analysis for a t-test

# Assume we know: 

# effect size
# sample size
# significance


# Tell me the sample size I'd need to generate power of 80%
pwr.t.test(d = 0.5, sig.level = 0.05, power=0.8, type="two.sample")

# Tell me what power I'd have if I could do 20 samples per treatment
pwr.t.test(n = 20, d = 0.5, sig.level = 0.05, type="two.sample")

# Tell me how big the effect size would need to be to detect it given
# a sample size of 20, and that we want an 80% chance of detecting it
pwr.t.test(n = 20, power=0.8, type="two.sample")

# Tell me what significance level I'd need to set, to have 80% power given 
# this effect and sample size
pwr.t.test(n = 20, d = 0.5, power=0.8, sig.level=NULL, type="two.sample")






mean(FishSizes$Fed)
