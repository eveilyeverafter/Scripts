#!/usr/bin/env Rscript

# Calculate basic summary stats of the parental strains


Y <- read.table("../06-TrimAndParse/S163_Ycounts.txt", sep=";")
D <- read.table("../06-TrimAndParse/S164_Ycounts.txt", sep=";")

Y$Total <- Y[,3] + Y[,4] + Y[,5] + Y[,6]
D$Total <- D[,3] + D[,4] + D[,5] + D[,6]


YmenaCoverage <- mean(Y$Total)
DmeanCoverage <- mean(D$Total)

YmenaCoverage
DmeanCoverage

 mean(c(YmenaCoverage, DmeanCoverage))

 