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

#simple plot
plot(whiteside)
before <- whiteside[whiteside$Insul == "Before",]
after <- whiteside[whiteside$Insul == "After",]
plot(before$Temp,before$Gas,xlab = "Outside temperature", ylab = "Heating gas consumption")
title("Outside temperature vs Heating gas consumption")
plot(after$Temp,after$Gas)
plot(whiteside$Insul) #plot a factor colum

#simple scatterplot with multiple input
plot(Cars93$Max.Price,Cars93$Price,pch = 17, col = "red")  #pch refer to the shape of the point in scatterplot
points(Cars93$Min.Price,Cars93$Price, pch = 16, col = "blue")
abline(a = 0, b = 1, lty = 2,col = "green") #draw linear line

#Multiple plot on 1 panel
par(mfrow = c(1,2)) #Set 1 row, 2 col plot array
plot(Animals2$body,Animals2$brain)
title("Original representation")
plot(Animals2$body,Animals2$brain, log="xy")  # Second plot: log-log plot of brain vs. body
title("Log-log plot")

#Pie-chart vs Bar-chart
data(dataCar)
par(mfrow = c(1,2))
tbl <- sort(table(dataCar$veh_body),decreasing = TRUE) # Create a table of veh_body record counts and sort
pie(tbl) # Create the pie chart and give it a title
title("Pie chart")
barplot(tbl, las = 2, cex.names = 0.5) # Create the bar-chart with perpendicular, half-sized labels
title("Bar chart")

#Histogram with density curve. Apply to see distribution of one variable in a vector
par(mfrow = c(1,2))
hist(Cars93$Horsepower, main = "hist() plot") #Histogram
truehist(Cars93$Horsepower, main = "truehist() plot") #Normalized histogram
lines(density(Cars93$Horsepower))

#qqPlot. Apply to see distribution of one variable in a vector
qqPlot(Cars93$Horsepower)

#Draw word as image
model_table <- table(Cars93$Model) # Create model_table of model frequencies
wordcloud(words = names(model_table),freq = as.numeric(model_table),scale = c(0.75,0.25),min.freq = 1)# Create the wordcloud of all model names with smaller scaling

#Multiple view aspect of a vector
par(mfrow = c(2,2))
plot(geyser$duration, main = "Raw data")
truehist(geyser$duration, main = "Histogram")
plot(density(geyser$duration),main = "Density")
qqPlot(geyser$duration, main = "QQ-plot")

#Plot array with layout
layout(matrix(c(0,1,2,0,0,3),byrow = TRUE, nrow = 3))
indexB <- which(whiteside$Insul =="Before")
indexA <- which(whiteside$Insul =="After")
plot(whiteside$Temp[indexB], whiteside$Gas[indexB],ylim = c(0,8))
title("Before data only")
plot(whiteside$Temp, whiteside$Gas,ylim = c(0,8))
title("Complete dataset")
plot(whiteside$Temp[indexA], whiteside$Gas[indexA],ylim = c(0,8))
title("After data only")

#Save plot as filepng
# Call png() with the name of the file we want to create
png("/Users/phamdinhthang/Desktop/plot.png",width = 1000, height = 1000)
plot(whiteside$Temp, whiteside$Gas,ylim = c(0,8))
dev.off()

#xyplot with lattice package
xyplot(calories ~ sugars | shelf, data = UScereal)

#scatterplot with ggplot package
colors <- c("red", "green", "yellow", "blue","black", "white", "pink", "cyan","gray", "orange", "brown", "purple")
basePlot <- ggplot(Cars93, aes(x = Horsepower, y = MPG.city)) #create plot, but not yet displayed
basePlot + geom_point(colour = colors[Cars93$Cylinders],size = as.numeric(Cars93$Cylinders))

