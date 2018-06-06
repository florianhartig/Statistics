


# Simulation of p-values --------------------------------------------------

patientPerGroup = 50
pControl = 0.5
pBlood = 0.5

set.seed(123)
control = rbinom(n=1, size = patientPerGroup, prob = pControl)
blood = rbinom(n=1, size = patientPerGroup, prob = pBlood)
barplot(c(control, blood), ylim = c(0, 50), 
        names.arg = c("control", "blood"))
teststatistic = control - blood
teststatistic

testStatics = rep(NA, 10000)

for (i in 1:10000) {
  control = rbinom(n=1, size = patientPerGroup, prob = pControl)
  blood = rbinom(n=1, size = patientPerGroup, prob = pBlood)
  barplot(c(control, blood), ylim = c(0, 50), 
          names.arg = c("control", "blood"))
  testStatics[i] = control - blood
}
hist(testStatics)


# lets assume we observed something, teststatistic:
obs = 30 - 23
abline(v = obs, col = "red")

# calculate p-value
mean(testStatics > obs)



# a proper test for this
prop.test(c(30, 23), c(50, 50))
prop.test(c(30, 23), c(50, 50), alternative = "greater")




# T-test ------------------------------------------------------------------



summary(PlantGrowth)
boxplot(weight ~ group, PlantGrowth)

ctrl = PlantGrowth$weight[PlantGrowth$group == "ctrl"]
trt1 = PlantGrowth$weight[PlantGrowth$group == "trt1"]
trt2 = PlantGrowth$weight[PlantGrowth$group == "trt2"]

t.test(ctrl, trt1)
# not significant, there seems to be no difference in the means

# check for normality (important assumption of the t-test)
shapiro.test(ctrl)  # not significant, normality seems fine
shapiro.test(trt1)  # not significant, normality seems fine
shapiro.test(trt2)  # not significant, normality seems fine
# t.test result should be fine

# Exercise
# make a test for each combination
# save each test as a new object (test1, test2 and test3)

(test1 = t.test(ctrl, trt1))
(test2 = t.test(ctrl, trt2))
(test3 = t.test(trt1, trt2))


# correct for multiple testing
round(c(test1$p.value, test2$p.value, test3$p.value), digits = 4)
round(p.adjust(c(test1$p.value, test2$p.value, test3$p.value),
         n = 3), digits = 4)




# Power analysis ----------------------------------------------------------

# get power
power.t.test(n = 10, delta = 1, sd = 1, type = "one.sample")
power.t.test(n = 10, delta = 0.5, sd = 1, type = "one.sample")

# get n
power.t.test(power = 0.9, delta = 1, sd = 1, type = "one.sample")

# Exercise
# increase/decrease effect size
# increase/decrease variability
# increase/decrease power

pow <- function(n) power.t.test(n, delta = 1, 
                                sd = 1, type = "one.sample")$power
samples = 1:20
power = sapply(X = samples, FUN = pow)
plot(samples, power)


