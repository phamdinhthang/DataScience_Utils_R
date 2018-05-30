library(dplyr)
library(MASS) 
library(ggplot2)
library(tidyr)
library(openintro)

#Count elements in a data frame
glimpse(whiteside)
table(whiteside$Insul)
table(whiteside$Gas) 

#Filter elements
whiteside_before = filter(whiteside, Insul == "Before")
glimpse(whiteside_before)
table(whiteside_before$Insul)

#Remove uncessessary factor
whiteside_before$Insul <- droplevels(whiteside_before$Insul)
table(whiteside_before$Insul) 

#Create column base on condition
whiteside <- whiteside %>% mutate(High_Usage = ifelse(Gas > 5,"High usage","Low usage"))
head(whiteside)

#Vizualise data with ggplot
ggplot(data = whiteside, aes(x=Temp,y=Gas, color = factor(Insul))) + geom_point()


#Keyword: Observational study vs Experimental study, Random Sampling vs Random Assignment, Simpson paradox


#count fuction
whiteside$High_Usage <- as.factor(whiteside$High_Usage)
count(whiteside,Insul,High_Usage) %>% spread(Insul,n)

#sampling data
refer to chapter 3, Introduction to Data course

#simple random sample
sample_n(dataframe, size = 100)
#Stratified sample
dataframe %>% group_by(a_colum) %>% sample_n(size = 10) #get 10 values from each group
#Cluster sample
#Multigrade sample

