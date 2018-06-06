



# Logistic regression -----------------------------------------------------

library(EcoData)
library(effects)
options(na.action = "na.omit")

str(titanic)
titanic$pclass = as.factor(titanic$pclass)


# just for seeing it (not the correct distribution)
fit = lm(survived ~ age, data = titanic)
par(mfrow = c(2, 2))
plot(fit)
# lm is not correct here!

# logistic regression
fit = glm(survived ~ sex, data = titanic, family = "binomial")
# binomial includes logit link and binomial distribution

summary(fit)
# survival of women
plogis(0.98)
# survival of men
plogis(0.98 - 2.43)
plot(table(titanic$sex, titanic$survived))

# prediction
predict(fit, newdata = data.frame(sex = "male")) # default is linear predictor
predict(fit, newdata = data.frame(sex = "male"),
        type = "response") # default is linear predictor

# residual checks
# should not be done with the normal plot function
# we should use simulated quantile residuals
library(DHARMa)
res = simulateResiduals(fit)
plot(res)
# left plot normality, right plot patterns / variat



# Exercise ----------------------------------------------------------------

# extent the model with the predictors age, pclass and whatever you want
# try an interaction between scale(age) and sex (what does this assume?)
# check the residuals
# plot the predictions / allEffects()
# interpret the effects


# logistic regression
fit = glm(survived ~ sex * scale(age) + pclass:sex, 
          data = titanic, 
          family = "binomial")
summary(fit)

library(effects)
plot(allEffects(fit))

# making predictions
newPerson = data.frame(sex = c("male","male"),
                       age = c(30,30),
                       pclass = as.factor(c(1, 3)))
predict(fit, newdata = newPerson, type = "response")
# the result are two survival probabilities

plot(simulateResiduals(fit))



# Poisson regression ------------------------------------------------------

dat = EcoData::birdfeeding
str(dat)
plot(feeding ~ attractiveness, dat)

# poisson model
fit = glm(feeding ~ attractiveness, data = dat, family = "poisson")
summary(fit)

# attractiveness = 3
coef(fit)[1] + coef(fit)[2]*3 # linear part
exp(coef(fit)[1] + coef(fit)[2]*3) # response
predict(fit, newdata = data.frame(attractiveness = 3), type = "r")

plot(allEffects(fit))


# checking the residuals
library(DHARMa)
res = simulateResiduals(fit)
plot(res)

# check for overdispersion
library(AER)
dispersiontest(fit)



# Exercise ----------------------------------------------------------------

library(glmmTMB)
dat = Owls
str(dat)

# fit a model with SiblingNegotiation as a response
# possible predictors:
# BroodSize
# FoodTreatment
# SexParent
# ArrivalTime

# check the residuals
# make a test for overdispersion
# interpret the effects




