#import neccessary library
#library(readxl)
#library(gdata)
#library(httr)

#Read from HTTP .csv, .txt files
url_csv <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/swimming_pools.csv"
pools <- read.csv(url_csv)
url_delim <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/potatoes.txt"
potatoes <- read.delim(url_delim,sep = "\t")
head(pools)
head(potatoes)


#Read excel from HTTP
url_xls <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/latitude.xls"
excel_gdata <- read.xls(url_xls)

download.file(url_xls, destfile  = "C:\local_latitude.xls")
excel_readxl <- read_excel("C:\local_latitude.xls") #read_excel cannot download url, therefore need a download first

#Load .rdata files from http
url_rdata <- "https://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/wine.RData"
download.file(url_rdata, destfile = "wine_local.RData")
load("wine_local.RData")
summary(wine)

#Load raw data with httr
url <- "http://www.example.com/"
resp <- GET(url)
print(resp)
raw_content <- content(resp,as = "raw")
head(raw_content)

#Simple load json data
url <- "http://www.omdbapi.com/?apikey=ff21610b&t=Annie+Hall&y=&plot=short&r=json"
resp <- GET(url)
content(resp)

