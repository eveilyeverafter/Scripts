# August 1st, 2014
# T. Hether
# Find the number and location of the restriction sites for a given genome. 

# REQUIRES biopieces (https://code.google.com/p/biopieces/)
# Reference: http://codextechnicanum.blogspot.com/2013/07/in-silico-restriction-digest-and.html

# Code to extract the RE sites: 
read_fasta -i YPS128_consensus.fa | transliterate_seq -s 'Nn' -r 'aa' | rescan_seq -r PstI,NsiI -o > REsitesYPS.txt
read_fasta -i DBVPG1106_consensus.fa | transliterate_seq -s 'Nn' -r 'aa' | rescan_seq -r PstI,NsiI -o > REsitesDBVPG.txt


# The chromosome order is given by this command: 
read_fasta -i YPS128_consensus.fa | transliterate_seq -s 'Nn' -r 'aa' | rescan_seq -r PstI,NsiI | grep 'SEQ_NAME'

# Now you can import these data into R for analysis. 
# Note: you need to trim the output since the snps files omit the 2-micron plasmid and the mt genome: 
cat SNP_SEQ_Y | cut -d' ' -f 1 | uniq
