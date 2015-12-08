# To rerun analysis, open terminal and cd into directory. 
# Type: 

# If you want to rerun the digest:
./01-FindREsites.sh

# From the output make the dataframe like 01-DataREsites.R. This is clunky but works. 

# To find the number of snps within a given size of each site given the list of 
# snps between the two strains, run the following command: 

R CMD BATCH 02-AnalyzeREsites2.R

