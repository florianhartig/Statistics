


# Linear mixed models -----------------------------------------------------

library(lme4)
str(sleepstudy)


# linear model
fit1 = lm(Reaction ~ Days, data = sleepstudy)
summary(fit1)
plot(Reaction ~ Days, data = sleepstudy)

# random effect to account for differences between the persons
fit2 = lmer(Reaction ~ Days + (1 | Subject), data = sleepstudy) # random intercept
summary(fit2)


#check out this:
# http://mfviz.com/hierarchical-models/


# random effect to account for differences in the effect of Days
fit3 = lmer(Reaction ~ Days + (Days | Subject), data = sleepstudy) # random slope
summary(fit3)


 

# Machine learning --------------------------------------------------------

# for comparison, we use a linear model
ozone.lm = lm(Ozone ~ ., data = airquality, na.action = "na.omit")
summary(ozone.lm)
# lm explains 60 % of the variance

library(randomForest)
ozone.rf = randomForest(Ozone ~ ., data = airquality, mtry = 3, 
                        importance = T, na.action = na.omit, keep.inbag = T)
print(ozone.rf)
# more than 70 % are explained with a random forest



# randomForest for a classification
model = randomForest(Species ~ ., data = iris, importance = T, ntree = 500,
                     mtry = 2, keep.inbag = T)

print(model)

library(forestFloor)
ff = forestFloor(model, iris[, -5])
show3d(ff)


# for the visualization of a condition inferenc tree!
install.packages("party")
library(party)
out.tree <- ctree(Species ~., data = iris)
plot(out.tree)
