###test

par(mfcol=c(2, 2))
x = rnorm(100)
y = rnorm(100)

plot(x, y)
plot(rank(x), rank(y))

x = c(rnorm(99), 10)
y = c(rnorm(99), 10)

plot(x, y)
plot(rank(x), rank(y))





hist(x, freq = F, breaks = 20)
lines(density(x))
