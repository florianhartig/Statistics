# Job Applications
Florian Hartig  
4 Jan 2017  

Problem / data from https://dynamicecology.wordpress.com/2017/01/04/you-cant-tell-much-about-your-odds-of-getting-an-interview-for-a-faculty-position-from-common-quantitative-metrics/

## Reading in data 


```r
jobApplications <- read.csv2("jobApplications.csv")
str(jobApplications)
```

```
## 'data.frame':	72 obs. of  20 variables:
##  $ applicant.id                    : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ area.of.specialization          : Factor w/ 52 levels "Applied behavioural ecology/conservation",..: 14 3 8 28 39 17 1 10 19 20 ...
##  $ current.position                : Factor w/ 20 levels "adjunct research faculty",..: 12 10 14 14 14 1 14 14 18 11 ...
##  $ PhD.year                        : int  2016 2016 2012 2015 2013 2010 2014 2014 2007 2017 ...
##  $ years.in.postdoc                : num  0.5 0.5 4 1 3 5 2 2 9 0 ...
##  $ first.authored.papers           : int  13 7 18 8 9 11 7 7 29 9 ...
##  $ total.papers                    : int  18 18 24 15 17 14 9 16 42 19 ...
##  $ h.index                         : int  7 8 10 5 7 8 4 6 13 9 ...
##  $ number.of.grants.exceeding.100K : int  0 1 1 2 2 0 3 1 1 2 ...
##  $ classes.taught.not.as.TA        : int  2 1 2 1 1 1 1 1 2 3 ...
##  $ gender                          : Factor w/ 2 levels "F","M": 2 2 1 2 2 2 1 1 2 2 ...
##  $ ethnicity                       : Factor w/ 4 levels "Asian","Hispanic",..: 4 4 4 4 4 NA 4 4 4 4 ...
##  $ number.of.applications          : int  10 14 35 6 28 12 7 30 NA NA ...
##  $ number.of.phone.skype.interviews: int  1 1 2 1 2 0 1 1 0 0 ...
##  $ number.of.on.campus.interviews  : int  0 0 2 1 1 0 1 1 0 0 ...
##  $ X                               : logi  NA NA NA NA NA NA ...
##  $ X.1                             : logi  NA NA NA NA NA NA ...
##  $ X.2                             : logi  NA NA NA NA NA NA ...
##  $ X.3                             : logi  NA NA NA NA NA NA ...
##  $ X.4                             : logi  NA NA NA NA NA NA ...
```


## Preparing data



```r
# using MICE data imputation because of the many NAs in the number.of.applications 
library(mice)
jobApplications$number.of.applicationsI = complete(mice(jobApplications[,13:15], print=FALSE))[,1] 

# preparing data for proportional glm (R convention is success / failure)
jobApplications$success = cbind(jobApplications$number.of.phone.skype.interviews, jobApplications$number.of.applicationsI - jobApplications$number.of.phone.skype.interviews)
```

## Analysis



```r
m1 = glm(success ~ total.papers + gender + number.of.grants.exceeding.100K + h.index + classes.taught.not.as.TA, family = binomial,  data = jobApplications, na.action = "na.exclude")
summary(m1)
```

```
## 
## Call:
## glm(formula = success ~ total.papers + gender + number.of.grants.exceeding.100K + 
##     h.index + classes.taught.not.as.TA, family = binomial, data = jobApplications, 
##     na.action = "na.exclude")
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.0742  -1.0093  -0.4467   0.3443   2.4126  
## 
## Coefficients:
##                                 Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                     -2.71551    0.35292  -7.694 1.42e-14 ***
## total.papers                    -0.01187    0.03131  -0.379    0.705    
## genderM                         -0.27050    0.26422  -1.024    0.306    
## number.of.grants.exceeding.100K -0.14350    0.16990  -0.845    0.398    
## h.index                          0.04848    0.06195   0.783    0.434    
## classes.taught.not.as.TA         0.03615    0.03961   0.913    0.361    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 76.261  on 66  degrees of freedom
## Residual deviance: 72.381  on 61  degrees of freedom
##   (5 observations deleted due to missingness)
## AIC: 155.88
## 
## Number of Fisher Scoring iterations: 5
```

```r
library(effects)
plot(allEffects(m1))
```

![](JobApplications_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

