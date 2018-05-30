#install readr
#install.packages("readr")
library(readr)
#search()

#read_csv with colname and colclass. c = character, i = integer, d = double, l = logical, _ = skip colum
df <- read_csv("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.csv",col_names = c("NAME","AGE","JOB","SALARY"), col_types = "cicd")
df
str(df)

#read_csv with skip and nrow. Attention: read_csv alway uses first line as header
df2 <- read_csv("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.csv",skip=1,n_max=2,col_names = c("NAME","AGE","JOB","SALARY"))
df2

#read tab-delimit
df3 <- read_tsv("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/tab_delim.txt",skip=1,n_max=2,col_names = c("NAME","AGE","JOB","SALARY"))
df3

#read semicol_delimit
df4 <- read_delim("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/semicol_delim.txt",delim = ";",skip=1,n_max=2,col_names = c("NAME","AGE","JOB","SALARY"))
df4