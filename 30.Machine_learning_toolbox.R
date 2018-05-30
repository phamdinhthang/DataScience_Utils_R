library(MASS)
library(caret)
library(dplyr)
library(mlbench)
library(caTools)
library(RANN)

#Calculate RMSE for model fit with same data
model <- lm(formula = mpg ~ cbind(cyl,hp,gear), data = mtcars)
predicted_mpg <- predict(model, newdata =  mtcars)
predicted_mpg
error <- predicted_mpg - mtcars$mpg
rmse <- sqrt(mean(error^2))
rmse

#Calculate RMSE for model fit with separated training and testing data
model2 <- lm(formula = mpg ~ cbind(hp,gear), data = mtcars[1:20,])
predicted_mpg2 <- predict(model, newdata = mtcars[21:30,])
error2 <- predicted_mpg2 - mtcars[21:30,]$mpg
rmse2 <- sqrt(mean(error2^2))
rmse2

#random arrange the dataset to prepare for train/test split
set.seed(50)
rows <- sample(nrow(mtcars)) #create random row index
mtcars <- mtcars[rows,]

#create 80/20 train/test set
split <- round(nrow(mtcars)*0.8)
train_set <- mtcars[1:split,]
test_set <- mtcars[(split+1):nrow(mtcars),]

#training on train data, test on test data
model3 <- lm(formula = mpg ~ cbind(disp,hp),data = train_set)
predicted_mpg3 <- predict(model3, newdata = test_set)
error3 <- predicted_mpg3 - test_set$mpg
rmse3 <- sqrt(mean(error3^2))
rmse3

#Cross - validation with caret package
model4 <- train(mpg ~ cbind(disp,hp), mtcars, method = "lm",trControl = trainControl(method = "cv", number = 10,verboseIter = TRUE)) #Single cross validation
model4
model5 <- train(mpg ~ cbind(disp,hp), mtcars, method = "lm",trControl = trainControl(method = "cv", number = 10,repeats = 5,verboseIter = TRUE)) #Multiple cross validation
model5
predict(model4, mtcars)
b <- predict(model5, mtcars)
mtcars <- mutate(mtcars,predicted_mpg = b)
ggplot(data = mtcars,aes(x=disp,y=mpg))+geom_point(aes(color = "blue")) + geom_point(data = mtcars,aes(x=disp,y=predicted_mpg,color = "red"))

#Logistic Regression
data(Sonar)
rows <- sample(nrow(Sonar))
Sonar <- Sonar[rows,]
split <- round(nrow(Sonar)*0.6)
train <- Sonar[1:split,]
test <- Sonar[(split+1):nrow(Sonar),]

model <- glm(formula = Class ~. ,family = "binomial", data = train)
p <- predict(model, newdata = test, type = "response") #p is a numeric vector, showing probability of class
p_class <- ifelse(p > 0.5, "M","R")
confusionMatrix(p_class,test$Class)

#Choosing the threshold to classify p shall change the confusion matrix and overall accuracy
p_class2 <- ifelse(p > 0.8, "M","R")
confusionMatrix(p_class2,test$Class)

#ROC curve to find the threshold
colAUC(p,test$Class, plotROC = TRUE)

#Random forest with mtry selected by machine
set.seed(42)
model <- train(Class ~.,tuneLength = 5,data = Sonar, method = "ranger",trControl = trainControl(method = "cv", number = 5, verboseIter = TRUE))
plot(model)
predicted_class <- predict(model,newData = Sonar)
predicted_is_correct <- predicted_class == Sonar$Class
predicted_is_correct

#Random forest with mtry selected by hand
set.seed(42)
model <- train(Class ~.,tuneGrid = data.frame(mtry = c(2,3,4,5,6,7,10,14)),data = Sonar, method = "ranger",trControl = trainControl(method = "cv", number = 5, verboseIter = TRUE))
print(model)
plot(model)

#Compare classification by random forest & logistic regression
random_forest_model <- train(Class ~., tuneLength = 10, data = Sonar, method = "ranger", trControl = trainControl(method="cv",number = 5,verboseIter = TRUE))
logistic_reg_model <- train(Class~. , data = Sonar, method = "glm", family = "binomial", trControl = trainControl(method = "cv", number = 5, verboseIter = TRUE))
print(random_forest_model)
print(logistic_reg_model)
predicted_class_by_rf <- predict(random_forest_model,newData = Sonar)
predicted_class_by_lg <- predict(logistic_reg_model,newData = Sonar)
predicted_class_by_rf_true <- predicted_class_by_rf == Sonar$Class
predicted_class_by_lg_true <- predicted_class_by_lg == Sonar$Class
predicted_class_by_rf_true
predicted_class_by_lg_true


#Preprocess data before training
#Median imputation: replace NA with the median values automatically
set.seed(42)
mtcars[sample(1:nrow(mtcars),10),"hp"] <- NA #Add some NA in the hp col of mtcars
train_col <- mtcars[,c("disp","hp")]
output_col <- mtcars[,"mpg"]
model <- train(x=train_col,y=output_col,method = "lm",preProcess = "medianImpute")
predicted <- predict(model,newData = mtcars)
predicted

#kNN imputation: median imputation is not good if the NA data is with pattern, not randomly. For example: small disp cars do not report hp
set.seed(42)
mtcars[mtcars$disp < 140,"hp"] <- NA
train_col <- mtcars[,c("disp","hp")]
output_col <- mtcars[,"mpg"]
model2 <- train(x=train_col,y=output_col,method = "glm",preProcess = "knnImpute")
model3 <- train(x=train_col,y=output_col,method = "glm",preProcess = "medianImpute")
print(min(model2$result$RMSE))
print(min(model3$result$RMSE))

#Multiple preprocess
set.seed(42)
mtcars[mtcars$disp < 140,"hp"] <- NA
train_col <- mtcars[,c("disp","hp")]
output_col <- mtcars[,"mpg"]
model4 <- train(x=train_col,y=output_col,method = "glm",preProcess = c("medianImpute","center","scale"))
print(min(model4$result$RMSE))

#Remove contant colum (var = 0) or nearly non variate colum (var ~ 0)
set.seed(42)
mtcars[mtcars$disp < 140,"hp"] <- NA
mtcars$constant <- rep(1,times = nrow(mtcars))
train_col <- mtcars[,c("disp","hp","constant")]
output_col <- mtcars[,"mpg"]
model5 <- train(x=train_col,y=output_col,method = "glm",preProcess = c("medianImpute","center","scale"))
model6 <- train(x=train_col,y=output_col,method = "glm",preProcess = c("nzv","zv","medianImpute","center","scale"))
print(model5)
print(model6)

#Using PCA: keep nearly non variate columns, but combine them 
set.seed(42)
mtcars[mtcars$disp < 140,"hp"] <- NA
mtcars$constant <- rep(1,times = nrow(mtcars))
train_col <- mtcars[,c("disp","hp","constant")]
output_col <- mtcars[,"mpg"]
model7 <- train(x=train_col,y=output_col,method = "glm",preProcess = c("zv","medianImpute","center","scale","pca"))
print(model7)

#Case study
# Create custom indices: myFolds
myFolds <- createFolds(mtcars$mpg, k = 5)

myControl <- trainControl(
  summaryFunction = twoClassSummary,
  classProbs = TRUE, # IMPORTANT!
  verboseIter = TRUE,
  savePredictions = TRUE,
  index = myFolds
)

model_glmnet <- train(
  x = mtcars[,c("disp","hp")], y = mtcars$mpg,
  metric = "ROC",
  method = "glmnet",
  trControl = myControl
)

model_rf <- train(
  x = mtcars[,c("disp","hp")], y = mtcars$mpg,
  metric = "ROC",
  method = "ranger",
  trControl = myControl
)

model_list <- list(item1 = model_glmnet, item2 = model_rf)
resamples <- resamples(model_list)
summary(resamples)
