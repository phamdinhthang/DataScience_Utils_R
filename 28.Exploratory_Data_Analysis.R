library(MASS)
library(ggplot2)

#Find the factor level of a colums
levels(Cars93$AirBags)
levels(Cars93$DriveTrain)


#Count element in a factor colum
table(Cars93$AirBags) #Return one vector of elements count
table(Cars93$AirBags,Cars93$DriveTrain) #Return one table of elements count
table(Cars93$AirBags,Cars93$DriveTrain,Cars93$Make) #Return multiple table

#Count element as proportion
options(scipen = 999, digits = 3) #Number format to fewer digits
prop.table(table(Cars93$AirBags,Cars93$DriveTrain)) #Divide each count to sum of all count. Therefore, sum of all table element = 1
prop.table(table(Cars93$AirBags,Cars93$DriveTrain),1) #Conditional on row. Divide each count to sum of all count in row. Therefore, sum of all row = 1
prop.table(table(Cars93$AirBags,Cars93$DriveTrain),2) #Conditional on col. Divide each count to sum of all count in col. Therefore, sum of all col = 1

#Plot contigency table
ggplot(Cars93, aes(x=DriveTrain, fill = AirBags)) + geom_bar()
ggplot(Cars93, aes(x = DriveTrain, fill = AirBags)) + geom_bar(position = "fill")
hist(Cars93$DriveTrain)

#Facet barchat vs stacked Barchat
ggplot(Cars93, aes(x=DriveTrain)) + geom_bar() #Simple barchat
ggplot(Cars93, aes(x=DriveTrain)) + geom_bar() + facet_wrap(~ AirBags) #Facet barchat
ggplot(Cars93, aes(x=DriveTrain, fill = AirBags)) + geom_bar() #Stack barchat

#Facet histogram
ggplot(Cars93, aes(x=MPG.city)) + geom_histogram()
ggplot(Cars93, aes(x=MPG.city)) + geom_histogram() + facet_wrap(~ Cylinders)

#Box plot & Density plot for multiple var
ggplot(Cars93, aes(x=Cylinders, y = MPG.city)) + geom_boxplot()
Cars93 %>% filter(Cylinders != 5) %>% ggplot(aes(x=MPG.city, fill = Cylinders)) + geom_density(alpha = .3)

#Histogram with x limit and bin-width
ggplot(Cars93, aes(x=MPG.city)) + xlim(c(15,35)) + geom_histogram(binwidth = 1)

#Plot for 3 variable
ggplot(Cars93, aes(x=MPG.city)) + geom_histogram(binwidth = 1) + facet_wrap(Origin ~ AirBags, labeller = label_both)

#measure center
mean(Cars93$Min.Price)
median(Cars93$Min.Price)
mode(Cars93$Min.Price)

#measure variability
var(Cars93$Min.Price)
sd(Cars93$Min.Price)
range(Cars93$Min.Price)