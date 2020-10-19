# Microbial-graph project  
## Process data from .biom to tsv  
ref: [emp repo](https://github.com/biocore/emp/tree/master/code/08-cooccurrence-nestedness/cooccurrence-network)  
1. install ruby (the emp repo use ruby to convert .biom to tsv)  
2. run "run.sh" under src/  
- run.sh is a bash script, we can edit it accordingly. eg. change the BIOM, or change the MAP file name. If we use the same ones, then no need to change.  
- I commented out the line that computes OTU co-occurence network in run.sh, because I think we can use our own ways(eg. vsp or others to calculate. I tried out vsp, and it worked^^)  
3. within your folder, you'll see several files after run.sh finish (here are the resulting files if BIOM=emp_deblur_90bp.subset_2k.rare_5000.biom): column_metadata.txt, emp_deblur_90bp.subset_2k.rare_5000.biom.json, emp_deblur_90bp.subset_2k.rare_5000.biom.SUMMARY.txt, otu-co-occurrence-network-z20.csv, otu_sample_value.txt, row_metadata.txt. If you also comment out the line for otu_cooccurrence_network calculation, there won't be otu-co-occurrence-network-z20.csv, but feel free to play aruond!)  
