
# permutation t-Test
# a hand-coded randomization test for comparing two groups with arbitrary distribution 

groupA = rnorm(50)
groupB = rlnorm(50)

dat = data.frame(value = c(groupA, groupB), group = factor(rep(c("A", "B"), each = 50)))
plot(value ~ group, data = dat)

# Point here is that we can't do a t-test, because groups are not normal. We could do 

hist(dat$value, breaks = 40)

reference = mean(groupA) - mean(groupB)

nSim = 5000
nullDistribution <- rep(NA, nSim)

for(i in 1:nSim){
  sel = dat$value[sample.int(100, size = 100)]
  nullDistribution[i] = mean(sel[1:50]) - mean(sel[51:100])
}

hist(nullDistribution, xlim = c(-2,2))
abline(v = reference, col = "red")
ecdf(nullDistribution)(reference)



# Example for vegan 

library(vegan)

## Use the first eigenvalue of correspondence analysis as an index
## of structure: a model for making your own functions.
data(sipoo)
out <- oecosimu(sipoo, decorana, "swap", burnin=100, thin=10, statistic="evals")

# the function to be calculated is decorana, Detrended Correspondence Analysis and Basic Reciprocal Averaging, see ?decorana
# statistics is easy to misunderstand - it's basically the name of the slot to be used by the returned object
# see x = decorana(sipoo), str(x)

# Another example with the dune data 

data(dune)
meandist <- function(x) mean(vegdist(x, "bray"))
mbc1 <- oecosimu(dune, meandist, "r2dtable")
mbc1

## Define a custom function that shuffles
## cells in each rows
## Define your own null model as a 'commsim' function: shuffle cells
## in each row
foo <- function(x, n, nr, nc, ...) {
  out <- array(0, c(nr, nc, n))
  for (k in seq_len(n))
    out[,,k] <- apply(x, 2, function(z) sample(z, length(z)))
  out
}
cf <- commsim("myshuffle", foo, isSeq = FALSE, binary = FALSE, 
              mode = "double")
oecosimu(dune, meandist, cf)

# Example with pollination networks 

library(bipartite)


data(Safariland)
nullmodel(Safariland, N=2, method=1)
nullmodel(Safariland>0, N=2, method=4)
# analysis example:
obs <- unlist(networklevel(Safariland, index="weighted nestedness"))
nulls <- nullmodel(Safariland, N=100, method=1)
null <- unlist(sapply(nulls, networklevel, index="weighted nestedness")) #takes a while ...

plot(density(null), xlim=c(min(obs, min(null)), max(obs, max(null))), 
     main="comparison of observed with null model Patefield")
abline(v=obs, col="red", lwd=2)    

praw <- sum(null>obs) / length(null)
ifelse(praw > 0.5, 1-praw, praw)    # P-value

# comparison of null model 4 and 5 for binary:
nulls4 <- nullmodel(Safariland>0, N=100, method=4)
nulls5 <- nullmodel(Safariland>0, N=100, method=5)
null4 <- unlist(sapply(nulls4, networklevel, index="weighted nestedness"))
null5 <- unlist(sapply(nulls5, networklevel, index="weighted nestedness"))


plot(density(null4), xlim=range(c(null4, null5)), lwd=2, 
     main="comparison of null models")
lines(density(null5), col="red", lwd=2)
legend("topright", c("shuffle", "mgen"), col=c("black", "red"), lwd=c(2,2), 
       bty="n", cex=1.5)
abline(v=networklevel(Safariland>0, index="weighted nestedness"))


