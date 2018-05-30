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


#Type 1: Scatterplot & Sunflowerplot
par(mfrow = c(1,2))
plot(Boston$zn,Boston$rad)
title("Standard scatterplot")
sunflowerplot(Boston$zn,Boston$rad)
title("Sunflower plot")

#Type 2: Box plots: y vs some categorical x
boxplot(formula = crim ~ rad, data = Boston, varwidth = TRUE,las = 1, log = "y")
title("Crime rate vs. radial highway index")

#Type 3: Mosaic plots: two categorical var
mosaicplot(carb ~ cyl, data = mtcars)

#Type 4: bagplot()
par(mfrow = c(1,2))
boxplot(Cars93$Min.Price,Cars93$Max.Price)
bagplot(Cars93$Min.Price, Cars93$Max.Price, cex = 1.2)
abline(a=0,b=1,lty = 2, col = "red")

#Type 5: correlation matrix and corrrelation plot
numericalVars <- UScereal[,sapply(UScereal,is.numeric)] #Extract only numeric col from datafram. Corrplot only work with numeric df
corrMat <- cor(numericalVars) # Compute the correlation matrix for these variables
corrplot(corrMat, method = "ellipse") # Generate the correlation ellipse plot

#Type 6: Build decision tree model
tree_model <- rpart(medv ~ ., data = Boston) # Build a model to predict medv from all other Boston variables
plot(tree_model)
text(tree_model, cex = 0.7)

#Type 7: Multiple scatter plot using matplot()
df <- UScereal[, c("calories", "protein", "fat","fibre", "carbo", "sugars")] #Keep neccessary colums
matplot(df$calories,df[,c("protein","fat","fibre","carbo","sugars")], xlab = "calories", ylab = "") 
