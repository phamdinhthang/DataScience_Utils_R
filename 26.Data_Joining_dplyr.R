#library(dplyr)
#library(purrr)

#Left & right join 2 tables with single keys. Note: let_join(a,b,by="x") is equal right_join(b,a,by="x")
names_df <- data.frame(name = c("Mick","John","Paul"), band = c("Stones","Beatles","Beatles"))
plays_df <- data.frame(name = c("John","Paul","Keith"),plays =c("Guitar","Bass","Guitar"))
names_plays <- left_join(names_df,plays_df,by="name")
names_plays
plays_names <- right_join(names_df,plays_df,by="name")
plays_names

#Left join with 2 table and multiple keys
names_df <- data.frame(name = c("John","John","Paul"), surname = c("Coltrane","Lennon","McCartney"),band = c(NA,"Beatles","Beatles"))
plays_df <- data.frame(name = c("John","Paul","Keith"), surname = c("Lennon","McCartney","Richards"),plays = c("Guitar","Bass","Guitar"))
names_plays <- left_join(names_df,plays_df,by = c("name","surname"))
names_plays

#inner_join and full join
names_plays_inner <- inner_join(names_df,plays_df,by = c("name","surname")) #keep only rows appears on both df, remove rows with NA
names_plays_inner
names_plays_full <- full_join(names_df,plays_df,by = c("name","surname")) #keep all rows in both 2 df
names_plays_full

#rename colum name
names_df <- data.frame(called = c("John","John","Paul"), surname = c("Coltrane","Lennon","McCartney"),band = c(NA,"Beatles","Beatles"))
rename(names_df,called = name)
names_df

#select name to join
names_df <- data.frame(firstname = c("John","John","Paul"), lastname = c("Coltrane","Lennon","McCartney"),band = c(NA,"Beatles","Beatles"))
plays_df <- data.frame(name = c("John","Paul","Keith"), surname = c("Lennon","McCartney","Richards"),plays = c("Guitar","Bass","Guitar"))
names_plays <- left_join(names_df,plays_df,by = c("firstname" = "name","lastname" = "surname"))
names_plays

#duplicate colname
names_df <- data.frame(name = c("Mick","John","Paul"), plays = c("Stones","Beatles","Beatles"))
plays_df <- data.frame(name = c("John","Paul","Keith"),plays =c("Guitar","Bass","Guitar"))
names_plays <- left_join(names_df,plays_df,by="name",suffix=c("1","2"))
names_plays


#all join can work with the pipe operator
a <- data.frame(name = c("A","B","C"),age = c(10,11,12))
b <- data.frame(name = c("B","C","D"),job = c("Teacher","Student","Student"))
d <- data.frame(name = c("A","D","B"),place = c("NY","LA","SF"))
x <- a %>% full_join(b,by="name") %>% inner_join(d,by="name")
x

#filtering joins
#semi_join: keep the first table with only rows that appear in second table
y <- semi_join(a,b,by = "name")
y

#anti_join: keep the first table with only rows that not appear in second table
z <- anti_join(a,b,by="name")
z


#set operation to manipulate two df with identical variables
a <- data.frame(height = c(50,60,70), age = c(10,11,12))
b <- data.frame(height = c(60,150,160), age = c(11,22,23))
m <- union(a,b)
m
n <- intersect(a,b)
n
p <- setdiff(a,b)
p

#check 2 df are equal
r <- data.frame(height = c(50,60,70), age = c(10,11,12))
s <- data.frame(height = c(70,60,50), age = c(12,11,10))
identical(r,s)
setequal(r,s)


#bind rows and cols
r <- data.frame(height = c(50,60,70), age = c(10,11,12))
s <- data.frame(height = c(70,60,50), age = c(12,11,10))
t <- bind_rows(r,s)
t
u <- bind_cols(r,s) #Give attention to data order in 2 table when doing bind_cols
u

#bind rows with row names groups
r <- data.frame(height = c(50,60,70), age = c(10,11,12))
s <- data.frame(height = c(70,60,50), age = c(12,11,10))
t <- bind_rows(name1 = r, name2 = s, .id = "groupName")
t

#data_frame and as_data_frame
df <- data_frame(first = c(1,2,3,4,5,6), second = c(6,5,4,3,2,1), third = c(TRUE,TRUE,FALSE,TRUE,FALSE,FALSE))
df
df2 <- as_data_frame(list(first = c(1,2,3,4,5,6), second = c(6,5,4,3,2,1), third = c(TRUE,TRUE,FALSE,TRUE,FALSE,FALSE)))
df2


#join multiple table with purrr
age <- data.frame(name = c("John","Paul","James"),age = c(20,21,22))
job <- data.frame(name = c("John","Paul","James"),job = c("guitarist","bassist","drummer"))
salary <- data.frame(name = c("John","Paul","James"),salary = c(2000,2100,2200))
place <- data.frame(name = c("John","Paul","James"),place = c("NY","LA","NY"))
tables <- list(age,job,salary,place)
join_all <- reduce(tables,left_join,by="name")
join_all

#case study: many useful exercise in the last chapter of the course. Do the case study

