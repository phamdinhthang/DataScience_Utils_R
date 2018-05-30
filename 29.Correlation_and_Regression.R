library(MASS)
library(ggplot2)
library(openintro)

#Plot the relation between 2 variables
ggplot(Cars93, aes(x=Wheelbase, y=Length)) + geom_point()

#Dicretize the x variable and create boxplot
ggplot(Cars93, aes(x=cut(Wheelbase, breaks = 5),y=Length)) + geom_point()
ggplot(Cars93, aes(x=cut(Wheelbase, breaks = 5),y=Length)) + geom_boxplot()

#Transform the variable to create relationship
ggplot(data=mammals,aes(x=BodyWt,y=BrainWt)) + geom_point() #visually no relationship
ggplot(data = mammals, aes(x = log10(BodyWt), y = log10(BrainWt))) + geom_point() #Manually log10 the 2 axis
ggplot(data = mammals, aes(x = BodyWt, y = BrainWt)) + geom_point() + coord_trans(x = "log10", y = "log10") #1st way to autolog 2 axis
ggplot(data = mammals, aes(x = BodyWt, y = BrainWt)) + geom_point() + scale_x_log10() + scale_y_log10() #2nd way to autolog 2 axix


#calculate correlation
x <- c(1,2,3,4,5,6,7,8)
y <- c(2,3.8,6.2,8.1,10.3,11.8,13.9,16.2)
r <- cor(x,y,use = "pairwise.complete.obs") #the use parameter: only calculate pair x,y where x,y are both not NA
r
r1 <- cor(mammals$BodyWt,mammals$BrainWt)
r1
r2 <- cor(log10(mammals$BodyWt),log10(mammals$BrainWt))
r2


#linear model automatic
ggplot(data = mammals, aes(x = log10(BodyWt), y = log10(BrainWt))) + geom_point() + geom_smooth(method="lm",se=FALSE) #draw linear fit with ggplot

#compute linear regression line by hand
slope <- cor(Cars93$Wheelbase,Cars93$Length)*sd(Cars93$Length)/sd(Cars93$Wheelbase)
intercept <- mean(Cars93$Length) - slope*mean(Cars93$Wheelbase)
ggplot(Cars93, aes(x=Wheelbase, y=Length)) + geom_point() + geom_abline(intercept = intercept, slope = slope)

#compute linear regression automatic
a <- lm(formula = Length ~ Wheelbase, data = Cars93)
b <- lm(formula = log(BodyWt) ~ log(BrainWt), data = mammals)
coef(a)
summary(a)
fitted.values(a)
residuals(a)

#use lm to predict values
new_df <- data.frame(Wheelbase = c(120,130,140,150)) #new_df has a colum with the samename as the exploratory variable
predicted_length <- predict(a,newdata=new_df)
predicted_length
ggplot(data=Cars93,aes(x=Wheelbase,y=Length)) + geom_point() + geom_abline(data = coef(a), aes(intercept = (Intercept),slope = Wheelbase),color = "dodgerblue")

#Find error in lm model
sqrt(sum(residuals(a)^2) / df.residual(a)) # Compute RMSE
