#install data.table
#install.packages("data.table")
library(data.table)
#seaarch()


#import csv with drop and select column to read
df <- fread("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.csv", drop = c(1,2,3)) #drop the colum 1,2,3
df

df2 <- fread("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.csv", select = c(1,2,3))
df2