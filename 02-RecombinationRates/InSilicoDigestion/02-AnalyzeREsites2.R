#1/usr/bin/R
# August 1st, 2014
# TDH
#Analyze the number of restriction sites within x basepairs of a snp. 
rm(list=ls())
# read in the raw data: 
source("01-DataREsites.R")
library(dplyr)

# Format data: 

dat <- rbind(
	data.frame(chr=rep(1, length(chrI.NsiI)), RE=rep("NsiI", length(chrI.NsiI)), pos=chrI.NsiI),
	data.frame(chr=rep(2, length(chrII.NsiI)), RE=rep("NsiI", length(chrII.NsiI)), pos=chrII.NsiI),
	data.frame(chr=rep(3, length(chrIII.NsiI)), RE=rep("NsiI", length(chrIII.NsiI)), pos=chrIII.NsiI),
	data.frame(chr=rep(4, length(chrIV.NsiI)), RE=rep("NsiI", length(chrIV.NsiI)), pos=chrIV.NsiI),
	data.frame(chr=rep(5, length(chrV.NsiI)), RE=rep("NsiI", length(chrV.NsiI)), pos=chrV.NsiI),
	data.frame(chr=rep(6, length(chrVI.NsiI)), RE=rep("NsiI", length(chrVI.NsiI)), pos=chrVI.NsiI),
	data.frame(chr=rep(7, length(chrVII.NsiI)), RE=rep("NsiI", length(chrVII.NsiI)), pos=chrVII.NsiI),
	data.frame(chr=rep(8, length(chrVIII.NsiI)), RE=rep("NsiI", length(chrVIII.NsiI)), pos=chrVIII.NsiI),
	data.frame(chr=rep(9, length(chrIX.NsiI)), RE=rep("NsiI", length(chrIX.NsiI)), pos=chrIX.NsiI),
	data.frame(chr=rep(10, length(chrX.NsiI)), RE=rep("NsiI", length(chrX.NsiI)), pos=chrX.NsiI),
	data.frame(chr=rep(11, length(chrXI.NsiI)), RE=rep("NsiI", length(chrXI.NsiI)), pos=chrXI.NsiI),
	data.frame(chr=rep(12, length(chrXII.NsiI)), RE=rep("NsiI", length(chrXII.NsiI)), pos=chrXII.NsiI),
	data.frame(chr=rep(13, length(chrXIII.NsiI)), RE=rep("NsiI", length(chrXIII.NsiI)), pos=chrXIII.NsiI),
	data.frame(chr=rep(14, length(chrXIV.NsiI)), RE=rep("NsiI", length(chrXIV.NsiI)), pos=chrXIV.NsiI),
	data.frame(chr=rep(15, length(chrXV.NsiI)), RE=rep("NsiI", length(chrXV.NsiI)), pos=chrXV.NsiI),
	data.frame(chr=rep(16, length(chrXVI.NsiI)), RE=rep("NsiI", length(chrXVI.NsiI)), pos=chrXVI.NsiI),

	data.frame(chr=rep(1, length(chrI.PstI)), RE=rep("PstI", length(chrI.PstI)), pos=chrI.PstI),
	data.frame(chr=rep(2, length(chrII.PstI)), RE=rep("PstI", length(chrII.PstI)), pos=chrII.PstI),
	data.frame(chr=rep(3, length(chrIII.PstI)), RE=rep("PstI", length(chrIII.PstI)), pos=chrIII.PstI),
	data.frame(chr=rep(4, length(chrIV.PstI)), RE=rep("PstI", length(chrIV.PstI)), pos=chrIV.PstI),
	data.frame(chr=rep(5, length(chrV.PstI)), RE=rep("PstI", length(chrV.PstI)), pos=chrV.PstI),
	data.frame(chr=rep(6, length(chrVI.PstI)), RE=rep("PstI", length(chrVI.PstI)), pos=chrVI.PstI),
	data.frame(chr=rep(7, length(chrVII.PstI)), RE=rep("PstI", length(chrVII.PstI)), pos=chrVII.PstI),
	data.frame(chr=rep(8, length(chrVIII.PstI)), RE=rep("PstI", length(chrVIII.PstI)), pos=chrVIII.PstI),
	data.frame(chr=rep(9, length(chrIX.PstI)), RE=rep("PstI", length(chrIX.PstI)), pos=chrIX.PstI),
	data.frame(chr=rep(10, length(chrX.PstI)), RE=rep("PstI", length(chrX.PstI)), pos=chrX.PstI),
	data.frame(chr=rep(11, length(chrXI.PstI)), RE=rep("PstI", length(chrXI.PstI)), pos=chrXI.PstI),
	data.frame(chr=rep(12, length(chrXII.PstI)), RE=rep("PstI", length(chrXII.PstI)), pos=chrXII.PstI),
	data.frame(chr=rep(13, length(chrXIII.PstI)), RE=rep("PstI", length(chrXIII.PstI)), pos=chrXIII.PstI),
	data.frame(chr=rep(14, length(chrXIV.PstI)), RE=rep("PstI", length(chrXIV.PstI)), pos=chrXIV.PstI),
	data.frame(chr=rep(15, length(chrXV.PstI)), RE=rep("PstI", length(chrXV.PstI)), pos=chrXV.PstI),
	data.frame(chr=rep(16, length(chrXVI.PstI)), RE=rep("PstI", length(chrXVI.PstI)), pos=chrXVI.PstI))

snp_list <- read.table("./YPS128_DBVPG1106_nomultibaseindels_snps.txt", header=FALSE)
snps <- snp_list[,-c(3,4,6,8,9,10)]; colnames(snps) <- c("chr", "snp", "y", "d")
library(plyr); library(dplyr); snps <- filter(snps, chr!="MT"); dim(snps)

snps <- snps[,c(1:3)]

# snps <- read.table("./SNP_SEQ_Y", header=FALSE)
colnames(snps) <- c("chr", "snp", "seq")
# filter out the mtDNA
# snps <- filter(snps, chr!="MT")

snps[,1] <- sapply(snps[,1], function(x){
	if(x=="I"){
		return(1)
	}
		if(x=="II"){
		return(2)
	}
		if(x=="III"){
		return(3)
	}
		if(x=="IV"){
		return(4)
	}
		if(x=="V"){
		return(5)
	}
		if(x=="VI"){
		return(6)
	}
		if(x=="VII"){
		return(7)
	}
		if(x=="VIII"){
		return(8)
	}
		if(x=="IX"){
		return(9)
	}
		if(x=="X"){
		return(10)
	}
		if(x=="XI"){
		return(11)
	}
		if(x=="XII"){
		return(12)
	}
		if(x=="XIII"){
		return(13)
	}
		if(x=="XIV"){
		return(14)
	}
		if(x=="XV"){
		return(15)
	}
		if(x=="XVI"){
		return(16)
	}

	})


# The above code is upwards biased: if two REs occur within dist bp from one another their snps are doubly counted: 
# Adjust so that non-redundant snps are only considered. 

# We consider 300bp paired end sequencing on both sides of a given restriction site.
# Let's assume that we have no overlap and no gaps (i.e., only 300+300bps)
snps$bp600 <- rep(0, dim(snps)[1])

dist <- 600 # 300PE 

# There are, of course, faster ways to do this...
for(x in 1:dim(dat)[1]){
	tmp_range <- (dat[x,3]-dist):(dat[x,3]+dist)
	tmp_snps <- filter(snps, chr==dat[x,1])$snp
	# Return the snps within dist range of the restriction enzyme cut site
	tmp_hits <- filter(snps, chr==dat[x,1])[which(tmp_snps %in% tmp_range),]
	# If snps occur, add the count to the snps master dataframe:
	if(dim(tmp_hits)[1]>0){
		for(y in 1:(dim(tmp_hits)[1])){
			snps[which(snps[,1]==tmp_hits[y,1] & snps[,2]==tmp_hits[y,2]),"bp600"] <- snps[which(snps[,1]==tmp_hits[y,1] & snps[,2]==tmp_hits[y,2]),"bp600"] + 1
			}
	}

}

# So how many cut sites do we expect? 
ddply(dat, .(RE), dim)
#     RE   V1 V2
# 1 NsiI 3543  3
# 2 PstI 2523  3
dim(dat)[1] # ... total
#[1] 6066


# So how many snps do we estimate to be within 1200bp around each cut size? 
dim(filter(snps, bp600>0))[1]
#[1] 33983

















