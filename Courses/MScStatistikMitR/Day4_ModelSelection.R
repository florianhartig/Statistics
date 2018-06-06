


# Model selection ---------------------------------------------------------

library(MASS)

newAirquality = airquality[complete.cases(airquality), ]
str(newAirquality)

newAirquality$MonthFact = as.factor(newAirquality$Month)
newAirquality$DayFact = as.factor(newAirquality$Day)

# full model 
fullModel = lm(Ozone ~ Temp + I(Temp^2) + Solar.R + I(Solar.R^2) 
               + Wind + I(Wind^2) + MonthFact + DayFact, 
               data = newAirquality)
summary(fullModel)

# stepwise model selection
reduced = stepAIC(fullModel, k = 2)
summary(reduced)


# global model selection
library(MuMIn)
options(na.action= "na.fail")
ms1 = dredge(fullModel)

# Visualize
par(mar = c(3, 5, 6, 4))
plot(ms1, labAsExpr = T)

# model subsetting
subset(ms1, subset = delta < 2)

# model averaging
model.avg(ms1, subset = delta < 2)



# Exercise ----------------------------------------------------------------

dat = Cement
# make a full model for the Cement dataset
# make a model selection using stepAIC
# make a global model selection using MuMIn
# compare the results

m = lm(y ~ X1 + X2 + X3 + X4, Cement)
summary(m)

red = stepAIC(m)
summary(red)


redglobal = dredge(m, rank = "AICc")
redglobal




