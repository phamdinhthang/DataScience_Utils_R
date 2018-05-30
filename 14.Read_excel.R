#install readxl
#install.packages("readxl")
library(readxl)
#search()

#list the excel sheets
a <- excel_sheets("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx")
a

#read the sheet as dataframe
b <- read_excel("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx",sheet = 1)
d <- read_excel("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx",sheet = "Sheet2")
e <- read_excel("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx",sheet = 3)
b
d
e

#read entire workbook
f <- lapply(excel_sheets("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx"), read_excel, path = "/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx")
f

#read without header and add headers
g <- read_excel("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx", sheet = 4, col_names = FALSE)
g
h <- read_excel("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx", sheet = 4, col_names = c("colA","colB"))
h

#read with skip and nmax
i <- read_excel("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx", sheet = 4, col_names = FALSE,skip = 4, n_max = 3)
i

