#library(purrr)

#Functional programing: function as argument to other function
a <- seq(from=0,to=10,by=1)
a_func <- function(x,func) {
	return(x+ func(x))
}
b <- a_func(a,sum)
b
d <- a_func(a,mean)
d


#map function and purrr package
a <- c(1,2,3,4,5)
b <- c(6,7,8,9,10)
d <- c(11,12,13,14,15)
df <- data.frame(a,b,d)
map_dbl(df,mean)
map_dbl(df,median)
map_dbl(df,sd)
plus <- function(x, increment = 1) {
	x+increment
}
map(df, plus,increment=3) #return a list of 3 vectors


#Safe funtion: safely() return list with result and error
safe_readLines <- safely(readLines())
safe_readLines("http://example.org")
safe_readLines("http://asdfasdasdkfjlda")

#map2 with two argument set
rnorm(5,mean = 1)
rnorm(10,mean =5)
rnorm(20,mean=10)

n <- list(5, 10, 20)
mu <- list(1,5,10)
map2(n, mu, rnorm)

#pmap with many argument
rnorm(5,mean = 1, sd = 0.1)
rnorm(10,mean = 5, sd = 0.5)
rnorm(20,mean = 10, sd = 0.1)

n <- list(5, 10, 20)
mu <- list(1, 5, 10)
sd <- list(0.1,1,0.1)
pmap(list(n = n, mean = mu, sd sd), rnorm) #pmap call to replace 3 function calls above


#iterate through function
f <- list("rnorm", "runif", "rexp") # Define list of functions
rnorm_params <- list(mean = 10) # Parameter list
runif_params <- list(min = 0, max = 5)
rexp_params <- list(rate = 5)
params <- list(rnorm_params,runif_params,rexp_params)
invoke_map(f, params, n = 5) # Call invoke_map() on f supplying params as the second argument

#walk funtion with side effect
f <- list(Normal = "rnorm", Uniform = "runif", Exp = "rexp") # Define list of functions
params <- list(Normal = list(mean = 10),Uniform = list(min = 0, max = 5),Exp = list(rate = 5)) # Define params
sims <- invoke_map(f, params, n = 50) # Assign the simulated samples to sims
walk(sims,hist) # Use walk() to make a histogram of each element in sims