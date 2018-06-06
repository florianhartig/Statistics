

# Multiple Regression -----------------------------------------------------


newAirquality = airquality[complete.cases(airquality), ]

m1 = lm(Ozone ~ Wind + Temp, data = newAirquality)
summary(m1)


library(effects)
plot(allEffects(m1, partial.residuals = T))

# check residuals
par(mfrow = c(2, 2))
plot(m1)




# scaled with interaction
m2 = lm(Ozone ~ scale(Wind) * scale(Temp), data = newAirquality)
summary(m2)
library(effects)
plot(allEffects(m2, partial.residuals = T))

# always use scale() with interactions 
# does two things
# centering - substracts the mean so that the variables are centered around zero
# scaling - devides by the standard deviation

# check residuals
par(mfrow = c(2, 2))
plot(m2)

# try transformation
m3 = lm(sqrt(Ozone) ~ scale(Wind) * scale(Temp), data = newAirquality)
summary(m3)

# check residuals
par(mfrow = c(2, 2))
plot(m3)


# Exercise ----------------------------------------------------------------

# Add a new column for the data frame with month saved a as.factor() (see help)
# add this new factor variable to the model
# add also scaled Solar.R and all two-way interactions a:b + b:c ... 
# for two way interactions you can also check the help of formula! 
# check the residuals
# interpret the summary and the model predictions
# compare the effect of Temp to the previous model

newAirquality$MonthFact = as.factor(newAirquality$Month)
m3 = lm(sqrt(Ozone) ~  (scale(Wind) + scale(Temp) + scale(Solar.R))^2 + MonthFact , data = newAirquality)
summary(m3)
library(effects)
plot(allEffects(m3, partial.residuals = T))

plot(m3)

coef(m2)
coef(m3)
