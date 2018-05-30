#install XLConnect
#install.packages("XLConnect")
library(XLConnect)
search()

#load workbook
my_book <- loadWorkbook("/Users/phamdinhthang/Dropbox/R_DataScience_Tracks/Summary/sample_data/data.xlsx")

#Get sheets name
getSheets(my_book)


#Import the second sheet in my_book
my_sheet <- readWorksheet(my_book, sheet=2)
my_sheet

#Specified the colum to read
my_sheet <- readWorksheet(my_book, sheet=2,startCol = 1, endCol = 2)
my_sheet

#Create and save sheet
createSheet(my_book, name = "new_sheet")
df <- data.frame(name = c("A","B","C"), age = c(20,21,22))
writeWorksheet(my_book, data = df,sheet = "new_sheet")
saveWorkbook(my_book,"new_data.xlsx")

#Rename sheet
renameSheet(my_book,sheet = "new_sheet", newName = "new_sheet2")
getSheets(my_book)
saveWorkbook(my_book,file = "new_data2.xlsx")

#Delete sheet
removeSheet(my_book, sheet = 4)
saveWorkbook(my_book, file = "new_data3.xlsx")