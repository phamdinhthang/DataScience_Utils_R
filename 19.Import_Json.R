#install neccessary packages
#library(jsonlite)

#Convert json string to list
wine_json <- '{"name":"Chateau Migraine", "year":1997, "alcohol_pct":12.4, "color":"red", "awarded":false}'
wine <- fromJSON(wine_json)
wine
json2 <- '[{"a": 1, "b": 2}, {"a": 3, "b": 4},{"a": 5, "b": 6}]'
fromJSON(json2)
json2

#download JSON from web api as list
quandl_url <- "http://www.quandl.com/api/v1/datasets/IWS/INTERNET_INDIA.json?auth_token=i83asDsiWUUyfoypkgMz"
quandl_data <- fromJSON(quandl_url)
str(quandl_data)

#Convert data frame to json
url_csv <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/water.csv"
water <- read.csv(url_csv, stringsAsFactors = FALSE)
water_json <- toJSON(water, pretty = TRUE) #the pretty parameter to view the json as structured, not in one line
print(water_json)