#optional parameter
a <- c(1,2,3,4,5,6,7,8)
mean(a)

b <- c(1,2,3,3,NA)
mean(b,na.rm = TRUE)

#define new function
mult <- function(x,factor = 3) {
	return(x*factor)
}
d <- mult(5)
d
e <- mult(5,factor = 6)
e