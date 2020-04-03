---
title: "Variation Partitioning"
author: "Florian Hartig"
date: "4/3/2020"
abstract: Analysis of Variance, Variance partitioning, Communality Analysis, Variance component analysis – what’s the difference.
output: 
  html_document: 
    keep_md: yes
---




# The problem

We have a regression of the form: 

Y ~ x1 + x2

We want to know how important x1 and x2 for explaining the signal in y. By important, we mean (in principle R2), i.e. the reduction in R2. Let's look at this example that all of you probably know


```r
m = lm(Ozone ~ Wind + Temp , data = airquality)
summary(m)
```

```
## 
## Call:
## lm(formula = Ozone ~ Wind + Temp, data = airquality)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -41.251 -13.695  -2.856  11.390 100.367 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -71.0332    23.5780  -3.013   0.0032 ** 
## Wind         -3.0555     0.6633  -4.607 1.08e-05 ***
## Temp          1.8402     0.2500   7.362 3.15e-11 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 21.85 on 113 degrees of freedom
##   (37 observations deleted due to missingness)
## Multiple R-squared:  0.5687,	Adjusted R-squared:  0.5611 
## F-statistic:  74.5 on 2 and 113 DF,  p-value: < 2.2e-16
```

Note that we can read off the R2 in the regression table (+ adjusted R2, more on that later). The standard ANOVA (type I) is doing this by adding one variable after the other, and measuring how much the explained R2 is being reduced


```r
anova(m)
```

```
## Analysis of Variance Table
## 
## Response: Ozone
##            Df Sum Sq Mean Sq F value    Pr(>F)    
## Wind        1  45284   45284  94.808 < 2.2e-16 ***
## Temp        1  25886   25886  54.196 3.149e-11 ***
## Residuals 113  53973     478                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

## Anova vs. other option to partition variance 

For numeric predictors ANOVA will be similar to effect sizes with scaled predictors IF predictors are balanced and uniformly distributed


```r
m = lm(Ozone ~ scale(Wind) + scale(Temp) , data = airquality)
summary(m)
```

```
## 
## Call:
## lm(formula = Ozone ~ scale(Wind) + scale(Temp), data = airquality)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -41.251 -13.695  -2.856  11.390 100.367 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   41.859      2.030  20.618  < 2e-16 ***
## scale(Wind)  -10.764      2.337  -4.607 1.08e-05 ***
## scale(Temp)   17.418      2.366   7.362 3.15e-11 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 21.85 on 113 degrees of freedom
##   (37 observations deleted due to missingness)
## Multiple R-squared:  0.5687,	Adjusted R-squared:  0.5611 
## F-statistic:  74.5 on 2 and 113 DF,  p-value: < 2.2e-16
```

For categorical predictors, ANOVA will be similar to random effect variances IF data is balanced 



```r
m = lm(Ozone ~ as.factor(Month) + as.factor(Day) , data = airquality)
anova(m)
```

```
## Analysis of Variance Table
## 
## Response: Ozone
##                  Df Sum Sq Mean Sq F value    Pr(>F)    
## as.factor(Month)  4  29438  7359.5  9.9897 1.272e-06 ***
## as.factor(Day)   30  36032  1201.1  1.6303   0.04357 *  
## Residuals        81  59673   736.7                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
library(lme4)
```

```
## Loading required package: Matrix
```

```r
m = lmer(Ozone ~ (1|Month) + (1|Day) , data = airquality)
summary(m)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Ozone ~ (1 | Month) + (1 | Day)
##    Data: airquality
## 
## REML criterion at convergence: 1113.2
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -1.8025 -0.6219 -0.1892  0.4373  3.4521 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  Day      (Intercept) 136.1    11.67   
##  Month    (Intercept) 257.6    16.05   
##  Residual             728.0    26.98   
## Number of obs: 116, groups:  Day, 31; Month, 5
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   41.353      7.976   5.185
```

To use the random effects like this is called **variance component analysis**, see 

* Designs for Variance Components Estimation: Past and Present https://sci-hub.tw/https://doi.org/10.1111/j.1751-5823.2000.tb00333.x
* Analysis of variance (ANOVA) and estimation of variance components http://www.fao.org/3/y4391e/y4391e07.htm
* R-Package VCA for Variance Component Analysis

From the Vignette of the VCA package: 

VCA are a way to assess how the variability of a dependent variable is structured taking into account its association with one or multiple random-effects variables. Proportions of the total variability found to be attributed to these random effects variables are called variance components (VC). Thus, VCA is the procedure of estimating the amount of the VCs’ contribution to the total variability in the dependent variable. Moreover, there are methods provided for estimating confidence intervals (CI) of VCs along with different graphical tools to better understand the data and for detecting outliers. Also included, but usually of less importance in the field of VCA: Estimation of fixed effects and least square means (LS means) as well as testing linear hypotheses of fixed effects/LS means of linear mixed models (LMMs).

## Shared components and interactions

Problem in the standard anova: if we turn the order of variables around, we get another result, because there is collinearity in the variables  


```r
m = lm(Ozone ~ Temp + Wind , data = airquality)
anova(m)
```

```
## Analysis of Variance Table
## 
## Response: Ozone
##            Df Sum Sq Mean Sq F value    Pr(>F)    
## Temp        1  61033   61033 127.781 < 2.2e-16 ***
## Wind        1  10137   10137  21.223  1.08e-05 ***
## Residuals 113  53973     478                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Commonality analysis

To calculate the differences is known as Commonality Analysis

* Ray‐Mukherjee, Jayanti, Kim Nimon, Shomen Mukherjee, Douglas W. Morris, Rob Slotow, and Michelle Hamer. 2014. “Using Commonality Analysis in Multiple Regressions: A Tool to Decompose Regression Effects in the Face of Multicollinearity.” Methods in Ecology and Evolution 5 (4): 320–28. https://doi.org/10.1111/2041-210X.12166.

* Seibold, David R., and Robert D. McPhee. 1979. “Commonality Analysis: A Method for Decomposing Explained Variance in Multiple Regression Analyses.” Human Communication Research 5 (4): 355–65. https://doi.org/10.1111/j.1468-2958.1979.tb00649.x.



```r
m = lm(Ozone ~ scale(Temp) + scale(Wind) + scale(Solar.R) , data = airquality)
summary(m)
```

```
## 
## Call:
## lm(formula = Ozone ~ scale(Temp) + scale(Wind) + scale(Solar.R), 
##     data = airquality)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -40.485 -14.219  -3.551  10.097  95.619 
## 
## Coefficients:
##                Estimate Std. Error t value Pr(>|t|)    
## (Intercept)      42.255      2.011  21.015  < 2e-16 ***
## scale(Temp)      15.638      2.400   6.516 2.42e-09 ***
## scale(Wind)     -11.744      2.305  -5.094 1.52e-06 ***
## scale(Solar.R)    5.387      2.088   2.580   0.0112 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 21.18 on 107 degrees of freedom
##   (42 observations deleted due to missingness)
## Multiple R-squared:  0.6059,	Adjusted R-squared:  0.5948 
## F-statistic: 54.83 on 3 and 107 DF,  p-value: < 2.2e-16
```




```r
library(yhat)

## All-possible-subsets regression
apsOut=aps(airquality,"Ozone",list("Temp", "Wind","Solar.R"))

## Commonality analysis
x = commonality(apsOut)
x
```

```
##                    Coefficient      % Total
## Temp               0.156401005  0.258132363
## Wind               0.095577862  0.157746680
## Solar.R            0.024516636  0.040463532
## Temp,Wind          0.232573798  0.383851908
## Temp,Solar.R       0.049824903  0.082233615
## Wind,Solar.R      -0.002159998 -0.003564974
## Temp,Wind,Solar.R  0.049160394  0.081136875
```

Note the negative shared components. Happens sometimes, always a point of discussoin. 

It's also common to visualize this via Venn diagrams. Note I had to change the negative values so that it's possible to draw this



```r
# note - I'not correctly calculating the shared components here, need to corret this
library(VennDiagram)
```

```
## Loading required package: grid
```

```
## Loading required package: futile.logger
```

```r
venn.plot <- draw.triple.venn(sum(x[c(1,4,5,7),2]), 
                                sum(x[c(2,4,6,7),2]), 
                                sum(x[c(3,4,6,7),2]), 
                                x[4,2], 0.01, x[5,2], 0.00001,
                                c("Temp", "Wind", "Solar.R"), fill = c("red", "blue", "yellow"), cat.cex = 1.5, cat.dist = 0.05);
```

![](VP_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

```r
grid.newpage();
grid.draw(venn.plot);
```

![](VP_files/figure-html/unnamed-chunk-8-2.png)<!-- -->

This is identical to what is done in variation partitioning in community analysis, only that here the model is different - we are not using a simple regression, but somethingl like an RDA, see 

* https://mb3is.megx.net/gustame/constrained-analyses/variation-partitioning
* https://academic.oup.com/jpe/article/1/1/3/1130269 (Legendre, looks good)
* https://sci-hub.tw/10.1658/1100-9233(2003)014[0693:ptviap]2.0.co;2


### Type I, II, III Anova

Type I, II, III Anova is basically about how to distribute the shared components. 

Type I SS is sequential, main effects first:
SS(A)
SS(B|A)
SS(A*B|A,B)

Type II SS is conditional on main effects, and sequential for interactions - note that SS don't add up to 1:
SS(A|B)
SS(B|A)
SS(A*B|A,B)

Type III SS is conditional on main effects and interactions:
SS(A|B,A*B)
SS(B|A,A*B)
SS(A*B|A,B)

Thus, type III SS tell you how much of the residual variability in Y can be accounted for by A after having accounted for everything else, and how much of the residual variability in Y can be accounted for by B after having accounted for everything else as well, and so on. (Note that both go both first and last simultaneously; if this makes sense to you, and accurately reflects your research question, then use type III SS.)

Hector, Andy, Stefanie Von Felten, and Bernhard Schmid. 2010. “Analysis of Variance with Unbalanced Data: An Update for Ecology & Evolution.” Journal of Animal Ecology 79 (2): 308–16. https://doi.org/10.1111/j.1365-2656.2009.01634.x.



```r
m = lm(Ozone ~ Wind * Temp , data = airquality)
summary(m)
```

```
## 
## Call:
## lm(formula = Ozone ~ Wind * Temp, data = airquality)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -39.906 -13.048  -2.263   8.726  99.306 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -248.51530   48.14038  -5.162 1.07e-06 ***
## Wind          14.33503    4.23874   3.382 0.000992 ***
## Temp           4.07575    0.58754   6.937 2.73e-10 ***
## Wind:Temp     -0.22391    0.05399  -4.147 6.57e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 20.44 on 112 degrees of freedom
##   (37 observations deleted due to missingness)
## Multiple R-squared:  0.6261,	Adjusted R-squared:  0.6161 
## F-statistic: 62.52 on 3 and 112 DF,  p-value: < 2.2e-16
```

```r
anova(m)
```

```
## Analysis of Variance Table
## 
## Response: Ozone
##            Df Sum Sq Mean Sq F value    Pr(>F)    
## Wind        1  45284   45284 108.401 < 2.2e-16 ***
## Temp        1  25886   25886  61.966 2.421e-12 ***
## Wind:Temp   1   7186    7186  17.201 6.569e-05 ***
## Residuals 112  46787     418                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
library(car)
```

```
## Loading required package: carData
```

```
## Registered S3 methods overwritten by 'car':
##   method                          from
##   influence.merMod                lme4
##   cooks.distance.influence.merMod lme4
##   dfbeta.influence.merMod         lme4
##   dfbetas.influence.merMod        lme4
```

```
## 
## Attaching package: 'car'
```

```
## The following object is masked from 'package:VennDiagram':
## 
##     ellipse
```

```r
Anova(m, type = 2)
```

```
## Anova Table (Type II tests)
## 
## Response: Ozone
##           Sum Sq  Df F value    Pr(>F)    
## Wind       10137   1  24.266 2.921e-06 ***
## Temp       25886   1  61.966 2.421e-12 ***
## Wind:Temp   7186   1  17.201 6.569e-05 ***
## Residuals  46787 112                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
Anova(m, type = 3)
```

```
## Anova Table (Type III tests)
## 
## Response: Ozone
##             Sum Sq  Df F value    Pr(>F)    
## (Intercept)  11133   1  26.649 1.068e-06 ***
## Wind          4778   1  11.437 0.0009921 ***
## Temp         20103   1  48.122 2.728e-10 ***
## Wind:Temp     7186   1  17.201 6.569e-05 ***
## Residuals    46787 112                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


## Adjusting for complexity 

One issue that has been discussed on the VP literature is how to adjust for complexity. The basic question is - should we use raw or adjusted R2 for the VP, see Pedro’s paper https://doi.org/10.1890/0012-9658(2006)87[2614:VPOSDM]2.0.CO;2

There are various discussions about whether VP works in practice, although it's often a bit dubious what exatly the problem is  https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/j.1365-2664.2010.01861.x

# Simulations 


```r
# Balanced design 

n = 100
f2 = runif(10)
f1 = runif(10)
x1 = sample.int(10, n, prob = rep(1,10), replace = T)
x2 = sample.int(10, n, prob = rep(1,10), replace = T)
e1 = 1
e2 = 1

y = rnorm(n, mean = e1 *f1[x1] + e2 * f2[x2], sd = 0.3)
dat = data.frame(y = y, x1 = factor(x1), x2 = factor(x2))

m1 = lm(y ~ x1 + x2, data = dat)
# sequential
anova(m1)
```

```
## Analysis of Variance Table
## 
## Response: y
##           Df  Sum Sq Mean Sq F value    Pr(>F)    
## x1         9 10.9553 1.21726  17.241 1.589e-15 ***
## x2         9  8.8332 0.98146  13.901 3.019e-13 ***
## Residuals 81  5.7187 0.07060                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
# type II/III
library(car)
anova(m1) # type 1
```

```
## Analysis of Variance Table
## 
## Response: y
##           Df  Sum Sq Mean Sq F value    Pr(>F)    
## x1         9 10.9553 1.21726  17.241 1.589e-15 ***
## x2         9  8.8332 0.98146  13.901 3.019e-13 ***
## Residuals 81  5.7187 0.07060                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
Anova(m1, type = "II") # there is no difference, because there is no collinearity
```

```
## Anova Table (Type II tests)
## 
## Response: y
##            Sum Sq Df F value    Pr(>F)    
## x1        10.2517  9  16.134 8.422e-15 ***
## x2         8.8332  9  13.901 3.019e-13 ***
## Residuals  5.7187 81                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
Anova(m1, type = "III")
```

```
## Anova Table (Type III tests)
## 
## Response: y
##              Sum Sq Df F value    Pr(>F)    
## (Intercept)  5.9615  1  84.438 3.361e-14 ***
## x1          10.2517  9  16.134 8.422e-15 ***
## x2           8.8332  9  13.901 3.019e-13 ***
## Residuals    5.7187 81                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
library(lme4)
m1 = lmer(y ~ (1|x1) + (1|x2), data = dat)
summary(m1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: y ~ (1 | x1) + (1 | x2)
##    Data: dat
## 
## REML criterion at convergence: 73.8
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -2.11093 -0.56923  0.01511  0.62018  2.07766 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  x1       (Intercept) 0.13434  0.3665  
##  x2       (Intercept) 0.10898  0.3301  
##  Residual             0.07082  0.2661  
## Number of obs: 100, groups:  x1, 10; x2, 10
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   0.9388     0.1588   5.911
```

```r
# note that we have to compare variance to conform to ANOVA

#analogy for varpart 
library(vegan)
```

```
## Loading required package: permute
```

```
## Loading required package: lattice
```

```
## Registered S3 methods overwritten by 'vegan':
##   method            from 
##   plot.cca          yacca
##   print.cca         yacca
##   print.summary.cca yacca
##   summary.cca       yacca
```

```
## This is vegan 2.5-6
```

```r
?varpart


# Unbalanced design 

n = 10000

f2 = runif(10)
f1 = runif(10)

x1 = sample.int(10, n, prob = c(10, rep(0.1,9)), replace = T)
x2 = sample.int(10, n, prob = rep(1,10), replace = T)

e1 = 1
e2 = 1

y = rnorm(n, mean = e1 *f1[x1] + e2 * f2[x2], sd = 0.3)

dat = data.frame(y = y, x1 = factor(x1), x2 = factor(x2))

m1 = lm(y ~ x1 + x2, data = dat)
summary(m1)
```

```
## 
## Call:
## lm(formula = y ~ x1 + x2, data = dat)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -1.14168 -0.20095  0.00235  0.20385  1.19576 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.064216   0.009556 111.372   <2e-16 ***
## x12          0.065627   0.034052   1.927   0.0540 .  
## x13         -0.072582   0.031793  -2.283   0.0225 *  
## x14          0.554412   0.031780  17.445   <2e-16 ***
## x15          0.648345   0.032494  19.953   <2e-16 ***
## x16          0.432221   0.029223  14.791   <2e-16 ***
## x17          0.062048   0.031613   1.963   0.0497 *  
## x18          0.546550   0.032857  16.634   <2e-16 ***
## x19         -0.079373   0.034064  -2.330   0.0198 *  
## x110         0.032431   0.029625   1.095   0.2737    
## x22         -0.717703   0.013430 -53.441   <2e-16 ***
## x23         -0.740284   0.013557 -54.605   <2e-16 ***
## x24         -0.723680   0.013411 -53.962   <2e-16 ***
## x25         -0.465043   0.013557 -34.303   <2e-16 ***
## x26         -0.804516   0.013510 -59.551   <2e-16 ***
## x27         -0.832053   0.013662 -60.902   <2e-16 ***
## x28         -0.850546   0.013708 -62.047   <2e-16 ***
## x29         -0.849960   0.013550 -62.728   <2e-16 ***
## x210        -0.554409   0.013264 -41.799   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.3032 on 9981 degrees of freedom
## Multiple R-squared:  0.4441,	Adjusted R-squared:  0.4431 
## F-statistic:   443 on 18 and 9981 DF,  p-value: < 2.2e-16
```

```r
# sequential
anova(m1)
```

```
## Analysis of Variance Table
## 
## Response: y
##             Df Sum Sq Mean Sq F value    Pr(>F)    
## x1           9 108.84  12.094  131.58 < 2.2e-16 ***
## x2           9 624.03  69.337  754.37 < 2.2e-16 ***
## Residuals 9981 917.39   0.092                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
# type II/III
library(car)
Anova(m1, type = "II")
```

```
## Anova Table (Type II tests)
## 
## Response: y
##           Sum Sq   Df F value    Pr(>F)    
## x1        108.91    9  131.65 < 2.2e-16 ***
## x2        624.03    9  754.37 < 2.2e-16 ***
## Residuals 917.39 9981                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
library(lme4)
m1 = lmer(y ~ (1|x1) + (1|x2), data = dat)
summary(m1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: y ~ (1 | x1) + (1 | x2)
##    Data: dat
## 
## REML criterion at convergence: 4620
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -3.7667 -0.6629  0.0078  0.6721  3.9470 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  x1       (Intercept) 0.08282  0.2878  
##  x2       (Intercept) 0.06891  0.2625  
##  Residual             0.09191  0.3032  
## Number of obs: 10000, groups:  x1, 10; x2, 10
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   0.6292     0.1235   5.092
```





```r
# Simulations to see how we can use GLMs to partition variation between 3 variables in a glm

x1 = rnorm(10)
x2 = rnorm(10)
x3 = rnorm(10)

df = expand.grid(as.factor(x1), as.factor(x2), as.factor(x3))
resp = plogis(x1[df$Var1] + x2[df$Var2] + x3[df$Var3] )
df$y = rbinom(nrow(df), 10, resp)

fit1 <- glm(y/10 ~ (Var1 + Var2 + Var3)^2 , data = df, family = binomial, weights = rep(10, nrow(df)) )
summary(fit1)
```

```
## 
## Call:
## glm(formula = y/10 ~ (Var1 + Var2 + Var3)^2, family = binomial, 
##     data = df, weights = rep(10, nrow(df)))
## 
## Deviance Residuals: 
##      Min        1Q    Median        3Q       Max  
## -2.55388  -0.59560   0.01225   0.62122   2.58703  
## 
## Coefficients:
##                                                  Estimate Std. Error
## (Intercept)                                     -2.754247   0.518438
## Var1-0.575584859972292                           0.993631   0.581276
## Var1-0.500352281673566                           1.549352   0.563824
## Var1-0.10931077612195                            1.733708   0.562110
## Var1-0.0943925491180511                          1.626551   0.561912
## Var10.158304498937633                            1.248350   0.567804
## Var10.463720122352477                            0.794712   0.588493
## Var11.5138459859658                              2.954164   0.562545
## Var11.79370123425233                             2.796445   0.565201
## Var12.59390504476202                             4.066548   0.608376
## Var2-1.49075257996644                           -0.122452   0.538254
## Var2-1.04169356617021                            1.769105   0.493405
## Var2-0.822431856502427                          -0.859024   0.663362
## Var2-0.347944063287726                           1.264397   0.495364
## Var2-0.173424293146404                          -1.898564   0.715815
## Var2-0.0180368574391981                          1.853936   0.494069
## Var20.845778159555612                           -0.872712   0.621074
## Var21.22935568635659                            -0.440544   0.593598
## Var21.24934879917613                            -0.396517   0.562568
## Var3-1.19036573697996                            1.366111   0.554277
## Var3-0.788072436125928                          -0.063260   0.620644
## Var3-0.780011212997341                           2.758611   0.568901
## Var3-0.508023654141745                           0.730099   0.572002
## Var3-0.234284724038323                           0.494675   0.572964
## Var3-0.121367502213243                           0.621009   0.576953
## Var30.018078249186661                            1.568354   0.556099
## Var30.322495264052787                            1.273200   0.557044
## Var31.50452953702608                             0.992575   0.567339
## Var1-0.575584859972292:Var2-1.49075257996644     0.027026   0.517984
## Var1-0.500352281673566:Var2-1.49075257996644    -0.002117   0.501200
## Var1-0.10931077612195:Var2-1.49075257996644     -0.134875   0.504372
## Var1-0.0943925491180511:Var2-1.49075257996644   -0.578631   0.504004
## Var10.158304498937633:Var2-1.49075257996644     -0.389318   0.506391
## Var10.463720122352477:Var2-1.49075257996644      0.458302   0.516317
## Var11.5138459859658:Var2-1.49075257996644       -0.012261   0.526537
## Var11.79370123425233:Var2-1.49075257996644      -0.401776   0.523711
## Var12.59390504476202:Var2-1.49075257996644       0.674868   0.668772
## Var1-0.575584859972292:Var2-1.04169356617021    -0.497859   0.488756
## Var1-0.500352281673566:Var2-1.04169356617021     0.377984   0.533211
## Var1-0.10931077612195:Var2-1.04169356617021     -0.873387   0.487019
## Var1-0.0943925491180511:Var2-1.04169356617021   -0.893685   0.480725
## Var10.158304498937633:Var2-1.04169356617021     -0.694223   0.482417
## Var10.463720122352477:Var2-1.04169356617021     -0.270515   0.492727
## Var11.5138459859658:Var2-1.04169356617021       -0.670335   0.557056
## Var11.79370123425233:Var2-1.04169356617021      -0.658114   0.569759
## Var12.59390504476202:Var2-1.04169356617021      -0.926883   0.672545
## Var1-0.575584859972292:Var2-0.822431856502427   -1.318028   0.703494
## Var1-0.500352281673566:Var2-0.822431856502427   -0.932615   0.584332
## Var1-0.10931077612195:Var2-0.822431856502427    -1.927826   0.636606
## Var1-0.0943925491180511:Var2-0.822431856502427  -1.386397   0.614023
## Var10.158304498937633:Var2-0.822431856502427    -1.223826   0.621594
## Var10.463720122352477:Var2-0.822431856502427    -2.116366   0.800977
## Var11.5138459859658:Var2-0.822431856502427      -1.031979   0.570881
## Var11.79370123425233:Var2-0.822431856502427     -1.075197   0.574940
## Var12.59390504476202:Var2-0.822431856502427     -1.154713   0.611800
## Var1-0.575584859972292:Var2-0.347944063287726   -0.172211   0.487231
## Var1-0.500352281673566:Var2-0.347944063287726   -0.144166   0.483863
## Var1-0.10931077612195:Var2-0.347944063287726    -0.318574   0.484386
## Var1-0.0943925491180511:Var2-0.347944063287726  -0.306450   0.478706
## Var10.158304498937633:Var2-0.347944063287726    -0.211568   0.478846
## Var10.463720122352477:Var2-0.347944063287726     0.074885   0.490870
## Var11.5138459859658:Var2-0.347944063287726      -0.084814   0.542874
## Var11.79370123425233:Var2-0.347944063287726     -0.283093   0.538975
## Var12.59390504476202:Var2-0.347944063287726     -0.521753   0.630172
## Var1-0.575584859972292:Var2-0.173424293146404    0.385620   0.657174
## Var1-0.500352281673566:Var2-0.173424293146404   -0.060329   0.628678
## Var1-0.10931077612195:Var2-0.173424293146404    -0.466525   0.643165
## Var1-0.0943925491180511:Var2-0.173424293146404  -0.224495   0.638537
## Var10.158304498937633:Var2-0.173424293146404    -0.091658   0.644583
## Var10.463720122352477:Var2-0.173424293146404    -0.231201   0.687481
## Var11.5138459859658:Var2-0.173424293146404      -0.334441   0.624603
## Var11.79370123425233:Var2-0.173424293146404     -0.128079   0.627225
## Var12.59390504476202:Var2-0.173424293146404      0.015022   0.666563
## Var1-0.575584859972292:Var2-0.0180368574391981   0.007638   0.487484
## Var1-0.500352281673566:Var2-0.0180368574391981   0.018715   0.503723
## Var1-0.10931077612195:Var2-0.0180368574391981   -0.598982   0.487823
## Var1-0.0943925491180511:Var2-0.0180368574391981 -0.823952   0.476061
## Var10.158304498937633:Var2-0.0180368574391981   -0.368232   0.482068
## Var10.463720122352477:Var2-0.0180368574391981   -0.265738   0.487456
## Var11.5138459859658:Var2-0.0180368574391981     -0.061033   0.594692
## Var11.79370123425233:Var2-0.0180368574391981     0.426521   0.678947
## Var12.59390504476202:Var2-0.0180368574391981    -1.002786   0.646412
## Var1-0.575584859972292:Var20.845778159555612     0.333158   0.623645
## Var1-0.500352281673566:Var20.845778159555612     0.255451   0.592020
## Var1-0.10931077612195:Var20.845778159555612      0.331712   0.593869
## Var1-0.0943925491180511:Var20.845778159555612    0.447826   0.591466
## Var10.158304498937633:Var20.845778159555612      0.731023   0.592645
## Var10.463720122352477:Var20.845778159555612      0.235184   0.628900
## Var11.5138459859658:Var20.845778159555612        0.706062   0.601570
## Var11.79370123425233:Var20.845778159555612       0.459599   0.602823
## Var12.59390504476202:Var20.845778159555612       0.649809   0.659472
## Var1-0.575584859972292:Var21.22935568635659     -0.062234   0.595443
## Var1-0.500352281673566:Var21.22935568635659     -0.091546   0.558807
## Var1-0.10931077612195:Var21.22935568635659      -0.661864   0.572488
## Var1-0.0943925491180511:Var21.22935568635659    -0.752103   0.578791
## Var10.158304498937633:Var21.22935568635659       0.048068   0.564921
## Var10.463720122352477:Var21.22935568635659      -0.088364   0.596992
## Var11.5138459859658:Var21.22935568635659        -0.123739   0.564232
## Var11.79370123425233:Var21.22935568635659       -0.322107   0.567596
## Var12.59390504476202:Var21.22935568635659       -0.135206   0.617323
## Var1-0.575584859972292:Var21.24934879917613      0.283255   0.553773
## Var1-0.500352281673566:Var21.24934879917613      0.357464   0.530767
## Var1-0.10931077612195:Var21.24934879917613      -0.141338   0.536892
## Var1-0.0943925491180511:Var21.24934879917613     0.210697   0.531878
## Var10.158304498937633:Var21.24934879917613       0.355853   0.534588
## Var10.463720122352477:Var21.24934879917613       0.130362   0.560000
## Var11.5138459859658:Var21.24934879917613         0.115354   0.547352
## Var11.79370123425233:Var21.24934879917613        0.409221   0.557549
## Var12.59390504476202:Var21.24934879917613        0.182007   0.616642
## Var1-0.575584859972292:Var3-1.19036573697996    -0.640132   0.578208
## Var1-0.500352281673566:Var3-1.19036573697996     0.049862   0.567129
## Var1-0.10931077612195:Var3-1.19036573697996      0.036502   0.563624
## Var1-0.0943925491180511:Var3-1.19036573697996    0.274141   0.563133
## Var10.158304498937633:Var3-1.19036573697996     -0.290541   0.565470
## Var10.463720122352477:Var3-1.19036573697996     -0.532646   0.585849
## Var11.5138459859658:Var3-1.19036573697996        0.140285   0.576477
## Var11.79370123425233:Var3-1.19036573697996      -0.104529   0.566888
## Var12.59390504476202:Var3-1.19036573697996      -0.546236   0.599059
## Var1-0.575584859972292:Var3-0.788072436125928   -0.108653   0.653958
## Var1-0.500352281673566:Var3-0.788072436125928    0.526574   0.628883
## Var1-0.10931077612195:Var3-0.788072436125928     0.074839   0.630083
## Var1-0.0943925491180511:Var3-0.788072436125928   0.159538   0.631358
## Var10.158304498937633:Var3-0.788072436125928     0.304049   0.633952
## Var10.463720122352477:Var3-0.788072436125928     0.035154   0.659458
## Var11.5138459859658:Var3-0.788072436125928      -0.112496   0.617457
## Var11.79370123425233:Var3-0.788072436125928      0.499973   0.620373
## Var12.59390504476202:Var3-0.788072436125928      0.139495   0.639596
## Var1-0.575584859972292:Var3-0.780011212997341   -0.257380   0.578123
## Var1-0.500352281673566:Var3-0.780011212997341    0.074560   0.583819
## Var1-0.10931077612195:Var3-0.780011212997341     0.392944   0.592621
## Var1-0.0943925491180511:Var3-0.780011212997341   0.160366   0.581351
## Var10.158304498937633:Var3-0.780011212997341     0.199227   0.581210
## Var10.463720122352477:Var3-0.780011212997341     0.333434   0.595721
## Var11.5138459859658:Var3-0.780011212997341      -0.537474   0.601858
## Var11.79370123425233:Var3-0.780011212997341      0.257060   0.642675
## Var12.59390504476202:Var3-0.780011212997341      1.171474   1.143031
## Var1-0.575584859972292:Var3-0.508023654141745   -0.409126   0.601476
## Var1-0.500352281673566:Var3-0.508023654141745   -0.084785   0.584888
## Var1-0.10931077612195:Var3-0.508023654141745     0.277404   0.580172
## Var1-0.0943925491180511:Var3-0.508023654141745  -0.156177   0.581853
## Var10.158304498937633:Var3-0.508023654141745     0.412033   0.582809
## Var10.463720122352477:Var3-0.508023654141745     0.023360   0.602417
## Var11.5138459859658:Var3-0.508023654141745       0.034499   0.580757
## Var11.79370123425233:Var3-0.508023654141745      0.418349   0.584124
## Var12.59390504476202:Var3-0.508023654141745     -0.420862   0.603049
## Var1-0.575584859972292:Var3-0.234284724038323   -0.858151   0.606301
## Var1-0.500352281673566:Var3-0.234284724038323   -0.014778   0.582619
## Var1-0.10931077612195:Var3-0.234284724038323    -0.031113   0.578485
## Var1-0.0943925491180511:Var3-0.234284724038323  -0.052686   0.578523
## Var10.158304498937633:Var3-0.234284724038323     0.150213   0.581362
## Var10.463720122352477:Var3-0.234284724038323     0.175063   0.599192
## Var11.5138459859658:Var3-0.234284724038323      -0.195626   0.574333
## Var11.79370123425233:Var3-0.234284724038323      0.227332   0.578748
## Var12.59390504476202:Var3-0.234284724038323     -0.027217   0.615351
## Var1-0.575584859972292:Var3-0.121367502213243   -0.440803   0.601345
## Var1-0.500352281673566:Var3-0.121367502213243   -0.288503   0.586165
## Var1-0.10931077612195:Var3-0.121367502213243    -0.538882   0.585102
## Var1-0.0943925491180511:Var3-0.121367502213243  -0.234676   0.583339
## Var10.158304498937633:Var3-0.121367502213243    -0.500906   0.592662
## Var10.463720122352477:Var3-0.121367502213243    -0.424970   0.610591
## Var11.5138459859658:Var3-0.121367502213243      -0.281971   0.578762
## Var11.79370123425233:Var3-0.121367502213243      0.141497   0.583070
## Var12.59390504476202:Var3-0.121367502213243     -0.153393   0.613015
## Var1-0.575584859972292:Var30.018078249186661    -0.360665   0.575265
## Var1-0.500352281673566:Var30.018078249186661     0.394014   0.570603
## Var1-0.10931077612195:Var30.018078249186661      0.475506   0.569324
## Var1-0.0943925491180511:Var30.018078249186661   -0.187995   0.562784
## Var10.158304498937633:Var30.018078249186661      0.149448   0.565806
## Var10.463720122352477:Var30.018078249186661      0.309932   0.583577
## Var11.5138459859658:Var30.018078249186661        0.177060   0.581662
## Var11.79370123425233:Var30.018078249186661       0.092208   0.574254
## Var12.59390504476202:Var30.018078249186661       0.537135   0.684076
## Var1-0.575584859972292:Var30.322495264052787    -0.476477   0.576853
## Var1-0.500352281673566:Var30.322495264052787     0.151120   0.569236
## Var1-0.10931077612195:Var30.322495264052787      0.120633   0.564989
## Var1-0.0943925491180511:Var30.322495264052787   -0.254058   0.562756
## Var10.158304498937633:Var30.322495264052787      0.038678   0.565780
## Var10.463720122352477:Var30.322495264052787     -0.131121   0.582279
## Var11.5138459859658:Var30.322495264052787        0.118402   0.579721
## Var11.79370123425233:Var30.322495264052787       1.042958   0.607286
## Var12.59390504476202:Var30.322495264052787      -0.190129   0.620884
## Var1-0.575584859972292:Var31.50452953702608      0.266161   0.589079
## Var1-0.500352281673566:Var31.50452953702608      0.779401   0.584914
## Var1-0.10931077612195:Var31.50452953702608      -0.337843   0.578576
## Var1-0.0943925491180511:Var31.50452953702608    -0.058641   0.577474
## Var10.158304498937633:Var31.50452953702608       0.033644   0.580820
## Var10.463720122352477:Var31.50452953702608      -0.575706   0.605308
## Var11.5138459859658:Var31.50452953702608         0.167708   0.584453
## Var11.79370123425233:Var31.50452953702608       -0.036212   0.578040
## Var12.59390504476202:Var31.50452953702608       -0.194359   0.615691
## Var2-1.49075257996644:Var3-1.19036573697996      0.325570   0.486951
## Var2-1.04169356617021:Var3-1.19036573697996     -0.253698   0.475919
## Var2-0.822431856502427:Var3-1.19036573697996     0.030931   0.600644
## Var2-0.347944063287726:Var3-1.19036573697996    -0.050443   0.476205
## Var2-0.173424293146404:Var3-1.19036573697996     0.478976   0.591202
## Var2-0.0180368574391981:Var3-1.19036573697996   -0.284258   0.486136
## Var20.845778159555612:Var3-1.19036573697996     -0.316941   0.495787
## Var21.22935568635659:Var3-1.19036573697996      -0.437459   0.503378
## Var21.24934879917613:Var3-1.19036573697996      -0.277961   0.483419
## Var2-1.49075257996644:Var3-0.788072436125928     0.444470   0.496111
## Var2-1.04169356617021:Var3-0.788072436125928     0.226625   0.473679
## Var2-0.822431856502427:Var3-0.788072436125928   -0.126708   0.664583
## Var2-0.347944063287726:Var3-0.788072436125928   -0.201164   0.469940
## Var2-0.173424293146404:Var3-0.788072436125928    0.622972   0.623440
## Var2-0.0180368574391981:Var3-0.788072436125928  -0.385706   0.477272
## Var20.845778159555612:Var3-0.788072436125928    -0.587851   0.526664
## Var21.22935568635659:Var3-0.788072436125928     -0.204192   0.527584
## Var21.24934879917613:Var3-0.788072436125928     -0.399695   0.505250
## Var2-1.49075257996644:Var3-0.780011212997341     0.280252   0.545989
## Var2-1.04169356617021:Var3-0.780011212997341     1.136136   0.845719
## Var2-0.822431856502427:Var3-0.780011212997341   -0.058905   0.613413
## Var2-0.347944063287726:Var3-0.780011212997341    0.208117   0.620459
## Var2-0.173424293146404:Var3-0.780011212997341    0.791416   0.611149
## Var2-0.0180368574391981:Var3-0.780011212997341  -0.100543   0.647825
## Var20.845778159555612:Var3-0.780011212997341    -0.221927   0.533995
## Var21.22935568635659:Var3-0.780011212997341     -0.558919   0.528492
## Var21.24934879917613:Var3-0.780011212997341     -0.071393   0.532670
## Var2-1.49075257996644:Var3-0.508023654141745     0.100005   0.486437
## Var2-1.04169356617021:Var3-0.508023654141745     0.014939   0.470689
## Var2-0.822431856502427:Var3-0.508023654141745    0.202073   0.608307
## Var2-0.347944063287726:Var3-0.508023654141745   -0.359377   0.463598
## Var2-0.173424293146404:Var3-0.508023654141745    0.123487   0.612038
## Var2-0.0180368574391981:Var3-0.508023654141745   0.173029   0.485305
## Var20.845778159555612:Var3-0.508023654141745    -0.021665   0.494950
## Var21.22935568635659:Var3-0.508023654141745     -0.097629   0.502967
## Var21.24934879917613:Var3-0.508023654141745     -0.121869   0.482895
## Var2-1.49075257996644:Var3-0.234284724038323     0.157294   0.492315
## Var2-1.04169356617021:Var3-0.234284724038323     0.710015   0.484124
## Var2-0.822431856502427:Var3-0.234284724038323    0.889853   0.601130
## Var2-0.347944063287726:Var3-0.234284724038323    0.329889   0.471869
## Var2-0.173424293146404:Var3-0.234284724038323    1.272038   0.593735
## Var2-0.0180368574391981:Var3-0.234284724038323   0.308530   0.484499
## Var20.845778159555612:Var3-0.234284724038323    -0.065577   0.503032
## Var21.22935568635659:Var3-0.234284724038323     -0.107028   0.513436
## Var21.24934879917613:Var3-0.234284724038323      0.363368   0.485583
## Var2-1.49075257996644:Var3-0.121367502213243     0.501022   0.493958
## Var2-1.04169356617021:Var3-0.121367502213243     0.136034   0.472743
## Var2-0.822431856502427:Var3-0.121367502213243   -0.311607   0.657732
## Var2-0.347944063287726:Var3-0.121367502213243   -0.018263   0.469690
## Var2-0.173424293146404:Var3-0.121367502213243    0.711285   0.612938
## Var2-0.0180368574391981:Var3-0.121367502213243  -0.297305   0.476476
## Var20.845778159555612:Var3-0.121367502213243    -0.164801   0.512169
## Var21.22935568635659:Var3-0.121367502213243     -0.652392   0.537720
## Var21.24934879917613:Var3-0.121367502213243      0.367624   0.490744
## Var2-1.49075257996644:Var30.018078249186661      0.281772   0.493697
## Var2-1.04169356617021:Var30.018078249186661      0.502647   0.531262
## Var2-0.822431856502427:Var30.018078249186661     0.180052   0.597996
## Var2-0.347944063287726:Var30.018078249186661    -0.347886   0.483459
## Var2-0.173424293146404:Var30.018078249186661     0.482196   0.591500
## Var2-0.0180368574391981:Var30.018078249186661   -0.557977   0.495502
## Var20.845778159555612:Var30.018078249186661     -0.508145   0.498490
## Var21.22935568635659:Var30.018078249186661      -0.486096   0.504132
## Var21.24934879917613:Var30.018078249186661      -0.490234   0.486640
## Var2-1.49075257996644:Var30.322495264052787      0.369513   0.492215
## Var2-1.04169356617021:Var30.322495264052787     -0.169922   0.481652
## Var2-0.822431856502427:Var30.322495264052787    -0.089009   0.609588
## Var2-0.347944063287726:Var30.322495264052787    -0.154965   0.477514
## Var2-0.173424293146404:Var30.322495264052787     0.386425   0.598968
## Var2-0.0180368574391981:Var30.322495264052787    0.293238   0.510645
## Var20.845778159555612:Var30.322495264052787     -0.108196   0.500436
## Var21.22935568635659:Var30.322495264052787      -0.097830   0.505679
## Var21.24934879917613:Var30.322495264052787       0.266893   0.488146
## Var2-1.49075257996644:Var31.50452953702608       0.127890   0.486088
## Var2-1.04169356617021:Var31.50452953702608       0.513626   0.491422
## Var2-0.822431856502427:Var31.50452953702608     -0.213502   0.613960
## Var2-0.347944063287726:Var31.50452953702608     -0.450967   0.465487
## Var2-0.173424293146404:Var31.50452953702608      0.524822   0.593310
## Var2-0.0180368574391981:Var31.50452953702608     0.240985   0.497514
## Var20.845778159555612:Var31.50452953702608      -0.160281   0.494283
## Var21.22935568635659:Var31.50452953702608       -0.316435   0.504047
## Var21.24934879917613:Var31.50452953702608       -0.184795   0.482923
##                                                 z value Pr(>|z|)    
## (Intercept)                                      -5.313 1.08e-07 ***
## Var1-0.575584859972292                            1.709 0.087378 .  
## Var1-0.500352281673566                            2.748 0.005997 ** 
## Var1-0.10931077612195                             3.084 0.002040 ** 
## Var1-0.0943925491180511                           2.895 0.003796 ** 
## Var10.158304498937633                             2.199 0.027910 *  
## Var10.463720122352477                             1.350 0.176882    
## Var11.5138459859658                               5.251 1.51e-07 ***
## Var11.79370123425233                              4.948 7.51e-07 ***
## Var12.59390504476202                              6.684 2.32e-11 ***
## Var2-1.49075257996644                            -0.227 0.820036    
## Var2-1.04169356617021                             3.585 0.000336 ***
## Var2-0.822431856502427                           -1.295 0.195336    
## Var2-0.347944063287726                            2.552 0.010697 *  
## Var2-0.173424293146404                           -2.652 0.007994 ** 
## Var2-0.0180368574391981                           3.752 0.000175 ***
## Var20.845778159555612                            -1.405 0.159972    
## Var21.22935568635659                             -0.742 0.457991    
## Var21.24934879917613                             -0.705 0.480914    
## Var3-1.19036573697996                             2.465 0.013714 *  
## Var3-0.788072436125928                           -0.102 0.918815    
## Var3-0.780011212997341                            4.849 1.24e-06 ***
## Var3-0.508023654141745                            1.276 0.201817    
## Var3-0.234284724038323                            0.863 0.387938    
## Var3-0.121367502213243                            1.076 0.281766    
## Var30.018078249186661                             2.820 0.004798 ** 
## Var30.322495264052787                             2.286 0.022276 *  
## Var31.50452953702608                              1.750 0.080200 .  
## Var1-0.575584859972292:Var2-1.49075257996644      0.052 0.958389    
## Var1-0.500352281673566:Var2-1.49075257996644     -0.004 0.996630    
## Var1-0.10931077612195:Var2-1.49075257996644      -0.267 0.789153    
## Var1-0.0943925491180511:Var2-1.49075257996644    -1.148 0.250941    
## Var10.158304498937633:Var2-1.49075257996644      -0.769 0.442007    
## Var10.463720122352477:Var2-1.49075257996644       0.888 0.374736    
## Var11.5138459859658:Var2-1.49075257996644        -0.023 0.981422    
## Var11.79370123425233:Var2-1.49075257996644       -0.767 0.442980    
## Var12.59390504476202:Var2-1.49075257996644        1.009 0.312920    
## Var1-0.575584859972292:Var2-1.04169356617021     -1.019 0.308381    
## Var1-0.500352281673566:Var2-1.04169356617021      0.709 0.478397    
## Var1-0.10931077612195:Var2-1.04169356617021      -1.793 0.072920 .  
## Var1-0.0943925491180511:Var2-1.04169356617021    -1.859 0.063022 .  
## Var10.158304498937633:Var2-1.04169356617021      -1.439 0.150136    
## Var10.463720122352477:Var2-1.04169356617021      -0.549 0.582994    
## Var11.5138459859658:Var2-1.04169356617021        -1.203 0.228840    
## Var11.79370123425233:Var2-1.04169356617021       -1.155 0.248060    
## Var12.59390504476202:Var2-1.04169356617021       -1.378 0.168150    
## Var1-0.575584859972292:Var2-0.822431856502427    -1.874 0.060993 .  
## Var1-0.500352281673566:Var2-0.822431856502427    -1.596 0.110481    
## Var1-0.10931077612195:Var2-0.822431856502427     -3.028 0.002459 ** 
## Var1-0.0943925491180511:Var2-0.822431856502427   -2.258 0.023952 *  
## Var10.158304498937633:Var2-0.822431856502427     -1.969 0.048970 *  
## Var10.463720122352477:Var2-0.822431856502427     -2.642 0.008236 ** 
## Var11.5138459859658:Var2-0.822431856502427       -1.808 0.070654 .  
## Var11.79370123425233:Var2-0.822431856502427      -1.870 0.061470 .  
## Var12.59390504476202:Var2-0.822431856502427      -1.887 0.059106 .  
## Var1-0.575584859972292:Var2-0.347944063287726    -0.353 0.723752    
## Var1-0.500352281673566:Var2-0.347944063287726    -0.298 0.765743    
## Var1-0.10931077612195:Var2-0.347944063287726     -0.658 0.510740    
## Var1-0.0943925491180511:Var2-0.347944063287726   -0.640 0.522066    
## Var10.158304498937633:Var2-0.347944063287726     -0.442 0.658612    
## Var10.463720122352477:Var2-0.347944063287726      0.153 0.878748    
## Var11.5138459859658:Var2-0.347944063287726       -0.156 0.875851    
## Var11.79370123425233:Var2-0.347944063287726      -0.525 0.599414    
## Var12.59390504476202:Var2-0.347944063287726      -0.828 0.407696    
## Var1-0.575584859972292:Var2-0.173424293146404     0.587 0.557348    
## Var1-0.500352281673566:Var2-0.173424293146404    -0.096 0.923551    
## Var1-0.10931077612195:Var2-0.173424293146404     -0.725 0.468232    
## Var1-0.0943925491180511:Var2-0.173424293146404   -0.352 0.725155    
## Var10.158304498937633:Var2-0.173424293146404     -0.142 0.886925    
## Var10.463720122352477:Var2-0.173424293146404     -0.336 0.736644    
## Var11.5138459859658:Var2-0.173424293146404       -0.535 0.592341    
## Var11.79370123425233:Var2-0.173424293146404      -0.204 0.838198    
## Var12.59390504476202:Var2-0.173424293146404       0.023 0.982020    
## Var1-0.575584859972292:Var2-0.0180368574391981    0.016 0.987500    
## Var1-0.500352281673566:Var2-0.0180368574391981    0.037 0.970362    
## Var1-0.10931077612195:Var2-0.0180368574391981    -1.228 0.219497    
## Var1-0.0943925491180511:Var2-0.0180368574391981  -1.731 0.083493 .  
## Var10.158304498937633:Var2-0.0180368574391981    -0.764 0.444951    
## Var10.463720122352477:Var2-0.0180368574391981    -0.545 0.585648    
## Var11.5138459859658:Var2-0.0180368574391981      -0.103 0.918257    
## Var11.79370123425233:Var2-0.0180368574391981      0.628 0.529867    
## Var12.59390504476202:Var2-0.0180368574391981     -1.551 0.120827    
## Var1-0.575584859972292:Var20.845778159555612      0.534 0.593195    
## Var1-0.500352281673566:Var20.845778159555612      0.431 0.666111    
## Var1-0.10931077612195:Var20.845778159555612       0.559 0.576462    
## Var1-0.0943925491180511:Var20.845778159555612     0.757 0.448963    
## Var10.158304498937633:Var20.845778159555612       1.233 0.217392    
## Var10.463720122352477:Var20.845778159555612       0.374 0.708433    
## Var11.5138459859658:Var20.845778159555612         1.174 0.240515    
## Var11.79370123425233:Var20.845778159555612        0.762 0.445814    
## Var12.59390504476202:Var20.845778159555612        0.985 0.324453    
## Var1-0.575584859972292:Var21.22935568635659      -0.105 0.916759    
## Var1-0.500352281673566:Var21.22935568635659      -0.164 0.869870    
## Var1-0.10931077612195:Var21.22935568635659       -1.156 0.247632    
## Var1-0.0943925491180511:Var21.22935568635659     -1.299 0.193794    
## Var10.158304498937633:Var21.22935568635659        0.085 0.932191    
## Var10.463720122352477:Var21.22935568635659       -0.148 0.882331    
## Var11.5138459859658:Var21.22935568635659         -0.219 0.826413    
## Var11.79370123425233:Var21.22935568635659        -0.567 0.570378    
## Var12.59390504476202:Var21.22935568635659        -0.219 0.826635    
## Var1-0.575584859972292:Var21.24934879917613       0.511 0.609001    
## Var1-0.500352281673566:Var21.24934879917613       0.673 0.500638    
## Var1-0.10931077612195:Var21.24934879917613       -0.263 0.792356    
## Var1-0.0943925491180511:Var21.24934879917613      0.396 0.692003    
## Var10.158304498937633:Var21.24934879917613        0.666 0.505630    
## Var10.463720122352477:Var21.24934879917613        0.233 0.815925    
## Var11.5138459859658:Var21.24934879917613          0.211 0.833084    
## Var11.79370123425233:Var21.24934879917613         0.734 0.462971    
## Var12.59390504476202:Var21.24934879917613         0.295 0.767873    
## Var1-0.575584859972292:Var3-1.19036573697996     -1.107 0.268253    
## Var1-0.500352281673566:Var3-1.19036573697996      0.088 0.929941    
## Var1-0.10931077612195:Var3-1.19036573697996       0.065 0.948362    
## Var1-0.0943925491180511:Var3-1.19036573697996     0.487 0.626390    
## Var10.158304498937633:Var3-1.19036573697996      -0.514 0.607388    
## Var10.463720122352477:Var3-1.19036573697996      -0.909 0.363251    
## Var11.5138459859658:Var3-1.19036573697996         0.243 0.807735    
## Var11.79370123425233:Var3-1.19036573697996       -0.184 0.853706    
## Var12.59390504476202:Var3-1.19036573697996       -0.912 0.361861    
## Var1-0.575584859972292:Var3-0.788072436125928    -0.166 0.868042    
## Var1-0.500352281673566:Var3-0.788072436125928     0.837 0.402415    
## Var1-0.10931077612195:Var3-0.788072436125928      0.119 0.905452    
## Var1-0.0943925491180511:Var3-0.788072436125928    0.253 0.800507    
## Var10.158304498937633:Var3-0.788072436125928      0.480 0.631505    
## Var10.463720122352477:Var3-0.788072436125928      0.053 0.957487    
## Var11.5138459859658:Var3-0.788072436125928       -0.182 0.855432    
## Var11.79370123425233:Var3-0.788072436125928       0.806 0.420287    
## Var12.59390504476202:Var3-0.788072436125928       0.218 0.827352    
## Var1-0.575584859972292:Var3-0.780011212997341    -0.445 0.656176    
## Var1-0.500352281673566:Var3-0.780011212997341     0.128 0.898378    
## Var1-0.10931077612195:Var3-0.780011212997341      0.663 0.507291    
## Var1-0.0943925491180511:Var3-0.780011212997341    0.276 0.782663    
## Var10.158304498937633:Var3-0.780011212997341      0.343 0.731763    
## Var10.463720122352477:Var3-0.780011212997341      0.560 0.575674    
## Var11.5138459859658:Var3-0.780011212997341       -0.893 0.371844    
## Var11.79370123425233:Var3-0.780011212997341       0.400 0.689169    
## Var12.59390504476202:Var3-0.780011212997341       1.025 0.305418    
## Var1-0.575584859972292:Var3-0.508023654141745    -0.680 0.496376    
## Var1-0.500352281673566:Var3-0.508023654141745    -0.145 0.884742    
## Var1-0.10931077612195:Var3-0.508023654141745      0.478 0.632550    
## Var1-0.0943925491180511:Var3-0.508023654141745   -0.268 0.788381    
## Var10.158304498937633:Var3-0.508023654141745      0.707 0.479580    
## Var10.463720122352477:Var3-0.508023654141745      0.039 0.969068    
## Var11.5138459859658:Var3-0.508023654141745        0.059 0.952631    
## Var11.79370123425233:Var3-0.508023654141745       0.716 0.473869    
## Var12.59390504476202:Var3-0.508023654141745      -0.698 0.485247    
## Var1-0.575584859972292:Var3-0.234284724038323    -1.415 0.156955    
## Var1-0.500352281673566:Var3-0.234284724038323    -0.025 0.979764    
## Var1-0.10931077612195:Var3-0.234284724038323     -0.054 0.957108    
## Var1-0.0943925491180511:Var3-0.234284724038323   -0.091 0.927437    
## Var10.158304498937633:Var3-0.234284724038323      0.258 0.796113    
## Var10.463720122352477:Var3-0.234284724038323      0.292 0.770161    
## Var11.5138459859658:Var3-0.234284724038323       -0.341 0.733394    
## Var11.79370123425233:Var3-0.234284724038323       0.393 0.694467    
## Var12.59390504476202:Var3-0.234284724038323      -0.044 0.964721    
## Var1-0.575584859972292:Var3-0.121367502213243    -0.733 0.463541    
## Var1-0.500352281673566:Var3-0.121367502213243    -0.492 0.622587    
## Var1-0.10931077612195:Var3-0.121367502213243     -0.921 0.357047    
## Var1-0.0943925491180511:Var3-0.121367502213243   -0.402 0.687465    
## Var10.158304498937633:Var3-0.121367502213243     -0.845 0.398011    
## Var10.463720122352477:Var3-0.121367502213243     -0.696 0.486431    
## Var11.5138459859658:Var3-0.121367502213243       -0.487 0.626120    
## Var11.79370123425233:Var3-0.121367502213243       0.243 0.808256    
## Var12.59390504476202:Var3-0.121367502213243      -0.250 0.802412    
## Var1-0.575584859972292:Var30.018078249186661     -0.627 0.530689    
## Var1-0.500352281673566:Var30.018078249186661      0.691 0.489866    
## Var1-0.10931077612195:Var30.018078249186661       0.835 0.403599    
## Var1-0.0943925491180511:Var30.018078249186661    -0.334 0.738346    
## Var10.158304498937633:Var30.018078249186661       0.264 0.791678    
## Var10.463720122352477:Var30.018078249186661       0.531 0.595356    
## Var11.5138459859658:Var30.018078249186661         0.304 0.760821    
## Var11.79370123425233:Var30.018078249186661        0.161 0.872432    
## Var12.59390504476202:Var30.018078249186661        0.785 0.432337    
## Var1-0.575584859972292:Var30.322495264052787     -0.826 0.408807    
## Var1-0.500352281673566:Var30.322495264052787      0.265 0.790641    
## Var1-0.10931077612195:Var30.322495264052787       0.214 0.830926    
## Var1-0.0943925491180511:Var30.322495264052787    -0.451 0.651663    
## Var10.158304498937633:Var30.322495264052787       0.068 0.945497    
## Var10.463720122352477:Var30.322495264052787      -0.225 0.821834    
## Var11.5138459859658:Var30.322495264052787         0.204 0.838167    
## Var11.79370123425233:Var30.322495264052787        1.717 0.085905 .  
## Var12.59390504476202:Var30.322495264052787       -0.306 0.759435    
## Var1-0.575584859972292:Var31.50452953702608       0.452 0.651394    
## Var1-0.500352281673566:Var31.50452953702608       1.333 0.182694    
## Var1-0.10931077612195:Var31.50452953702608       -0.584 0.559273    
## Var1-0.0943925491180511:Var31.50452953702608     -0.102 0.919116    
## Var10.158304498937633:Var31.50452953702608        0.058 0.953808    
## Var10.463720122352477:Var31.50452953702608       -0.951 0.341555    
## Var11.5138459859658:Var31.50452953702608          0.287 0.774151    
## Var11.79370123425233:Var31.50452953702608        -0.063 0.950049    
## Var12.59390504476202:Var31.50452953702608        -0.316 0.752249    
## Var2-1.49075257996644:Var3-1.19036573697996       0.669 0.503758    
## Var2-1.04169356617021:Var3-1.19036573697996      -0.533 0.593986    
## Var2-0.822431856502427:Var3-1.19036573697996      0.051 0.958930    
## Var2-0.347944063287726:Var3-1.19036573697996     -0.106 0.915640    
## Var2-0.173424293146404:Var3-1.19036573697996      0.810 0.417841    
## Var2-0.0180368574391981:Var3-1.19036573697996    -0.585 0.558729    
## Var20.845778159555612:Var3-1.19036573697996      -0.639 0.522648    
## Var21.22935568635659:Var3-1.19036573697996       -0.869 0.384821    
## Var21.24934879917613:Var3-1.19036573697996       -0.575 0.565297    
## Var2-1.49075257996644:Var3-0.788072436125928      0.896 0.370301    
## Var2-1.04169356617021:Var3-0.788072436125928      0.478 0.632340    
## Var2-0.822431856502427:Var3-0.788072436125928    -0.191 0.848794    
## Var2-0.347944063287726:Var3-0.788072436125928    -0.428 0.668605    
## Var2-0.173424293146404:Var3-0.788072436125928     0.999 0.317674    
## Var2-0.0180368574391981:Var3-0.788072436125928   -0.808 0.419005    
## Var20.845778159555612:Var3-0.788072436125928     -1.116 0.264346    
## Var21.22935568635659:Var3-0.788072436125928      -0.387 0.698732    
## Var21.24934879917613:Var3-0.788072436125928      -0.791 0.428895    
## Var2-1.49075257996644:Var3-0.780011212997341      0.513 0.607747    
## Var2-1.04169356617021:Var3-0.780011212997341      1.343 0.179143    
## Var2-0.822431856502427:Var3-0.780011212997341    -0.096 0.923499    
## Var2-0.347944063287726:Var3-0.780011212997341     0.335 0.737305    
## Var2-0.173424293146404:Var3-0.780011212997341     1.295 0.195333    
## Var2-0.0180368574391981:Var3-0.780011212997341   -0.155 0.876663    
## Var20.845778159555612:Var3-0.780011212997341     -0.416 0.677704    
## Var21.22935568635659:Var3-0.780011212997341      -1.058 0.290250    
## Var21.24934879917613:Var3-0.780011212997341      -0.134 0.893379    
## Var2-1.49075257996644:Var3-0.508023654141745      0.206 0.837114    
## Var2-1.04169356617021:Var3-0.508023654141745      0.032 0.974681    
## Var2-0.822431856502427:Var3-0.508023654141745     0.332 0.739747    
## Var2-0.347944063287726:Var3-0.508023654141745    -0.775 0.438227    
## Var2-0.173424293146404:Var3-0.508023654141745     0.202 0.840102    
## Var2-0.0180368574391981:Var3-0.508023654141745    0.357 0.721438    
## Var20.845778159555612:Var3-0.508023654141745     -0.044 0.965087    
## Var21.22935568635659:Var3-0.508023654141745      -0.194 0.846092    
## Var21.24934879917613:Var3-0.508023654141745      -0.252 0.800754    
## Var2-1.49075257996644:Var3-0.234284724038323      0.319 0.749348    
## Var2-1.04169356617021:Var3-0.234284724038323      1.467 0.142485    
## Var2-0.822431856502427:Var3-0.234284724038323     1.480 0.138793    
## Var2-0.347944063287726:Var3-0.234284724038323     0.699 0.484482    
## Var2-0.173424293146404:Var3-0.234284724038323     2.142 0.032159 *  
## Var2-0.0180368574391981:Var3-0.234284724038323    0.637 0.524253    
## Var20.845778159555612:Var3-0.234284724038323     -0.130 0.896279    
## Var21.22935568635659:Var3-0.234284724038323      -0.208 0.834874    
## Var21.24934879917613:Var3-0.234284724038323       0.748 0.454272    
## Var2-1.49075257996644:Var3-0.121367502213243      1.014 0.310439    
## Var2-1.04169356617021:Var3-0.121367502213243      0.288 0.773535    
## Var2-0.822431856502427:Var3-0.121367502213243    -0.474 0.635672    
## Var2-0.347944063287726:Var3-0.121367502213243    -0.039 0.968983    
## Var2-0.173424293146404:Var3-0.121367502213243     1.160 0.245865    
## Var2-0.0180368574391981:Var3-0.121367502213243   -0.624 0.532650    
## Var20.845778159555612:Var3-0.121367502213243     -0.322 0.747627    
## Var21.22935568635659:Var3-0.121367502213243      -1.213 0.225032    
## Var21.24934879917613:Var3-0.121367502213243       0.749 0.453787    
## Var2-1.49075257996644:Var30.018078249186661       0.571 0.568177    
## Var2-1.04169356617021:Var30.018078249186661       0.946 0.344078    
## Var2-0.822431856502427:Var30.018078249186661      0.301 0.763344    
## Var2-0.347944063287726:Var30.018078249186661     -0.720 0.471786    
## Var2-0.173424293146404:Var30.018078249186661      0.815 0.414953    
## Var2-0.0180368574391981:Var30.018078249186661    -1.126 0.260130    
## Var20.845778159555612:Var30.018078249186661      -1.019 0.308028    
## Var21.22935568635659:Var30.018078249186661       -0.964 0.334934    
## Var21.24934879917613:Var30.018078249186661       -1.007 0.313749    
## Var2-1.49075257996644:Var30.322495264052787       0.751 0.452825    
## Var2-1.04169356617021:Var30.322495264052787      -0.353 0.724246    
## Var2-0.822431856502427:Var30.322495264052787     -0.146 0.883910    
## Var2-0.347944063287726:Var30.322495264052787     -0.325 0.745540    
## Var2-0.173424293146404:Var30.322495264052787      0.645 0.518829    
## Var2-0.0180368574391981:Var30.322495264052787     0.574 0.565798    
## Var20.845778159555612:Var30.322495264052787      -0.216 0.828828    
## Var21.22935568635659:Var30.322495264052787       -0.193 0.846596    
## Var21.24934879917613:Var30.322495264052787        0.547 0.584552    
## Var2-1.49075257996644:Var31.50452953702608        0.263 0.792473    
## Var2-1.04169356617021:Var31.50452953702608        1.045 0.295938    
## Var2-0.822431856502427:Var31.50452953702608      -0.348 0.728031    
## Var2-0.347944063287726:Var31.50452953702608      -0.969 0.332642    
## Var2-0.173424293146404:Var31.50452953702608       0.885 0.376391    
## Var2-0.0180368574391981:Var31.50452953702608      0.484 0.628118    
## Var20.845778159555612:Var31.50452953702608       -0.324 0.745734    
## Var21.22935568635659:Var31.50452953702608        -0.628 0.530143    
## Var21.24934879917613:Var31.50452953702608        -0.383 0.701972    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 5113.64  on 999  degrees of freedom
## Residual deviance:  732.22  on 729  degrees of freedom
## AIC: 3259.1
## 
## Number of Fisher Scoring iterations: 6
```

```r
# this is completely wrong
anova(fit1)
```

```
## Analysis of Deviance Table
## 
## Model: binomial, link: logit
## 
## Response: y/10
## 
## Terms added sequentially (first to last)
## 
## 
##           Df Deviance Resid. Df Resid. Dev
## NULL                        999     5113.6
## Var1       9  1502.25       990     3611.4
## Var2       9  1701.53       981     1909.9
## Var3       9   958.25       972      951.6
## Var1:Var2 81    72.51       891      879.1
## Var1:Var3 81    79.18       810      799.9
## Var2:Var3 81    67.71       729      732.2
```

```r
# not much better
library(car)

Anova(fit1, type = "III")
```

```
## Analysis of Deviance Table (Type III tests)
## 
## Response: y/10
##           LR Chisq Df Pr(>Chisq)    
## Var1        94.808  9  < 2.2e-16 ***
## Var2        85.205  9  1.484e-14 ***
## Var3        43.824  9  1.521e-06 ***
## Var1:Var2   74.127 81     0.6926    
## Var1:Var3   80.940 81     0.4810    
## Var2:Var3   67.705 81     0.8542    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
library(lme4)
fit <- glmer(y/10 ~ 1 + (1|Var1) + (1|Var2) + (1|Var3) + (1|Var1:Var2) + (1|Var1:Var3) + (1|Var2:Var3), data = df, family = binomial, weights = rep(10, nrow(df)) )
```

```
## boundary (singular) fit: see ?isSingular
```

```r
summary(fit)
```

```
## Generalized linear mixed model fit by maximum likelihood (Laplace
##   Approximation) [glmerMod]
##  Family: binomial  ( logit )
## Formula: 
## y/10 ~ 1 + (1 | Var1) + (1 | Var2) + (1 | Var3) + (1 | Var1:Var2) +  
##     (1 | Var1:Var3) + (1 | Var2:Var3)
##    Data: df
## Weights: rep(10, nrow(df))
## 
##      AIC      BIC   logLik deviance df.resid 
##   3123.1   3157.5  -1554.6   3109.1      993 
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -3.8999 -0.6617  0.0257  0.6644  3.8430 
## 
## Random effects:
##  Groups    Name        Variance Std.Dev.
##  Var2:Var3 (Intercept) 0.0000   0.0000  
##  Var1:Var3 (Intercept) 0.0000   0.0000  
##  Var1:Var2 (Intercept) 0.0000   0.0000  
##  Var3      (Intercept) 0.6784   0.8237  
##  Var2      (Intercept) 1.2945   1.1378  
##  Var1      (Intercept) 1.3541   1.1637  
## Number of obs: 1000, groups:  
## Var2:Var3, 100; Var1:Var3, 100; Var1:Var2, 100; Var3, 10; Var2, 10; Var1, 10
## 
## Fixed effects:
##             Estimate Std. Error z value Pr(>|z|)
## (Intercept)  -0.1257     0.5774  -0.218    0.828
## convergence code: 0
## boundary (singular) fit: see ?isSingular
```

```r
# there is also an option on lmerTest to do an ANOVA-type table for REs https://rdrr.io/cran/lmerTest/man/ranova.html, but not for glmer
```

