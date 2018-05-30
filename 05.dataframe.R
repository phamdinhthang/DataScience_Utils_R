#Create data frame
name <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
type <- c("Terrestrial planet", "Terrestrial planet", "Terrestrial planet", 
          "Terrestrial planet", "Gas giant", "Gas giant", "Gas giant", "Gas giant")
diameter <- c(0.382, 0.949, 1, 0.532, 11.209, 9.449, 4.007, 3.883)
rotation <- c(58.64, -243.02, 1, 1.03, 0.41, 0.43, -0.72, 0.67)
rings <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE)
data <- data.frame(name,type,diameter,rotation,rings)
colnames(data) <- c("NAME","TYPE","DIAMETER","ROTATION","RINGS")
head(data)

#Selection of dataframe
data[-2] #remove the first 2 columns
data[2,3] #get value at row 2, col 3
data[,1:3] #get all data from first 3 colums
data[,c(1,3,5)] #get all data from colum 1,3,5 only
data[1:5,c(1,3)] #get row 1 to 5 with colum 1,3
data[,c("name","diameter")] #get all row with colum name in the vector
data[c(-1,-7,-11),-2] #remove the 1st,7th,11st row and 2nd col
data[,-c(1,2)] #Remove the 1st and 2nd col
data[[1]] #first colum as a vector

#Filter dataframe by fields value
data[data$rings == TRUE,] #get only row with rings = TRUE
data[data$diameter > mean(data$diameter),] #get only row with diameter larger than average diameter
newdata <-data[data$type == "Gas giant",c("name","type","diameter")] #get only Gas giant type. Select only 3 field name, type, diameter
newdata

#subset datafram
newdata = subset(data, rotation < 0 & rings == TRUE)
newdata

#sort dataframe
by_diameter <- order(data$diameter) #create order vector
data[by_diameter,] #sort the dataframe by the order vector, keep all colums

