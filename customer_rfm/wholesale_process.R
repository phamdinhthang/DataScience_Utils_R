library(dplyr)
library(ggplot2)
library(reshape2)
library(corrplot)
library(cluster)

#HELPERS function
cluster_and_2d_plot <- function(input_df,n_cluster) {
  cluster_model <- kmeans(input_df, centers=n_cluster, nstart=50)
  pca <- prcomp(input_df, scale=FALSE, center=TRUE)
  input_transformed <- as.data.frame(pca$x[,1:2])
  input_transformed$Cluster <- as.factor(cluster_model$cluster)
  input_centroids_transformed <- aggregate(input_transformed[1:2], 
                                                      by=list(input_transformed$Cluster), FUN=mean)
  
  plot <- ggplot() + geom_point(data=input_transformed, aes(x=PC1, y=PC2, shape = Cluster, color=Cluster), size=3) +
    geom_point(data=input_centroids_transformed, aes(x=PC1, y=PC2, shape = Group.1), color="brown", size=7)
  print(plot)
  
  return(cluster_model)
}


#Data Process
#Define the absolute path to the data file
# filepath = 'C:/Users/admin/Google Drive/Vietinbank_Lecture/datasets/Wholesale_Customer/Wholesale_customers_data.csv'
filepath = 'C:/Users/Home/Google Drive/Vietinbank_Lecture/customer_segmentation/datasets/Wholesale_Customer/Wholesale_customers_data.csv'
# filepath = '/Users/phamdinhthang/Google Drive/Vietinbank_Lecture/datasets/Wholesale_Customer/Wholesale_customers_data.csv'

#Import the data
df <- read.csv(filepath)


#Inspect the data
dim(df)
head(df)
names(df)
str(df)
summary(df)

#Change data_type and select colum
df$Channel <- as.factor(df$Channel)
df$Region <- as.factor(df$Region)
df_original <- df

#Plot Histogram for continuous variable
ggplot(data=df) + 
      geom_histogram(aes(Detergents_Paper), bins=50, col="red",fill='green') +
      labs(title=paste("Detergents_Paper sale histogram")) +
      labs(x="Spending Amount", y="Count")

#Logarithm of data
df$Fresh <- log(df$Fresh)
df$Milk <- log(df$Milk)
df$Grocery <- log(df$Grocery)
df$Frozen <- log(df$Frozen)
df$Detergents_Paper <- log(df$Detergents_Paper)
df$Delicassen <- log(df$Delicassen)

#Normalized data
df <- select(df, Fresh:Delicassen)
df <- as.data.frame(scale(df))

#View data correlation
cormat <- cor(df)
head(cormat)
melted_cormat <- melt(cormat)
corrplot(cormat, method="circle")

#Linear plot for high correlation variables
ggplot(df, aes(x=Detergents_Paper, y=Grocery)) + geom_point() + geom_smooth(method=lm)

#Linear plot for low correlation variables
ggplot(df, aes(x=Frozen, y=Grocery)) + geom_point() + geom_smooth(method=lm)
ggplot(df, aes(x=Fresh, y=Grocery)) + geom_point() + geom_smooth(method=lm)

#Plot all scatter plot
pairs(~Fresh+Milk+Grocery+Frozen+Detergents_Paper+Delicassen, data=df, main="Scatterplot Matrix")

#Simple clustering with kmeans. n_clusters=3
model <- kmeans(df,centers=4)
df$Cluster <- model$cluster

#Search for best n_clusters using elbow method
max_clusters = 15
score <- 0
for (i in 1:max_clusters) {
  km.out <- kmeans(df, centers = i+1, nstart = 50)
  score[i] <- km.out$tot.withinss/km.out$betweenss
}
wss_df <- data.frame(n_clusters=1:max_clusters, cluster_score=score)
ggplot(data=wss_df, aes(x=n_clusters, y=cluster_score)) + geom_line(linetype = "dashed")+ geom_point()

#Plot centroids details
centroids <- aggregate(df_original[3:8], by=list(model$cluster), FUN=mean)
melted_centroids <- melt(centroids, id.vars='Group.1')
ggplot(melted_centroids, aes(Group.1, value)) +   
  geom_bar(aes(fill = variable), position = "dodge", stat="identity")

#Analyse samples in cluster
df_clustered <- df_original[3:8]
df_clustered$Cluster <- model$cluster
cluster_counts <- table(df_clustered$Cluster)
print("Samples count per cluster:")
print(cluster_counts)
df_cluster3 <- filter(df_clustered, Cluster==3)
df_cluster3_little_fresh <- filter(df_cluster3,Fresh < 0.5*mean(df_cluster3$Fresh))

#Multi level cluster
model <- cluster_and_2d_plot(df,4)
df_cluster3 <- filter(df,model$cluster==3)
sub_cluster_model <- cluster_and_2d_plot(df_cluster3,3)

#Anomalies detection
df_outlier_rmv <- df_original[3:8]
kmeans_model2 <- kmeans(df_outlier_rmv, centers=5)
centroids_df <- kmeans_model2$centers[kmeans_model2$cluster, ] #a dataframe with each row is the centroids of cluster for the corresponding sample
distances <- sqrt(rowSums((df_outlier_rmv - centroids_df)^2))
df_outlier_rmv$Distance_to_Centroids <- distances

df_outlier_rmv <- arrange(df_outlier_rmv, Distance_to_Centroids)
df_outlier <- tail(df_outlier_rmv,20)
df_outlier_rmv <- head(df_outlier_rmv,-20)
print("Number of outlier")
print(dim(df_outlier))

#Cluster after remove outlier
oulier_model <- cluster_and_2d_plot(df_outlier_rmv[1:6],3)
cluster_and_2d_plot(df_original[3:8],3)

#Linear regression model to predict buy value
linear_model <- lm(formula = Frozen ~ ., data = df_original[3:8])
linear_model2 <- lm(formula = Detergents_Paper ~ Grocery+Milk, data = df_original[3:8])
predicted_Frozen <- predict(linear_model,newdata=df_original[3:8])
predicted_Detergents_Paper <- predict(linear_model2,newdata=df_original[3:8])
df_regression <- df_original[3:8]
df_regression$Frozen_predicted <- predicted_Frozen
df_regression$Detergents_Paper_predicted <- predicted_Detergents_Paper
ggplot(df_regression, aes(x=Frozen_predicted, y=Frozen)) + geom_point() + geom_smooth(method=lm)
ggplot(df_regression, aes(x=Detergents_Paper_predicted, y=Detergents_Paper)) + geom_point() + geom_smooth(method=lm)