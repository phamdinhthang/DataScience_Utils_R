#install neccessary packages
#library(hflights)
#library(dplyr)

#Change label with look up table
lut <- c("AA" = "American", "AS" = "Alaska", "B6" = "JetBlue", "CO" = "Continental","DL" = "Delta", "OO" = "SkyWest", "UA" = "United", "US" = "US_Airways","WN" = "Southwest", "EV" = "Atlantic_Southeast", "F9" = "Frontier","FL" = "AirTran", "MQ" = "American_Eagle", "XE" = "ExpressJet", "YV" = "Mesa")
hflights$Carrier <- lut[hflights$UniqueCarrier]
glimpse(hflights)

#Select column from tibble
new_tbl <- select(hflights,ActualElapsedTime, AirTime, ArrDelay,DepDelay) #select by col names
new_tbl2 <- select(hflights,Origin:Cancelled) #select by col names range
new_tbl3 <- select(hflights,Origin:Cancelled,-(Dest:TaxiIn)) #select by col names range except some col
new_tbl4 <- select(hflights, c(1:4,12:21)) #select by col number
new_tbl5 <- select(hflights,contains("Time"),contains("Delay")) #select by helper function: starts_with("X"),ends_with("X"),contains("X")

#Add new colum to the tibble, based on current colums
new_tbl6 <- mutate(hflights, TotalTaxi = TaxiIn + TaxiOut, ActualGroundTime = ActualElapsedTime - AirTime, Diff = TotalTaxi - ActualGroundTime)
glimpse(new_tbl6)

#Filter tibble row by logical test
filter(hflights, UniqueCarrier %in% c("JetBlue", "Southwest", "Delta")) # All flights flown by one of JetBlue, Southwest, or Delta
filter(hflights,(TaxiOut + TaxiIn) > AirTime) # All flights where taxiing took longer than flying
filter(hflights, DepTime < 500 | ArrTime > 2200) # All flights that departed before 5am or arrived after 10pm

#Sort colum
arrange(hflights, UniqueCarrier, desc(DepDelay)) # Arrange according to carrier and decreasing departure delays
arrange(hflights, DepDelay + ArrDelay) # Arrange flights by total delay (normal order).

#Create summarise table
summarise(hflights,min_dist = min(Distance),max_dist = max(Distance)) # Print out a summary with variables min_dist and max_dist
summarise(filter(hflights,Diverted == 1), max_div = max(Distance)) # Print out a summary with variable max_div

#The pipe operator %>%: perform continuous select,mutate,filter,arrange,summarise in one line of code
hflights %>% mutate(diff = TaxiOut - TaxiIn) %>% filter(!is.na(diff)) %>% summarise(avg = mean(diff))
hflights %>% mutate(RealTime = ActualElapsedTime + 100, mph = Distance / RealTime *60) %>% filter(!is.na(mph) & mph < 70) %>% summarise(n_less = n(),n_dest = n_distinct(Dest),min_dist = min(Distance), max_dist = max(Distance))

#group_by function to group categorical colum
hflights %>% group_by(UniqueCarrier) %>% summarise(p_canc = mean(Cancelled==1)*100,avg_delay = mean(ArrDelay, na.rm = TRUE)) %>% arrange(avg_delay, p_canc)
hflights %>% filter(!is.na(ArrDelay) & ArrDelay > 0) %>% group_by(UniqueCarrier) %>% summarise(avg = mean(ArrDelay)) %>% mutate(rank = rank(avg)) %>% arrange(rank) # Ordered overview of average arrival delays per carrier
hflights %>% group_by(TailNum) %>% summarise(ndest = n_distinct(Dest)) %>% filter(ndest == 1) %>% summarise(nplanes = n()) # How many airplanes only flew to one destination?
hflights %>% group_by(UniqueCarrier, Dest) %>% summarise(n = n()) %>% mutate(rank = rank(desc(n))) %>% filter(rank == 1) # Find the most visited destination for each carrier

#Access dplyr to load data from server
my_db <- src_mysql(dbname = "dplyr", host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com", port = 3306, user = "student", password = "datacamp") # Set up a connection to the mysql database
nycflights <- tbl(my_db, "dplyr") # Reference a table within that source: nycflights
# Ordered, grouped summary of nycflight
nycflights %>% group_by(carrier) %>% summarise(n_flights = n(), avg_delay = mean(arr_delay)) %>% arrange(avg_delay)
  