#Date and time format
#%Y: year 4 digit
#%y: year 2 digit
#%m: month number
#%B: month fullname
#%b: month short name
#%d: day of month
#%A: day of week
#%a: day of week short
#%H: hour in 24h
#%h: hour in 12h
#%M: minute
#%S: second
#%p: AM/PM

#Get current date and time
date <- Sys.Date()
date
time <- Sys.time()
time
time
#Date from string
a <- "2017/05/19"
b <- "Thu, Jun 1, 17"
date_a <- as.Date(a, format = "%Y/%m/%d")
date_a
date_b <- as.Date(b, format = "%a, %b %d, %y")
date_b

#String from date
date_a_string <- format(date_a,"Today is %d-%m-%Y")
date_a_string
date_b_string <- format(date_b,"Today is %A, %d-%B, %y")
date_b_string

#POSIXct time from string
a <- "2017/05/19 22:30:21"
b <- "11:30:20 AM 01/06/2017"
time_a <- as.POSIXct(a, format = "%Y/%m/%d %H:%M:%S")
time_a
time_b <- as.POSIXct(b, format = "%h:%M:%S %p %d/%m/%Y")
time_b
#string from POSIXct time
time_a_string <- format(time_a,"Rite now is %h:%M:%S %p %d-%m-%Y")
time_a_string
