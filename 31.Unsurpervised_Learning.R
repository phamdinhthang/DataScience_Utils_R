library(MASS)
library(dplyr)
library(ggplot2)
library(car)

#Kmeans
ggplot(data = whiteside, aes(x=Temp,y=Gas,color = Insul)) + geom_point()
whiteside_no_label <- whiteside[,c("Temp","Gas")]
model <- kmeans(whiteside_no_label,centers=2,nstart=20)
whiteside$predicted_group <- model$cluster
whiteside

#Finding the right number of cluster
cars <- Cars93[,c("Price","MPG.highway","Horsepower","EngineSize")]
wss <- 0 # total within sum of squares error: wss
for (i in 1:15) {
  km.out <- kmeans(cars, centers = i, nstart = 20)
  wss[i] <- km.out$tot.withinss
}
plot(1:15, wss, type = "b", xlab = "Number of Clusters", ylab = "Within groups sum of squares")
k <- 3 # Set k equal to the number of clusters corresponding to the elbow location
km.out <- kmeans(cars, centers = 3, nstart = 20)
ggplot(data = cars,aes(x=Horsepower,y=MPG.highway,col = km.out$cluster)) + geom_point()


#Hierarchical clustering
cars <- Cars93[,c("Price","MPG.highway","Horsepower","EngineSize")]
hclust.out <- hclust(dist(cars))
summary(hclust.out)
plot(hclust.out) #plot the dendrogram
abline(h=100,col="red")
groups <- cutree(hclust.out,k=3) #Cut the tree to 3 groups
cars$groups <- groups
ggplot(data=cars,aes(x=Horsepower,y=MPG.highway,color = groups)) + geom_point()

#Different linkage to Hierarchical model
hclust.complete <- hclust(dist(cars), method = "complete")
hclust.average <- hclust(dist(cars, method = "average")
hclust.single <- hclust(dist(cars), method = "single")
plot(hclust.complete, main = "Complete")
plot(hclust.average, main = "Average")
plot(hclust.single, main = "Single")

#Scale data column to avoid different units and scales
colMeans(cars) #compute colum means
apply(cars,2 ,sd) #compute colum sd
cars.scaled <- scale(cars) # Scale the data

#Comparison: Kmeans vs Hierarchical clustering
cars <- Cars93[,c("Price","MPG.highway","Horsepower","EngineSize")]
kmeans_model <- kmeans(cars,centers=3,nstart=20)
hier_model <- hclust(dist(cars),method = "complete")
cars$k_means_predict <- kmeans_model$cluster
cars$hier_predict <- cutree(hier_model,k=3)
table(cars$k_means_predict,cars$hier_predict)
cars

#Pricipal Component Analysis - Dimensional reduction
pca_model <- prcomp(iris[,1:4], scale = FALSE, center = TRUE)
summary(pca_model)
df <- as.data.frame(pca_model$x[,1:2])
df$label <- iris$Species
ggplot(data = df,aes(x=PC1,y=PC2,color = label)) + geom_point()

#Summary: Apply 3 method to Iris dataset
iris_data <- iris[,1:4]
iris_data_scale <- iris_data %>% as.matrix() %>% scale()
iris_data_pca <- prcomp(iris_data_scale, scale = FALSE, center = TRUE)

kmeans_model <- kmeans(iris_data_scale,centers = 3,nstart = 20)
hier_model <- hclust(dist(iris_data_scale),method = "complete")
hier_pca_model <- hclust(dist(iris_data_pca$x[,1:2]), method = "complete")

iris_data$kmeans_predict <- kmeans_model$cluster
iris_data$hier_predict <- cutree(hier_model,k=3)
iris_data$hier_pca_predict <- cutree(hier_pca_model,k=3)
iris_data$real <- iris$Species
iris_data


