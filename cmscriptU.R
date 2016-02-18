


setwd("/storage-home/a/ara6/STAT640")
require("Matrix")
require("lsa")
library(Matrix)
library(lsa)
library(methods)

junk <- c(1,2,3)
saveRDS(junk, "junk.RData")

print("Made it past installation")

ratings <- read.table("ratings.csv",header=TRUE,sep=",")
idmap <- read.table("IDMap.csv",header=TRUE,sep=",")
sex <- read.table("gender.csv", header=TRUE, sep=",")

print("loaded data")

# create a sparse matrix.
rmat <- sparseMatrix(i=ratings[,1],j=ratings[,2],x=ratings[,3])

print("created matrix")

# create a 10k by 10k matrix of cosine distances
# rows are user ID, columns are user ID, values are cosine distances between the two
# temporarily hashed out.  will load from saved version to decrease run time
cosmat <- matrix(NA, nrow=10000, ncol=10000)
for (i in 1:10000) {
  cosmat[i, ] <- apply(rmat, 1, cosine, x=rmat[i,])
  print(i)
}
cosmat[is.na(cosmat)] <- 0

print("finished analysis")

saveRDS(cosmat, file="cosmatrix.RData")

print("output supposedly delivered")
