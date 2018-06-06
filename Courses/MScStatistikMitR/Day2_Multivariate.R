


# Multivariate methods ----------------------------------------------------

# famour iris dataset
# includes measurements of flower characteristics
# sepal and petal length and width
str(iris)
pairs(iris, col = iris$Species)

# Questions:
# which flowers are similar?
# how to flower characteristics correlate?
# which characteristics define a species?

# Main concepts:

# 1. unconstrained ordination: ONE large multivariate dataset, and turn it 
# so that it is simplified

# 2. constrained ordination: TWo multivariate datasets: one multivariate
# response and one multivariate explanatory dataset

# 3. cluster analysis: only ONE dataset and we clusters are generated



# Unconstrained ordination ------------------------------------------------

# Rotation: 
#  PCA  linear
#  CA unimodal

pairs(iris, col = iris$Species)
pca = prcomp(iris[, 1:4], scale = T) 
# always scale the variables
# maybe need to be transformed (log, sqrt)

summary(pca)
plot(pca)
biplot(pca)

pca$rotation
predict(pca, newdata = iris[1:5, 1:4])



# distance based methods (project the relative position of points into 
# a low dimensional space)

# PCoA --> linear
# NMDS nonmetric multidimensional scaling (rank-based, robust)

library(vegan)

# look for help in the vignette
browseVignettes("vegan")

# community data for plants in dunes
data(dune)
summary(dune)

NMDS = metaMDS(dune)
stressplot(NMDS)

ordiplot(NMDS, type = "t")



# Constrained ordination --------------------------------------------------

# RDA redundancy analysis -> linear
# Cononical correspondence analysis (CCA) -> unimodal, sensitive outliers

data(dune) # community data = species composition
data(dune.env) # evironment for the sites

View(dune.env)

RDA = rda(dune ~ as.numeric(Manure) + as.numeric(Moisture), data = dune.env)
plot(RDA)



# Clustering --------------------------------------------------------------


# hierarchical clustering
# based on distance, different distance methods are available
dist(iris[1:3, 1:4])

# if the range of the variables differ, you should scale the variables scale()
HC = hclust(dist(iris[, 1:4]))
plot(HC)

# to put color to the dendrogram, use package ape
library(ape)
plot(as.phylo(HC), tip.color = as.numeric(iris$Species))

plot(as.phylo(HC), tip.color = as.numeric(iris$Species), type = "fan")


# another dataset animal features
library(cluster)
data(animals)
View(animals)

# lets try two methods
aa.a = agnes(animals, method = "average")
aa.ga = agnes(animals, method = "gaverage")

op = par(mfcol = 1:2, cex.main = 0.8)
plot(aa.a, which.plots = 2)
plot(aa.ga, which.plots = 2)



# not-hierarchical

# clusters are built directly
# k-means clustering

set.seed(123) # clustering depends on starting values, with the same seed
# we get the same result

cl = kmeans(iris[, 1:4], centers = 3)
cl

# recoding the species code = to get the same color
temp = cl$cluster
temp[cl$cluster == 2] = 3
temp[cl$cluster == 3] = 2

pairs(iris[1:4], col = iris$Species)
pairs(iris[1:4], col = temp)

# vector for correct species identification
wrong = temp != as.numeric(iris$Species)
pairs(iris[, 1:4], col = as.numeric(wrong) + 1)



# Exercise ----------------------------------------------------------------

data = read.table(file = "http://evol.bio.lmu.de/_statgen/Multivariate/11SS/
                  RIKZGroups.txt",
                  header = T)
head(data)

# environment: columns 7:16
# species: columns 2:5

# unconstrained ordination: only env and only species data
# constrained ordination: both datasets
# clustering?

# try this app
# https://zdealveindy.shinyapps.io/uncordi/

env = data[, 7:16]
spe = data[, 2:5]

plot(prcomp(env, scale = T))
biplot(prcomp(env, scale = T), choices = c(2, 3))

plot(prcomp(spe, scale = T))
biplot(prcomp(spe, scale = T))

RDA = rda(spe ~ ., data = env) # one wouldnt use ALL environmental variables (see vegan help)
RDA = rda(spe ~ humus + grainsize, data = env) 
plot(RDA)



# Attention: a PCA always gives a result ----------------------------------

set.seed(123)
data$random = rnorm(n = nrow(data))

pca = prcomp(data[, c(7:16, 18)], scale=T)
biplot(pca)

# there is no test behind!
