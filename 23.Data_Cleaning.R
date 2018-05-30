#install neccessary packages
#library(dplyr)
#library(tidyr)
#library(lubridate)
#library(stringr)

#Step1: use class(), dim(), names(), str(), head(), tail(), plot(), hist() to view the data frame
#Step2: If values are used as variable (i.e many colums for a single variable), these colums needs to be gathered into 1
people <- c("Thang","Binh")
monday <- c(5,7)
tuesday <- c(1,2)
wednesday <- c(3,4)
thursday <- c(5,6)
friday <- c(7,8)
saturday <- c(9,10)
sunday <- c(10,11)
df <- data.frame(people,monday,tuesday,wednesday,thursday,friday,saturday,sunday)
head(df)

df2 <- gather(df,week_day,score,monday:sunday) #gather colums from monday to sunday into one colum: score, with people is the spread colum
df2

#Step3: reverse to step2: if values are variable name, one columns needs to be spread
df3 <- spread(df2,week_day,score)
df3

#Step3a: Separate colum into many
date_time <- c("16:30:20 15/05/2017","17:30:20 15/05/2017","18:30:20 15/05/2017","19:30:20 15/05/2017")
doing <- c("EAT","SLEEP","WORK","PLAY")
df <- data.frame(date_time,doing)
df
df2 <- separate(df,date_time,c("date","time"),sep = " ")
df2

#Step4: Unite colum into one, string manipulation and date time conversion
year <- c(2015,2016,2017)
month <- c(10,11,12)
day <- c(15,16,17)
hour <- c(13,14,15)
minute <- c(23,24,25)
second <- c(45,46,47)
score <- c(100,101,100)
df4 <- data.frame(year, month, day, hour, minute, second, score)
df4
df5 <- unite(df4,date,year,month,day,sep = "-")
df6 <- unite(df5,time,hour,minute,second, sep = ":")
df6$date <- str_replace_all(df6$date,"-","/")
df6$date <- ymd(df6$date)
df6$time <- hms(df6$time)
str(df6)

#Step5: convert coltype is neccessary
number <- c("1","2","3")
string <- c(456,789,123)
logical <- c(1,0,1)
df7 <- data.frame(number,string,logical)
df7
df7$number <- as.numeric(df7$number)
df7$string <- as.character(df7$string)
df7$logical <- as.logical(df7$logical)
str(df7)

#Step6: find and index NA
x <- c(1,2,NA)
y <- c("a",NA,"b")
z <- c(TRUE,FALSE,NA)
df8 <- data.frame(x,y,z)
df8
t <- is.na(df8)
t

#Step7: check extreme values with which(), hist() and boxplot()