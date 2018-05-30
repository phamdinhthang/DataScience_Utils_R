#load the neccessary package
#library(MASS)
#library(grid)
#library(ggplot2)
#library(insuranceData)
#library(robustbase)
#library(car) #qqPlot() available inside car package
#library(aplpack) #bagplot() available inside aplpack
#library(corrplot) #corrplot() available inside corrplot
#library(rpart)
#library(wordcloud) #draw word in to image
#library(lattice)
#library(ggplot2)



#Plot type option: line, point, step, overlaid
par(mfrow = c(2,2))
plot(Animals2$brain, type = "p")
title("points")
plot(Animals2$brain, type = "l")
title("lines")
plot(Animals2$brain, type = "o")
title("overlaid")
plot(Animals2$brain, type = "s")
title("steps")

#Multiple scatter on one plot using type = "n"
max_hp <- max(Cars93$Horsepower, mtcars$hp)
max_mpg <- max(Cars93$MPG.city, Cars93$MPG.highway, mtcars$mpg)
plot(MPG.city ~ Horsepower, data = Cars93, type = "n", xlim = c(0, max_hp),ylim = c(0, max_mpg), xlab = "Horsepower",ylab = "Miles per gallon") # Create plot template with type = "n", which eliminates all points  
points(mtcars$hp, mtcars$mpg, pch = 1) #add circle point
points(Cars93$Horsepower, Cars93$MPG.city, pch = 15) #add solid square point
points(Cars93$Horsepower, Cars93$MPG.highway, pch = 6) # Add open triangles point

#Add line to empty plot
x <- seq(0, 10, length = 200)
gauss1 <- dnorm(x, mean = 2, sd = 0.2) # Gaussian density for x with mean 2 and standard deviation 0.2
gauss2 <- dnorm(x, mean = 4, sd = 0.5) # Gaussian density with mean 4 and standard deviation 0.5
plot(x,gauss1, ylab = "Gaussian probability density", type ="l",lty = 1)
lines(x,gauss2, lty = 2, lwd = 3)

#Add points to empty plot
plot(mtcars$hp,mtcars$mpg,type = "n",xlab = "Horsepower", ylab = "Gas mileage")
points(mtcars$hp, mtcars$mpg, pch = mtcars$cyl) #Points with shapes determined by cylinder number
points(mtcars$hp, mtcars$mpg, pch = as.character(mtcars$cyl)) #Points with shapes as cylinder characters


#Add fitted line to scatterplot, using linear regression model
linear_model <- lm(Gas ~ Temp, data = whiteside ) # Build a linear regression model for the whiteside data
plot(whiteside$Temp,whiteside$Gas) # Create a Gas vs. Temp scatterplot from the whiteside data
abline(linear_model,lty = 2) # Add fitted line

#Add curved trend line to scatterplot
plot(Cars93$Horsepower,Cars93$MPG.city)
trend1 <- supsmu(Cars93$Horsepower,Cars93$MPG.city) # generate a smooth trend curve, with default bass
lines(trend1, lty = 1)
trend2 <- supsmu(Cars93$Horsepower,Cars93$MPG.city, bass = 10) # second trend curve, with bass = 10
lines(trend2, lty = 3, lwd = 2)

#Add text to plot
plot(Cars93$Horsepower, Cars93$MPG.city, pch = 15)
index3 <- which(Cars93$Cylinders == 3) #index of car with 3 cylinders
points(Cars93$Horsepower[index3], Cars93$MPG.city[index3], pch = 16, col = "red") # Highlight 3-cylinder cars
text(x = Cars93$Horsepower[index3],y = Cars93$MPG.city[index3],labels = Cars93$Manufacturer[index3], adj = -0.2, cex = 1.2, font = 4, srt = 45)

#Add legend to plot
plot(whiteside$Temp, whiteside$Gas,type = "n")
indexB <- which(whiteside$Insul == "Before")
indexA <- which(whiteside$Insul == "After")
points(whiteside$Temp[indexB], whiteside$Gas[indexB],pch = 17)
points(whiteside$Temp[indexA], whiteside$Gas[indexA],pch = 1)
legend("topright", pch = c(17,1),legend = c("Before", "After"))

#Add custom axis
boxplot(sugars ~ shelf, data = UScereal, axes = FALSE)
axis(side = 2)
axis(side = 1, at = c(1,2,3))
axis(side = 3, at = c(1,2,3),labels = c("floor","middle","top"))

#Using various color
colors <- c("red", "green", "yellow", "blue","black", "white", "pink", "cyan","gray", "orange", "brown", "purple")
barWidths <- c(rep(2, 6), rep(1, 6)) #Data for bar plot
barplot(rev(barWidths), horiz = TRUE,col = rev(colors), axes = FALSE,names.arg = rev(colors), las = 1)

