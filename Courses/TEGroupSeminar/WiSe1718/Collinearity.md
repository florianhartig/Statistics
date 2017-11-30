# Colinearity
Florian Hartig  
10/26/2017  



# A regression problem with collinearity

Task: use the following code, change col and n, and observe how regression errors, CIs and various indicators of colinearity (below) behave. You should see note the following things

* Collinearity indices are largely independent of n
* Collinearity problem (regression errors) depends on on n
* Doing nothing, regression estimates can be PERFECT despite high multicolinearity and high VIF, provided we have enough data
* When n (data size) gets smaller, there is a point where the average regression error (measured as MSE) of the full model gets larger than a reduced model (predictor removed), but note that removing a predictor ALWAYS creates bias, wherease keeping all predictors in does not create bias, but only high MSE. Moreover, the model with removed predictor obviously has a completely wrong coverge (CI basically never includes the true value). 

## Regression


```r
library(car)
library(perturb)

n = 10000
col = 0.90

x1 = runif(n)
x2 = col * x1 + (1-col) * runif(n)

# note that true effect sizes are +1, -1
y = x1 - x2 + rnorm(n, sd = 0.5)

fit = lm(y ~ x1 + x2)
summary(fit)
```

```
## 
## Call:
## lm(formula = y ~ x1 + x2)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -1.90797 -0.32839 -0.00607  0.33582  1.75484 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  0.008698   0.013249   0.657    0.512    
## x1           1.064612   0.156651   6.796 1.14e-11 ***
## x2          -1.068365   0.173036  -6.174 6.91e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.5008 on 9997 degrees of freedom
## Multiple R-squared:  0.007276,	Adjusted R-squared:  0.007077 
## F-statistic: 36.63 on 2 and 9997 DF,  p-value: < 2.2e-16
```

```r
# Alternative: remove one predictor
fit2 = lm(y ~ x1 )
summary(fit2)
```

```
## 
## Call:
## lm(formula = y ~ x1)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -1.95882 -0.33010 -0.00476  0.33759  1.77092 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -0.04463    0.01006  -4.434 9.34e-06 ***
## x1           0.10343    0.01748   5.918 3.37e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.5017 on 9998 degrees of freedom
## Multiple R-squared:  0.00349,	Adjusted R-squared:  0.003391 
## F-statistic: 35.02 on 1 and 9998 DF,  p-value: 3.374e-09
```

## Colinearity indicators

### Simple correlation



```r
cor(x1, x2)
```

```
## [1] 0.9937796
```

Criteria: Correlation > 0.7 (Dormann et al. 2013)

### VIFs

From the vif help:

> If any terms in an unweighted linear model have more than 1 df, then generalized variance-inflation factors (Fox and Monette, 1992) are calculated. These are interpretable as the inflation in size of the confidence ellipse or ellipsoid for the coefficients of the term in comparison with what would be obtained for orthogonal data.



```r
vif(fit)
```

```
##       x1       x2 
## 80.63114 80.63114
```

Criteria: VIF - https://cran.r-project.org/doc/contrib/Faraway-PRA.pdf > 30, https://cran.r-project.org/doc/contrib/Faraway-PRA.pdf, An Introduction to Statistical Learning, page 101, says that VIF values above 5 or 10 indicate a problem.

### Conditioning indices

From the colldiag help:

> Colldiag is an implementation of the regression collinearity diagnostic procedures found in Belsley, Kuh, and Welsch (1980). These procedures examine the “conditioning” of the matrix of independent variables.
> 
> Colldiag computes the condition indexes of the matrix. If the largest condition index (the condition number) is large (Belsley et al suggest 30 or higher), then there may be collinearity problems. All large condition indexes may be worth investigating.
> 
> Colldiag also provides further information that may help to identify the source of these problems, the variance decomposition proportions associated with each condition index. If a large condition index is associated two or more variables with large variance decomposition proportions, these variables may be causing collinearity problems. Belsley et al suggest that a large proportion is 50 percent or more.



```r
colldiag(fit)
```

```
## Condition
## Index	Variance Decomposition Proportions
##           intercept x1    x2   
## 1   1.000 0.016     0.000 0.000
## 2   4.171 0.599     0.004 0.002
## 3  44.648 0.386     0.996 0.998
```


# Concluding thoughts 

* My view is that, for confirmatory / hypothesis testing, collinearity on target variables should be tested for, but NOT corrected, because a correction inevitably creates bias and screws up CIs and p-values --> just be more wary about results if you see high collinearity. It can be that models don't converge at all, and if they do, it may well be that standard frequentist methods for approximating CIs / p-values (quadratic approximation, t-tests) fail because we essentially have a low sample size problem with respect to separating the two predictors, so the likelihood is not normal. A fully Bayesian analysis doesn't have this problem, and should be reliable if the expected posterior correlations are correctly interpreted.

* For predictions, it has be shown that removing strongly colinear predictors can remove RMSE or AUCs (e.g. the Dormann paper) - this is in line with our observation of smaller MSE on regression coefficients. I'm not sure if anyone has tested, however, if this works better than simply run an automatic AIC model selection. My buest guess is that this is just as good, if not better.   

### Other blog post / comments 

* Really good summuary of the problem at http://psychologicalstatistics.blogspot.de/2013/11/multicollinearity-and-collinearity-in.html

* https://stat.ethz.ch/pipermail/r-help/2003-July/036756.html

* https://analysights.wordpress.com/tag/increasing-sample-size/

* Replace collinearity by micronumerosity = small sample size - http://davegiles.blogspot.de/2011/09/micronumerosity.html referencing Goldberger





