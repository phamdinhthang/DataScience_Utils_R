#Install neccessary package
#install.packages("RMySQL")
#library(DBI)

#Create MySQL connection
con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "tweater", 
                 host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com", 
                 port = 3306,
                 user = "student",
                 password = "datacamp")

#127.0.0.1 is the ip for localhost. View localhost ip by typing "sudo nano etc/host" in Terminal
conLocal <- dbConnect(RMySQL::MySQL(), 
                 dbname = "new2", 
                 host = "127.0.0.1", 
                 port = 3306,
                 user = "root",
                 password = "")
                 
#List table name
dbListTables(con)
dbListTables(conLocal)

#Import table to data.frame
user_df <- dbReadTable(con,"users")
head(user_df)
tab_post_df <- dbReadTable(conLocal,"'tab-post'")
head(tab_post_df)

#Import all table
table_names <- dbListTables(con)
tables <- lapply(table_names, dbReadTable, conn = con)
str(tables)

#Querry table from R
elisabeth <- dbGetQuery(con, "SELECT tweat_id FROM comments WHERE user_id = 1")
print(elisabeth)
latest <- dbGetQuery(con,"SELECT post FROM tweats WHERE date > '2015-09-21'")
print(latest)
specific <- dbGetQuery(con,"SELECT message FROM comments WHERE tweat_id = 77 AND user_id > 5")
print(specific)
short <- dbGetQuery(con, "SELECT id,name FROM users WHERE CHAR_LENGTH(name) < 5")
print(short)

#Query with Inner join
tweat_mess <- dbGetQuery(con,"SELECT post, message FROM tweats INNER JOIN comments on tweats.id = tweat_id WHERE tweat_id = 77")
print(tweat_mess)

#Send - Fetch - Clear: to fetch the result by number of rows
res <- dbSendQuery(con, "SELECT * FROM comments WHERE user_id > 4")
dbFetch(res, n = 2)
dbFetch(res)

res1 <- dbSendQuery(con, "SELECT * FROM comments WHERE user_id > 3")
while (!dbHasCompleted(res1)) {
	print(dbFetch(res1,n=1))
}

dbClearResult(res)
dbClearResult(res1)

#Disconnect after finish
dbDisconnect(con)
dbDisconnect(conLocal)
