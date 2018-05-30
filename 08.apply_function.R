#lapply with custom function
double <- function(x) {
	return(2*x)
}
mult <- function(x,factor = 3) {
	return(factor*x)
}
a <- c(1,2,3,4,5,6,7,8,9)
b <- unlist(lapply(a,double))
b
d <- unlist(lapply(a,mult))
d
e <- unlist(lapply(a,mult,factor = 4))
e

#lapply with anonymous func
f <- unlist(lapply(a, function(x,factor=1) {return(x/factor)},factor =2))
f


#sapply is lapply automatic unlist if possible
create_linear <- function(x, factor = 1) {
	return(c(x,factor*x))
}

a <- c(1,2,3,4)
b <- sapply(a,create_linear,factor=2)
b

#vapply is sapply with defined output so unlist is always possible. Attention: should always use vapply over sapply
b <- vapply(a,FUN = create_linear, FUN.VALUE = numeric(2),factor = 2)
b