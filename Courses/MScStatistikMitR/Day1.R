

# Learning R --------------------------------------------------------------




# R is like a normal calculator
2+2
sqrt(2)
?sqrt

sqrt(-1)

variable1 = 1.4
variable2 = "dog"

# does the same = / <- "assignment operator"
variable2 <- "dog"

class(variable1)
class(variable2)

# Atomic types

# 1. logical
v1 <- TRUE
class(v1)
# or shorter
v1 <- T
# opposite is FALSE or F

# 2. numeric / subtype integer
v2 <- 4.5
class(v2)

# 3. character
v3 <- "lion"
class(v3)

# 4. factor
v4 <- factor("dog")
class(v4)
v4



# Data structures ---------------------------------------------------------

# vector
vec1 <- c(1, 3, 4, 5, 6)
vec1
class(vec1)

# getting specific values
vec1[1]  # first value in the vector
vec1[1:2] # first and second value
vec1[c(1, 4)] # value 1 and 4 in the vector

# 1 becomes a character aswell
# each element in a vector has the same class
testVector = c(1, "dog")
testVector


# removing variables
va = 1
rm(va)

# list (flexible)
list1 = list(1, "dog")

# access elements in a list
list1[[1]] # first element

# data.frame
# most important data type in R
# technically it is a list of vectors

vec2 = c("dog", "cat", "mouse")
vec3 = c(T, T, F)

mydata = data.frame(vec2, vec3)
View(mydata)

mydata = data.frame("animal" = vec2, "sleep" = vec3)
View(mydata)
str(mydata)

# access data in a data.frame
mydata$sleep # column with a name
mydata[, 1] # all rows, first column
mydata[1, ] # first row, all columns
mydata[1:2, 2] #  first and second row, second column
mydata[c(1, 3), ] # first and third row, all columns


# Small exercise ----------------------------------------------------------

# internal datasets 
dat = airquality

# task:
# try out plot and View 
# get the class of each column
# get only the second row of the dataset
# get column ozone
# NEW: add up column 3 and 4, what happens here???


# Solutions:
View(dat)
plot(dat)
str(dat)
dat[2, ]
dat$Ozone # or
dat[, 1]  # or
dat[, "Ozone"]
dat$sum = dat[, 3] + dat[, 4]
View(dat)


# information on the data.frame
head(dat) # check if it worked
tail(dat) # last six rows

summary(dat) # data stored


# subsetting
queryWind = dat$Wind > 10 # wind speeds larger 10

dat2 = dat[queryWind, ] # data frame with wind speeds larger 10 only
View(dat2)

dat3 = dat[dat$Month == 9, ] # data frame with month equal 9

# query for columns with NA!!! exclude NAs with !is.na()
dat4 = dat[dat$Ozone > 50 & !is.na(dat$Ozone), ]


# Excercise for queries ---------------------------------------------------

# filter all observations with Temp larger 60 in month 5
# as a new data.frame
dat[dat$Temp > 60 & dat$Month == 5, ]




# Working directory -----------------------------------------------------------------

getwd()




# Summary statistics ------------------------------------------------------

# numerical variable - univariate
mean(airquality$Temp)
min(airquality$Temp)
var(airquality$Temp)
sd(airquality$Temp)
quantile(airquality$Temp)

# with NA values
mean(airquality$Ozone)
mean(x = airquality$Ozone, na.rm = T)

# histogram
hist(airquality$Temp)
hist(airquality$Temp, main = "temperature", 
     xlab = "T")

# change the color
# change the width of the bars

hist(airquality$Temp, main = "temperature", 
     xlab = "T", col = "blue")

hist(airquality$Temp, main = "temperature", 
     xlab = "T", col = "#FF00FF")

hist(airquality$Temp, main = "temperature", 
     xlab = "T", col = "#FF00FF",
     breaks = 20)

pdf("figures/histogram.pdf")
hist(airquality$Temp, main = "temperature", 
     xlab = "T", col = "#000020",
     breaks = 20)
dev.off()

summary(airquality)



# Categorial data ---------------------------------------------------------

str(mtcars)

count = table(mtcars$cyl)
plot(count)
barplot(count) # the same
barplot(table(mtcars$cyl))

# Change color
# change title
# save it as pdf


count <- table(cyl = mtcars$cyl, gear = mtcars$gear)
count <- table(gear = mtcars$gear, cyl = mtcars$cyl)
count
plot(count)



# Correlation -------------------------------------------------------------

str(airquality)

# two ways of plotting "scatterplots"
plot(airquality$Solar.R, airquality$Ozone) 
plot(Ozone ~ Solar.R, data = airquality)

plot(Ozone ~ Solar.R, data = airquality, 
     col = airquality$Month-3, pch = 16)
legend("topleft", col = unique(airquality$Month-3),
       legend = unique(airquality$Month), pch = 16)

plot(Ozone ~ Solar.R, data = airquality, 
     col = airquality$Month-3, pch = 16, 
     cex = airquality$Wind/6)

# calculate the correlation
cor(airquality$Solar.R, airquality$Ozone, 
    use = "complete.obs") # get non NA result
cor(airquality$Solar.R, airquality$Ozone, 
    method = "spearman",
    use = "complete.obs") # get non NA result
cor(airquality$Solar.R, airquality$Ozone, 
    method = "kendall",
    use = "complete.obs") # get non NA result

# plot all variable combinations
plot(airquality) # the same
pairs(airquality)

# extra function from example of pairs
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...) {
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y, use = "complete.obs"))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
pairs(airquality, lower.panel = panel.smooth, upper.panel = panel.cor)


# Exercise to explore the methods we learned ------------------------------

# try out all the methods we learned:
# data types, summaries, plots, tables, generate pdfs and so on
# We use the dataset birdabundances that you should get like this:
bird = EcoData::birdabundance
# if this doesnt work, ASK ME

# We continue at 3:50 pm



# Data in R - what I forgot to show you -----------------------------------

# write a csv file 
write.csv(airquality, file = "data/air.txt")


airdata2 = read.csv(file = "data/air.txt")

# clean data (more steps normally required)
cleanairdata = airdata2[-2, ] # take out second row

# save the cleaned data 
save(cleanairdata, file = "data/cleanedData.Rdata")
rm(cleanairdata)
load(file = "data/cleanedData.Rdata")

library(rgbif)

# get data for puma
name = name_backbone(name = "Puma concolor")
dat = occ_search(taxonKey = name$speciesKey, return = "data")
install.packages("maps")
gbifmap(dat)



