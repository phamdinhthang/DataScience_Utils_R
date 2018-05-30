library(recommenderlab)
library(ggplot2)
library(data.table)
library(reshape2)
library(corrplot)
library(dplyr)
library(tidyr)
library(scales)

#Import data
# movies <- read.csv("/Users/phamdinhthang/Google Drive/Vietinbank_Lecture/Recommendation_System/ml-latest-small/movies.csv",stringsAsFactors=FALSE)
# ratings <- read.csv("/Users/phamdinhthang/Google Drive/Vietinbank_Lecture/Recommendation_System/ml-latest-small/ratings.csv")

movies <- read.csv("C:/Users/Home/Google Drive/Vietinbank_Lecture/Recommendation_System/ml-latest-small/movies.csv",stringsAsFactors=FALSE)
ratings <- read.csv("C:/Users/Home/Google Drive/Vietinbank_Lecture/Recommendation_System/ml-latest-small/ratings.csv")


#Data inspection
head(movies)
str(movies)
summary(movies)

head(ratings)
str(ratings)
summary(ratings)


#Processing genre in movies
genres <- as.data.frame(movies$genres, stringsAsFactors=FALSE)
genres_df <- as.data.frame(tstrsplit(genres[,1], '[|]',type.convert=TRUE),stringsAsFactors=FALSE)
colnames(genres_df) <- c(1:10)
print(head(genres_df))

#Get Unique Genre value
all_genres <- movies$genres
genres_string <- ""
for (genre in all_genres) {
  genres_string <- paste(genres_string,genre,sep="|")
}

genre_list <- as.list(strsplit(genres_string,"|",fixed=TRUE))[[1]]
genre_list <- unique(genre_list)
print(genre_list)

#Filter out some non-meaningful genre
genre_list <- genre_list[-c(1,length(genre_list))]
genre_list <- genre_list[genre_list != 'IMAX']
print(genre_list)

#Create placeholder for mapping matrix 
genre_matrix <- matrix(0,nrow(movies)+1,length(genre_list))
genre_matrix[1,] <- genre_list
colnames(genre_matrix) <- genre_list

#Fill mapping matrix and convert to a dataframe
for (i in 1:nrow(genres_df)) {
  for (j in 1:ncol(genres_df)) {
    genmat_col = which(genre_matrix[1,] == genres_df[i,j])
    genre_matrix[i+1,genmat_col] <- 1
  }
}
genre_matrix <- genre_matrix[-1,]
genre_matrix <- as.data.frame(genre_matrix, stringsAsFactors=FALSE)
print(head(genre_matrix))

#Split the title column into title and year vector
movies_full_title <- movies$title
movies_year <- c()
movies_title <- c()
index <- 1
for (title in movies_full_title) {
  title_elements <- as.list(strsplit(title," ",fixed=TRUE))[[1]]
  year <- title_elements[length(title_elements)]
  year <- substr(year, 2, nchar(year)-1)
  
  year_pattern_len <- 7
  title_only <- substr(title, 1, nchar(title)-year_pattern_len)
  movies_year[index] <- as.numeric(year)
  movies_title[index] <- title_only
  index <- index+1
}

full_movies_info <- cbind(movies$movieId, movies_title, movies_year, genre_matrix)
colnames(full_movies_info) <- c("movieId", "title", "year", genre_list)
print(head(full_movies_info))

#Inspection on some movies which failed for year conversion
na_idx <- which(is.na(full_movies_info$year))
print(select(movies[na_idx,], c(movieId,title)))

#Check and filter NA from full_movies_info
print(paste("Number of missing value rows:",sum(is.na(full_movies_info))))
full_movies_info <- na.omit(full_movies_info)
movies <- full_movies_info


#Save output to CSV file
output_path <- "C:/Users/Home/Google Drive/Vietinbank_Lecture/Recommendation_System/ml-latest-small/full_movies_info.csv"
write.csv(full_movies_info, output_path,row.names=FALSE)
movies <- read.csv(output_path, stringsAsFactors=FALSE)


#Remove movie from the movies table which does not have rating. Remove movie from rating table that does not have movie info
movies <- movies[-which((movies$movieId %in% unique(ratings$movieId)) == FALSE),]
ratings <- ratings[-which((ratings$movieId %in% unique(movies$movieId)) == FALSE),]

#Analyse rating table
print(paste("Rating system:",sort(unique(ratings$rating))))
print(paste("Number of rated user:",length(unique(ratings$userId))))
print(paste("Number of rated movie:",length(unique(ratings$movieId))))

#Distribution of rating
ratings_summary <- ratings %>% group_by(rating) %>% summarize(Count=NROW(movieId))
ggplot(data=ratings_summary, aes(x=rating, y=Count)) + geom_bar(stat="identity")

#Rating per user
user_summary <- ratings %>% group_by(userId) %>% summarize(AvgRate=mean(rating),
                                                           NumberOfRate=NROW(rating))
ggplot(data=user_summary) + geom_histogram(aes(AvgRate), bins=50, col='red',fill='green')

#Most and least active user
most_active <- head(arrange(user_summary,desc(NumberOfRate)),20)
least_active <- tail(arrange(user_summary,desc(NumberOfRate)),20)
ggplot(data=most_active, aes(x=as.factor(userId), y=NumberOfRate)) + geom_bar(stat="identity")
ggplot(data=least_active, aes(x=as.factor(userId), y=NumberOfRate)) + geom_bar(stat="identity")

#Distribution of movies by year
ggplot(movies)+geom_histogram(aes(year), bins=50, col='red',fill='green')

#Movies by number of rate
movie_summary <- ratings %>% group_by(movieId) %>% summarize(NumberOfRate=NROW(movieId),
                                                             AverageRating=mean(rating))
movie_summary <- inner_join (movie_summary,select(movies,c(movieId,title,year)), by = c("movieId"))

most_views <- head(arrange(movie_summary,desc(NumberOfRate)),10)
least_views <- tail(arrange(movie_summary,desc(NumberOfRate)),10)
top_rated <- head(arrange(movie_summary,desc(AverageRating)),10)
ggplot(data=most_views, aes(x=title, y=NumberOfRate)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggplot(data=least_views, aes(x=title, y=NumberOfRate)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggplot(data=top_rated, aes(x=title, y=AverageRating)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Top rated movies with at least 100views
high_views <- filter(movie_summary, NumberOfRate > 100)
top_rated <- head(arrange(high_views,desc(AverageRating)),10)
ggplot(data=top_rated, aes(x=title, y=AverageRating)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Movies ratings vs year
ggplot(movie_summary, aes(x=year,y=AverageRating)) + geom_point()
ggplot(movie_summary, aes(x=year,y=NumberOfRate)) + geom_point()

#Movies count by Genres
genres_df <- select(movies, -c(movieId, title, year))
genres_count <- as.data.frame(colSums(genres_df))
genres_count$Genre_name <- rownames(genres_count)
ggplot(genres_count, aes(x=Genre_name,y=colSums(genres_df))) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 45, hjust = 1))


#Create Utility Matrix by spreading the ratings dataframe. (to compatible with recommenderlab package format, in Utility Matrix, row=users, col=items)
utility_matrix <- dcast(ratings, userId~movieId, value.var = "rating", na.rm=FALSE)
utility_matrix <- as.matrix(utility_matrix[,-1])

#Convert utility_matrix to a tibble for easily view & inspection
utility_tbl <- as_tibble(utility_matrix)
print(utility_tbl)

print(paste("Total cells",nrow(utility_matrix)*ncol(utility_matrix)))
print(paste("Total rated cells",sum(!is.na(utility_matrix))))
print(paste("Total non-rated cells",sum(is.na(utility_matrix))))


#CONTENT BASED FILTERING
user_id <- 10
user_rate <- utility_matrix[user_id,]
print(paste("Number of movies rated by user:",sum(!is.na(user_rate))))

#Create a dataframe for user
user_df <- movies
user_df$user_rate <- user_rate

#View movies which user have rated
user_rated_movies_df <- filter(user_df,!is.na(user_rate))
user_rated_movies_df <- select(user_rated_movies_df, c(movieId,title,year,user_rate))
print(user_rated_movies_df)

#Use rated movies to train model, use unrated movies to test model
user_rated_df <- filter(user_df, !is.na(user_rate))
user_unrated_df <- filter(user_df, is.na(user_rate))

#Fit a linear model
model <- lm(formula = user_rate ~ ., data = select(user_rated_df, -c(movieId,title)))
print(model)

#Checking correlation between genres. NOTE: USE LINEAR MODEL TO EXPLORER LINEAR COMBINATION OF CORRELATION
cormat <- cor(select(movies,Adventure:Film.Noir))
melted_cormat <- melt(cormat)
corrplot(cormat, method="number")

#Fit model again, remove correlated features
content_based_model <- lm(formula = user_rate ~ ., data = select(user_rated_df, -c(movieId,title,Animation,Children,Documentary,Film.Noir)))
print(content_based_model)

#Print the model coefficient
coefs <- abs(content_based_model$coefficients)
coefs <- sort(coefs[2:length(coefs)])
par(mai=c(1,2,1,1))
barplot(coefs, main="Linear model coefficients", horiz=TRUE, names.arg=names(coefs), las=1)

#Predict rating for unrated movies
predict_unrated <- predict(content_based_model,newdata=select(user_unrated_df,-c(movieId,title,Animation,Children,Documentary,Film.Noir)))
user_unrated_df$predicted_rating <- predict_unrated
head(user_unrated_df)

#Predict rating for rated movies
predict_rated <- predict(content_based_model,newdata=select(user_rated_df,-c(movieId,title,Animation,Children,Documentary,Film.Noir)))
user_rated_df$predicted_rating <- predict_rated
head(user_rated_df)

mean_abs_error <- mean(abs(user_rated_df$user_rate-user_rated_df$predicted_rating))
print(paste("Mean absolute error on rating predictions:",mean_abs_error))

#Print some recommendation for user 1
sorted_prediction <- arrange(user_unrated_df,desc(predicted_rating))
content_based_recommendation <- head(select(sorted_prediction,c(title,predicted_rating)),20)
print(content_based_recommendation)

#COLLABORATIVE BASED FILTERING
#Normalize function
row_normalize <- function(x) {
  x-mean(x,na.rm = TRUE)
}

#Normalize Utility Matrix by row (normalize per user), then fill NA with rating=0
utility_matrix_normalized <- t(apply(utility_matrix, 1, row_normalize))
utility_matrix_normalized[is.na(utility_matrix_normalized)] <- 0

#Convert utility_matrix to suitable recommenderlab datatype
rating_matrix <- as(utility_matrix, "realRatingMatrix")

#Calculate the User similarities (subset first 20 user for simplicity)
similarity_users <- 1-as.matrix(similarity(rating_matrix[1:10,],method = "pearson", which = "users"))
corrplot(similarity_users, method='number')


#Create User-Based Collaborative Filtering Recommender Model (UBCF)
ubcf_recommender <- Recommender(rating_matrix, method = "UBCF", param=list(method="cosine"))
ibcf_recommender <- Recommender(rating_matrix, method = "IBCF", param=list(method="pearson"))
svd_recommender <- Recommender(rating_matrix, method = "SVD")

#Select a model to perform Recommendation
recommender_models <- c(ubcf_recommender, ibcf_recommender, svd_recommender)
recommender_model <- recommender_models[[1]]
model_details <- getModel(recommender_model)

#Make prediction on recommendation
user_id <- 10
user_rate <- rating_matrix[user_id]
collaborative_based_rating <- predict(recommender_model, user_rate, type="ratings")
collaborative_based_rating <- as(collaborative_based_rating, "matrix")[1,]

recom <- movies
recom$predicted_rating <- collaborative_based_rating
recom <- arrange(recom,desc(predicted_rating))
collaborative_recommendation <- head(select(recom,c(movieId,title,year,predicted_rating)),20)
print(collaborative_recommendation)


#Averaging over content_based model, UBCF, IBCF, SVD to make recommendation
content_based_rating <- predict(content_based_model, newdata=select(user_df,-c(movieId,title,Animation,Children,Documentary,Film.Noir,user_rate)))
collaborative_based_rating <- predict(recommender_model, user_rate, type="ratings")
collaborative_based_rating <- as(collaborative_based_rating, "matrix")[1,]

averaged_rating <- rowMeans(cbind(collaborative_based_rating,content_based_rating))
user_df$averaged_rating <- averaged_rating
top_recom <- head(select(arrange(user_df,desc(averaged_rating)),c(movieId,title,year,averaged_rating)),20)
print(top_recom)