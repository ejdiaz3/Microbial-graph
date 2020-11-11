---
layout: page  
title: "Vintage Sparce PCA on Earth Microbiom Project Data"  
---
In this blog post, we will apply Vintage Sparse PCA (vsp) on the microbiome data collected from the Earth Microbiome Project (EMP) to explore the microbiome patterns worldwide.  

1. Data description  
Earth Microbiome Project (EMP) uses a systematic approach to characterize microbial taxonomic and functional diversity across different environments and humankind (Thomson et al., 2017).  EMP comprises 27,751 samples from 97 studies with microbial data representing 16S rRNA amplicon sequencing, metagenomes, and metabolomics. For this blog, we used a rarefied subset data composed of 2,000 samples representing all environments and humankind microbiomes created by EMP. The dataset is divided by (1) an operational taxonomic unit (OTU) table, (2) and sample table, and (3) a metadata table. Below is the column information for each table.  

(1) OTU table: ID, Sequence, Kingdom, Phylum, Class, Order, Family, Genus, and Species.  
(2) The sample table contains ID and Sample Name.  
(3) Metadata table: 76 environmental information from each sample. For this blog, we used Sample ID, Environment Biome, and Environment Feature.  

2. Data manipulation   
The first thing we did with the data was to build an OTU-sample bipartite adjacency matrix that we named A. For this, we used the R Matrix package.  Our matrix Aij = x  was composed by OTUs as i, samples as j, and the number of OTUs observed in the sample as x. The dimensions of the A matrix was 155,002 rows and 2,000 columns. To examine the A matrix, we did a histogram and found that some OTUs were more abundant than the other, which is natural in microbial ecosystems.  

