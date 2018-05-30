#import csv
a <- read.csv("C:/data.csv")
str(a)
b <- read.csv("C:/data.csv", stringsAsFactors = FALSE)
str(b)

#import tab-delimited
d <- read.delim("C:/tab_delim.txt", stringsAsFactors = FALSE, header = TRUE)
str(d)

#import slash-delimited
e <- read.table("C:/slash_delim.txt", sep = "/", stringsAsFactors = FALSE, header = TRUE)
str(e)


#add column name when read (apply to all read.table, read.csv, read.delim)
a <- read.csv("C:/data.csv", stringsAsFactors = FALSE,col.names = c("NAME","AGE","JOB","SALARY"))
head(a)

#add column class when read (apply to all read.table, read.csv, read.delim)
b <- read.csv("C:/data.csv", stringsAsFactors = FALSE,col.names = c("NAME","AGE","JOB","SALARY"), colClasses = c("character","numeric","character","numeric"))
head(a)
str(a)

#skip line, n lines
d <- read.csv("C:/data.csv", stringsAsFactors = FALSE, header = FALSE, col.names = c("NAME","AGE","JOB","SALARY"), skip = 1, nrow = 1)
d

#comma as decimal separate
e <- read.table("C:/semicol_delim.txt", stringsAsFactors = FALSE, header = TRUE, sep = ";", dec = ",")
e
str(e)