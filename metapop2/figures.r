
######################
# Figure 1
######################

# Dispersal parameters
alpha = 5

# Total patch area
A = 100

dev.new(width = 16, height = 8)
par(mfrow = c(1,2),mar = c(5,6,2,1))

# Scenario 1 : 1000 patches
N1 = 1000
a1 = numeric(N1)+A/N1
xy1 = cbind(runif(N1,0,100), runif(N1, 0, 100))
plot(xy1[,1], xy1[,2], xlab = "X", ylab = "Y", pch = 19)

# Scenario 2 : 10 patches
N2 = 10
a2 = numeric(N2)+A/N2
xy2 = cbind(runif(N2,0,100), runif(N2, 0, 100))
plot(xy2[,1], xy2[,2], xlab = "X", ylab = "Y", pch = 1, cex = 5)

dev.copy2pdf(file = "Figs/figure1.pdf")

######################
# Figure 2
######################

# Sequence of patch number 
Nseq = seq(10,100,10)
res = length(Nseq)

for(i in 1:length(Nseq)) {
    a = numeric(Nseq[i])+A/Nseq[i]
    xy = cbind(runif(Nseq[i],0,100), runif(Nseq[i], 0, 100))
    d = exp(-alpha*as.matrix(dist(xy)))
    M = diag(a)%*%d * d%*%diag(a)    
    res[i] = eigen(M)$values[1]
}

dev.new(width = 8, height = 7)
par(mar = c(5,6,2,1))
plot(Nseq, res, type = "l", xlab = "Number of patches", ylab = "Metapopulation capacity", cex.lab = 2, lwd = 2)
points(Nseq, res, pch = 19, cex = 2)
dev.copy2pdf(file = "Figs/figure2.pdf")

