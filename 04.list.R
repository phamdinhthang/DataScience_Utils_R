#create list
a <- 1
b <- TRUE
d <- c(1,2,3)
e <- matrix(c(1,2,3,4),byrow=TRUE,nrow=2)
f <- data.frame(c(1,1,1,1),c("a","a","a","a"),c(TRUE,FALSE,TRUE,FALSE))

a_list <- list(a,b,d,e,f)
str(a_list)

a_list_with_name <- list(number = a,logical = b,vector = d, matrix = e, dataframe = f)
str(a_list_with_name)

#select elements from list
num <- a_list_with_name[[1]]
num
logic <- a_list_with_name[["logical"]]
logic <- a_list_with_name$logical
logic
number_in_vector <- a_list_with_name[["vector"]][2]
number_in_vector
object_in_dataframe <- a_list_with_name$dataframe[2,2]
object_in_dataframe

#append to list
f <- c(4,4,4)
a_list_with_name2 <- c(a_list_with_name, list(f))
a_list_with_name2
