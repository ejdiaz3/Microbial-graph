rm(list=ls())

infile = "otu_sample_value.txt"


library(Matrix)
library(vsp)
library(dplyr)
library(tidyverse)
library(tidytext)
library(tm)
library(factoextra)

d = read.table(infile, header=T, sep="\t", colClasses=c(rep("character", 2), "numeric"))
otus = read.table("row_metadata.txt", header=T, sep="\t", colClasses=rep("character", 9))
samples = read.table("column_metadata.txt", header=T, sep="\t", colClasses=rep("character", 2))

# extract row / column indices
I = as.integer(gsub("otu_", "", d$OTU)) + 1        # add 1 to convert 0-index to 1-index
J = as.integer(gsub("sample_", "", d$SAMPLE)) + 1  # add 1 to convert 0-index to 1-index

# sparse OTU matrix
X = sparseMatrix(i=I, j=J, x=d$VALUE)
rownames(X) = otus$ID
colnames(X) = samples$ID

# sparse bipartitie adjacency matrix
## detect entries that are larger than 0, and then encode these non-zero entries as 1
## so, now, if otu_i appears in sample_j, it'll just show 1, regardless of how many times otu_i appeared in sample_j
Y = (X > 0) * 1
#save(Y,file="otu_sample_bipar_adj.RData")

# We need to pick a managable number of OTUs to manipulate the OTU co-occurrence network
# using the code here.

# Pick OTUs that belong to a few prominent phyla
selected.otus = rbind(
  subset(otus, otus$PHYLUM == "p__Proteobacteria", ID),
  subset(otus, otus$PHYLUM == "p__Bacteroidetes", ID),
  subset(otus, otus$PHYLUM == "p__Firmicutes", ID)
)
idx = as.numeric(row.names(selected.otus))
Z = Y[idx,]  # otu-sample adjacency matrix

# Pick OTUs with prevalence of at least 10 samples
idx = rowSums(Z) > 9
Z = Z[idx,]  # otu-sample adjacency matrix

# Order matrix rows by prevalence, high to low
o = order(rowSums(Z), decreasing=T)
Z = Z[o,]
prevalence = rowSums(Z)  # handy to use this later
## dim(Y) #155002*2000 (before subsetting)
## dim(Z) #8263*2000 (after subsetting)

# try vsp on the subset of interest
library(vsp)
fa<-vsp(Z, rank=40)
plot_varimax_z_pairs(fa,1:20)#row(otu)
plot_varimax_y_pairs(fa,1:10)#colum(sample)
screeplot(fa)


# enviromental data input 
env = read.table("meta.txt", header=T, sep="\t")
env$X.SampleID <- as.character(env$X.SampleID) 
env = env %>% rename(SAMPLE = X.SampleID) #change calum name to merge with sample
env <- merge(samples, env, by ="SAMPLE") # merge to have sample ID name. This will make it more comparable to the previous data

## Example for biomes - this one have less levels and more samples are represented by level
dt = cast_sparse(env, ID, env_biome)
cs = colSums(dt)
table(cs[cs<20])
dt = dt[,cs>3]
#  Here we will use the bff function to contextualize clusters.  
biomes = bff(fa$Y, dt,20) %>% t 
biomes %>% t %>% View


## Example for features - this one have more levels and less samples are represented by level.
## Maybe more interesting information? 
dt = cast_sparse(env, ID, env_feature)
cs = colSums(dt)
table(cs[cs<20])
dt = dt[,cs>3]
# The bbf
features = bff(fa$Y, dt,20) %>% t 
features %>% t %>% View

