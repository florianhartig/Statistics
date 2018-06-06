

# Airquality --------------------------------------------------------------

dat = airquality

# Ozone normally distributed? H0: data is normally distributed
shapiro.test(dat$Ozone) # p-value is significant, H0 is rejected
hist(dat$Ozone)

# Solar.R uniformly distributed? 
ks.test(jitter(dat$Solar.R), "punif") # jitter puts some noise
# p-value is significant, reject H0
hist(dat$Solar.R, breaks = 30)

# correlation between Solar.R and Ozone significant?
plot(Solar.R ~ Ozone, dat)
cor.test(dat$Solar.R, dat$Ozone)
# H0: correlation is = 0
# p-value significant
# reject H0, is correlated




# Chicken -----------------------------------------------------------------

dat = chickwts
summary(dat)

# plot
boxplot(weight ~ feed, data = dat, notch = F)

# can we apply an Anova?
x = dat$weight[dat$feed == "casein"]
y = dat$weight[dat$feed == "horsebean"]
shapiro.test(x) # H0 normally distributed, not significant
shapiro.test(y)
# normal distribution is okay

# equal variance?
var.test(x, y)
# H0: equal variance, can not be rejected
# equal variances seems to be okay

# ANOVA (parametric)
fit = aov(weight ~ feed, data = dat)
summary(fit)
# H0: equal means in all groups
# can be rejected, feed has an influence on weight

# non-parametric alternative
kruskal.test(weight ~ feed, data = dat)
# also significant, but the p-value is a higher

TukeyHSD(fit)



# Titanic  ----------------------------------------------------------------

install.packages("devtools")
library(devtools)
devtools::install_github(repo = "TheoreticalEcology/EcoData", subdir = "EcoData", dependencies = T, build_vignettes = T)
library(EcoData)

dat = titanic
summary(dat)
# Titanic

# different ways of subsetting
dat12 = dat[dat$pclass == 1 | dat$pclass == 2, ]
dat12 = dat[dat$pclass != 3, ] # the same
dat12 = dat[dat$pclass %in% 1:2, ] # the same

#
tab = table(class = dat12$pclass, survived = dat12$survived)
prop.test(tab)
# survival differs between the two groups

tab = table(class = dat$pclass, survived = dat$survived)
prop.test(tab)



# Streams -----------------------------------------------------------------

dat = read.table("https://raw.githubusercontent.com/biometry/APES/master/Data/Simone/streams.txt", header = T)

# does the filter influence the water quality
shapiro.test(dat$down) # significant, not normally distributed
shapiro.test(dat$up)   # normal distributed

# non-parametric test
wilcox.test(dat$down, dat$up, paired = T)
t.test(dat$down, dat$up, paired = T) # only for comparison (shouldn't be used in this case)





# Simulation of Type I and II error ---------------------------------------


patientsPerGroup = 50
pK = 0.5
pB = 0.5

pWerte = rep(NA, 1000)
for(i in 1:1000){
  kontrolle = rbinom(1, patientsPerGroup, prob = pK )
  behandlung = rbinom(1, patientsPerGroup, prob = pB )
  
  # pWerte[i] = prop.test(c(kontrolle, behandlung), 
  #                       c(patientsPerGroup, patientsPerGroup))$p.value
  
  # check larger or smaller /  first against second!
  checkLarger = kontrolle > behandlung
  Larger = ifelse(checkLarger, "greater", "less")
  
  pWerte[i] = prop.test(c(kontrolle, behandlung),
                        c(patientsPerGroup, patientsPerGroup),
                        alternative = Larger)$p.value
  
}
hist(pWerte, xlim = c(0, 1))
table(pWerte < 0.05)
# sum(pWerte < 0.05)/1000


