#create unorder factor from vector
a_factor <- factor(c("male","female"))
a_factor

#create ordered factor from vector
b_factor <- factor(c("low","medium","high"), order = TRUE, levels = c("low","medium","high"))
b_factor
summary(b_factor)

#rename factor.
a_factor
levels(a_factor) <- c("femaler","maler")
a_factor

#compare factor level
a_factor[1] < a_factor[2]
b_factor[1] > b_factor[2]