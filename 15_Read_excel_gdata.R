#install gdata
#install.packages("gdata")
library(gdata)
search()

#read xls
data <- read.xls("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx",sheet = 4)
data

#read with param
data2 <- read.xls("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx",sheet = 4, skip = 3, header = FALSE, stringsAsFactors = FALSE, col.names = c("colA","colB"))
data2