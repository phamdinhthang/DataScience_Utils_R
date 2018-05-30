#install neccessary packages
#library(haven)
#library(foreign)

#Import sas
sales <- read_sas("sales.sas7bdat")
str(sales)

#import STATA with labelled conversion
sugar <- read_dta("http://assets.datacamp.com/production/course_1478/datasets/trade.dta")
sugar$Date <- as.Date(as_factor(sugar$Date))
str(sugar)

#import SPSS
work <- read_sav("http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/employee.sav")
work$GENDER <- as_factor(work$GENDER)
head(work)

#Using foreign package
edu_equal_3 <- read.dta("international.dta", convert.underscore = TRUE)
demo <- read.spss("international.sav", to.data.frame = TRUE)
demo_2 <- read.spss("international.sav", to.data.frame = TRUE,use.value.labels = FALSE)