#Modulo function
a <- 5%%2
a

#Check class of variable
b <- TRUE
class(b)

#Vector and field names
d <- c(1,2,3,4,5,6,7,8,9,10)
names(d) <- c("A","B","C","D","E","F","G","H","I","J")
d

#Sum of 2 vector: can only sum 2 numeric
f <- c(1,2,3) + c(4,5,6)
f

#Compare vector: result is a logical vector
c(3,5,6) > c(2,7,6)

#Select elements from vector
d[5]
d[c(1,2,10)]
d[2:5]
d[d>5]

#if the logical vector length is less than vector length, the logical vector length will be repeated
d[c(TRUE,TRUE,FALSE)]

#sort vector
e <- c(9,5,87,3,6,3,7,3,2,7)
f <- e
order(e)
e[order(e)]
sort(f, decreasing = FALSE)
f


#append to vector
d <- append(c(1,2,3),4)
d



