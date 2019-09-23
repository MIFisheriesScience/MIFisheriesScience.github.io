# Solutions to week 3: Minimal Reproducible Example activity

# solutions
# don't read these until the end 

# Students should first do this
dput(head(fishdata)) #NOT on the full dataset, because the full 
#dataset's dput is too long

# This part gets pasted first in MRE
df <- structure(list(fishID = c(1, 1, 1, 1, 1, 1), sl = c(216, 196, 
                                                          50, 159, 77, 119), fl = c(229, 202, 52, 171, 82, 124), tl = c(258, 
                                                                                                                        230, 60, 193, 93, 137), wt = c(191.3, 104, 2.1, 59.9, 6.6, 32.4
                                                                                                                        ), Finnish = c("Ahven", "Ahven", "Ahven", "Ahven", "Ahven", "Ahven"
                                                                                                                        ), English = c("perch", "perch", "perch", "perch", "perch", "perch"
                                                                                                                        ), binomial.name = c("Perca fluviatilis", "Perca fluviatilis", 
                                                                                                                                             "Perca fluviatilis", "Perca fluviatilis", "Perca fluviatilis", 
                                                                                                                                             "Perca fluviatilis"), Swedish = c("abborre", "abborre", "abborre", 
                                                                                                                                                                               "abborre", "abborre", "abborre")), .Names = c("fishID", "sl", 
                                                                                                                                                                                                                             "fl", "tl", "wt", "Finnish", "English", "binomial.name", "Swedish"
                                                                                                                                                                               ), row.names = c(NA, 6L), class = "data.frame")
# students should reach these as a conclusion

plot(tl ~ fl, data = df)
plot(tl ~ wt, data=df)
table(df$English)
hist(df$fishID)
sapply(df, class)
plot(wt ~ as.factor(binomial.name), data=df)

# Replace df with fishdata for full effect