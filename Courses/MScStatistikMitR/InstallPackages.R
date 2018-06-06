# This code is required only when working in the CIP pool! 
# Installed packages get deleted each time you log off.

# On your own laptop, you have to install packages only once
# Afterwards, you only have to load them with the library function.

# EcoDat Package that holds all datasets for the course
install.packages("devtools")
library(devtools)
devtools::install_github(repo = "TheoreticalEcology/EcoData", subdir = "EcoData", dependencies = T, build_vignettes = T)

# packages for working with Rmarkdown
install.packages("rmarkdown")
install.packages("formatR")
install.packages("caTools")

# Day 1
install.packages("readr")
install.packages("rgbif")

# Day 2
install.packages("ape")
install.packages("cluster")
install.packages("vegan")
install.packages("fdrtool")

# Day 3
install.packages("fitdistrplus")
install.packages("effects")

# Day 4
install.packages("DHARMa")
install.packages("AER")
install.packages("MuMIn")
install.packages("MASS")

# Day 5
install.packages("randomForest")
install_github("araastat/reprtree")
library(reprtree)
install.packages("forestFloor")
install.packages("dismo")
install.packages("GRaF")
install.packages("mgcv")
install.packages("gbm")
install.packages("pROC")
install.packages("lme4")
install.packages("lattice")
install.packages("lmerTest")






