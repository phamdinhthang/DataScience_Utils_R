library(dplyr)
library(ggplot2)
library(reshape2)

file_path = 'C:/Users/Home/Google Drive/Vietinbank_Lecture/customer_lifetime_value/Online_retail/Online_Retail.csv'
raw.data <- read.csv(file_path)
df <- raw.data

#Data inspection
dim(df)
head(df)
str(df)
summary(df)

#Count missing values
count_na <- function(df) {
  for (col_name in names(df)) {
    na_count = sum(is.na(df[[col_name]]))
    print(paste("Colname:",col_name,", na counts:",na_count))
  }
}

count_na(df)

#Remove rows with CustomerID == None, Null, Blank, NA
df <- subset(df, !is.na(df$CustomerID))
df$InvoiceDate <- as.Date(df$InvoiceDate, format = "%m/%d/%Y")
df$CustomerID <- as.factor(df$CustomerID)

#Data visualization
ggplot(data=df, aes(UnitPrice)) + 
  geom_histogram(bins=50, col="red", fill="green", alpha = .2) +
  labs(title=paste("UnitPrice histogram")) +
  labs(x="Price per unit", y="Count")

ggplot(data=df, aes(Quantity)) + 
  geom_histogram(bins=50, col="red", fill="green", alpha = .2) +
  labs(title=paste("Quantity histogram")) +
  labs(x="Quantity", y="Count")

#Box plot
ggplot(df, aes(x = "", y = Quantity)) + geom_boxplot()
ggplot(df, aes(x = "", y = UnitPrice)) + geom_boxplot()

#Get 99 percentile value
print(paste("Quantity max value:",max(df$Quantity)))
percentile = 0.99
normal_quantity_value = quantile(df$Quantity, probs = percentile)

print(paste("UnitPrice max value:",max(df$UnitPrice)))
percentile = 0.99
normal_unitprice_value = quantile(df$UnitPrice, probs = percentile)

#Filter outlier
df_filtered <- filter(df, Quantity > 0 & Quantity < normal_quantity_value & UnitPrice > 0 & UnitPrice < normal_unitprice_value)

#Data visualization after outlier remove
ggplot(data=df_filtered, aes(UnitPrice)) + 
  geom_histogram(bins=50, col="red", fill="green", alpha = .2) +
  labs(title=paste("UnitPrice histogram")) +
  labs(x="Price per unit", y="Count")

ggplot(data=df_filtered, aes(Quantity)) + 
  geom_histogram(bins=50, col="red", fill="green", alpha = .2) +
  labs(title=paste("Quantity histogram")) +
  labs(x="Quantity", y="Count")

#Plot scatter plot for correlation check
ggplot(df_filtered, aes(x=UnitPrice, y=Quantity)) + geom_point()

# Create customer-level dataset #
customers <- as.data.frame(unique(df$CustomerID))
names(customers) <- "CustomerID"

#group by Invoice and CustomerId
df$InvoiceValue <- df$Quantity*df$UnitPrice
df <- df %>% group_by(InvoiceNo, CustomerID) %>% summarize(InvoiceQuantity = sum(Quantity),
                                                           InvoiceDate = mean(InvoiceDate),
                                                           InvoiceValue = sum(InvoiceValue))

#Filter rows with Quantity<0, which is a return Invoice
df <- filter(df, InvoiceQuantity>0)

#Add Recency colums.
df$Recency <- as.Date("2011-12-31") - df$InvoiceDate
Recency <- aggregate(Recency ~ CustomerID, data=df, FUN=min, na.rm=TRUE)

#Append recency to customer
customers <- inner_join(customers, Recency, by="CustomerID")
customers$Recency <- as.numeric(customers$Recency)

#Frequency
Freq_Mone <- df %>% group_by(CustomerID) %>% summarize(Frequency = NROW(InvoiceNo),
                                                       Monetary = sum(InvoiceValue))
customers <- inner_join(customers, Freq_Mone, by="CustomerID")

output_path <- "C:/Users/admin/Google Drive/Vietinbank_Lecture/customer_lifetime_value/Online_retail/customers_RFM.csv"
write.csv(customers, output_path,row.names=FALSE)
