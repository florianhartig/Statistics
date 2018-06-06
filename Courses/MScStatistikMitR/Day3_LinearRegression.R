
# Simple linear regression ------------------------------------------------

# simple: one explanatory variable
# linear: y = a + b*x
# also linear:  y = a + b*x + c*x^2

pairs(airquality)
plot(Ozone ~ Temp, data = airquality)

# normal linear regression
fit1 = lm(Ozone ~ Temp, data = airquality)
summary(fit1)

# omitting the intercept
fit2 = lm(Ozone ~ Temp - 1, data = airquality)
summary(fit2)

plot(Ozone ~ Temp, data = airquality, 
     xlim=c(0, 100), ylim = c(-150, 150))
abline(fit1, col = "red")
abline(fit2, col = "blue", lty = 3)


# we have to check the residuals
# check model assumptions!
hist(residuals(fit1))
shapiro.test(residuals(fit1))

oldpar = par(mfrow = c(2, 2))
plot(fit1)
par(oldpar)


# additional quadratic term 
fit3 = lm(Ozone ~ Temp + I(Temp^2), data = airquality)
summary(fit3)

# again check residuals
oldpar = par(mfrow = c(2, 2))
plot(fit3)
par(oldpar)
# residuals are still not normally distributed, but we leave this for now



# predict values
new = data.frame(Temp = 55:100)
pred = predict(fit3, newdata = new, se.fit = T)
plot(Ozone ~ Temp, data = airquality)
lines(new$Temp, pred$fit, col = "red")
lines(new$Temp, pred$fit + 1.96 * pred$se.fit, col = "red", lty= 2)
lines(new$Temp, pred$fit - 1.96 * pred$se.fit, col = "red", lty= 2)

# add a polygon for shading
x = c(new$Temp, rev(new$Temp))
y = c(pred$fit - 1.96*pred$se.fit,
      rev(pred$fit + 1.96*pred$se.fit))
polygon(x, y, col = "#99009922", border = F)


install.packages("effects")
library(effects)
plot(allEffects(fit3, partial.residuals = T))



# Categorial predictor ----------------------------------------------------


plot(weight ~ feed, data = chickwts)

fit4 = lm(weight ~ feed, data = chickwts)
summary(fit4)

# anova for overall effect
summary(aov(fit4))

plot(allEffects(fit4))



# Exercise  ---------------------------------------------------------------

# make a model for Ozone ~ Wind airquality
# plot data
# fit model
# model diagnostics
# plot fit

plot(Ozone ~ Wind, data = airquality)

# normal linear regression
fit = lm(Ozone ~ Wind + I(Wind^2), data = airquality)
summary(fit)

# again check residuals
oldpar = par(mfrow = c(2, 2))
plot(fit)
par(oldpar)
# residuals are still not normally distributed, but we leave this for now

plot(allEffects(fit, partial.residuals = T))

