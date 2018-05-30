#initiate matrix
a <- matrix(c(1,2,3,4,5,6), byrow = TRUE, nrow = 2)
a

#set rowname, colname after initiate
colnames(a) <- c("A","B","C")
rownames(a) <- c("X","Y")
a

#set rowname, colname while initiate. Attention: rowname vector comes first on the list
b <- matrix(c(1,1,1,1,1,1), byrow = TRUE, nrow = 3, dimnames = list(c("A","B","C"),c("X","Y")))
b

#append row
d <- c(2,2)
b <- rbind(b,d)
b

#append colum
e <- c(3,3,3,3)
b <- cbind(b,e)
b

#append matrix
f <- matrix(c(5,5,5,5,5,5,5,5),byrow = TRUE, nrow = 4)
b <- cbind(b,f)
b

#select elements
b[3,3]
b[1,]
b[,4]
b[3:4,3:5]
b[b>2]