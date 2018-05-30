library(dplyr)
library(ggplot2)
library(cluster)
library(reshape2)

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


#Read data
filepath <- 'C:/Users/Home/Google Drive/Vietinbank_Lecture/customer_lifetime_value/Online_retail/customers_RFM.csv'
df_original <- read.csv(filepath)
df <- df_original


#Change datatype
df$CustomerID <- as.factor(df$CustomerID)
str(df)
summary(df)

#Data visualization
ggplot(data=df, aes(Recency)) + 
  geom_histogram(bins=50, col="red", fill="green", alpha = .2) +
  labs(title=paste("Recency histogram")) +
  labs(x="Days since last purchase", y="Count")

ggplot(data=df, aes(Frequency)) + 
  geom_histogram(bins=50, col="red", fill="green", alpha = .2) +
  labs(title=paste("Frequency histogram")) +
  labs(x="Number of purchases", y="Count")

ggplot(data=df, aes(Monetary)) + 
  geom_histogram(bins=50, col="red", fill="green", alpha = .2) +
  labs(title=paste("Monetary histogram")) +
  labs(x="Total purchases value", y="Count")

#Filter extreme Monetary customer
print(paste("Monetary max value:",max(df$Monetary)))
percentile = 0.99
normal_monetary_value = quantile(df$Monetary, probs = percentile)

df_extreme_spent <- filter(df, Monetary > normal_monetary_value)
df <- filter(df, Monetary < normal_monetary_value & Monetary > 0)

ggplot(data=df, aes(Monetary)) + 
  geom_histogram(bins=50, col="red", fill="green", alpha = .2) +
  labs(title=paste("Monetary histogram")) +
  labs(x="Total spent", y="Count")


#Check if any variable equal to 0 (will cause error on log transform). Then normalize data
sum(df$Monetary==0)
sum(df$Recency==0)
sum(df$Frequency==0)

df$Recency_log <- log(df$Recency)
df$Frequency_log <- log(df$Frequency)
df$Monetary_log <- log(df$Monetary)

df$Recency_z <- scale(df$Recency_log, center=TRUE, scale=TRUE)
df$Frequency_z <- scale(df$Frequency_log, center=TRUE, scale=TRUE)
df$Monetary_z <- scale(df$Monetary_log, center=TRUE, scale=TRUE)

#Clustering model
kmeans_model <- cluster_and_2d_plot(select(df,Recency_z:Monetary_z),3)

#Search for best n_clusters using elbow method
max_clusters = 15
cluster_score <- 0
for (i in 1:max_clusters) {
  km.out <- kmeans(df[8:10], centers = i+1, nstart = 50)
  cluster_score[i] <- km.out$tot.withinss/km.out$betweenss
}
cluster_score_df <- data.frame(n_clusters=1:max_clusters, cluster_score=cluster_score)
ggplot(data=cluster_score_df, aes(x=n_clusters, y=cluster_score)) + geom_line(linetype = "dashed") + geom_point()

#Plot centroids details
df$Frequency_x10 <- 10*df$Frequency
centroids <- aggregate(select(df,Recency,Monetary,Frequency_x10), by=list(kmeans_model$cluster), FUN=mean)
melted_centroids <- melt(centroids, id.vars='Group.1')
ggplot(melted_centroids, aes(Group.1, value)) +   
  geom_bar(aes(fill = variable), position = "dodge", stat="identity")

#Find potential customers
df_clustered <- select(df,CustomerID:Monetary)
df_clustered$Cluster <- kmeans_model$cluster

df_cluster2 <- filter(df_clustered, Cluster==2)
df_cluster2_potential_buyer <- filter(df_cluster2, Monetary<0.3*mean(df_cluster2$Monetary))

#View boxplot of data
df_clustered <- df
df_clustered$Cluster <- as.factor(kmeans_model$cluster)
ggplot(df_clustered) + geom_boxplot(aes(Cluster, Recency))
ggplot(df_clustered) + geom_boxplot(aes(Cluster, Frequency))
ggplot(df_clustered) + geom_boxplot(aes(Cluster, Monetary))

#View data correlation
ggplot(df_clustered, aes(x=Monetary,y=Frequency)) + geom_point(color=df_clustered$Cluster)
ggplot(df_clustered, aes(x=Monetary,y=Recency)) + geom_point(color=df_clustered$Cluster)
ggplot(df_clustered, aes(x=Recency,y=Frequency)) + geom_point(color=df_clustered$Cluster)