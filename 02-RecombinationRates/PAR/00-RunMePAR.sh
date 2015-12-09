# Pipeline to Identify SNPs between parent strains
# TDH Dec 8th, 2015

# TO RUN...
# 1) (OPT) create a new directory and cd into it as in
mkdir 00-PAR && cd $_
# 2) You will need to specify the directory locations for DATA and for Scripts (see USER DEFINED PARAMETERS below)
# 3) Run this script

# USER DEFINED PARAMETERS:
# Where are the data stored?
export DATA="/mnt/home/uirig/miseq/CASAVA/130816_M01380_0038_000000000-A4NB3/Split/Project_000000000-A4NB3/" # Your path will likely be different than this
# Where are the scripts stored?
export SCRIPTS="/mnt/home/heth8145/Scripts" # thse scripts can be obtained from https://github.com/tylerhether/Scripts
# What the maximum number of processors to use?
export PROCESSORS=14

# Make symbolic links to the data
mkdir 00-RawData
cd ./00-RawData
ln -s "$DATA"/Sample_17 ./ # S163 = YPS128
ln -s "$DATA"/Sample_18 ./ # S164 = DBVPG1106
cd ../

# Count the raw read data for each of the samples:
for file in $(ls 00-RawData/Sample_*/*R1*); do echo $file;  tmp=$(zcat $file | wc -l); echo $((tmp/4)); done
# 2681437 + 2993446 = 5674883
# For a breakdown of the raw reads per sample also see preproc_experiment_report.txt when it is generated.

# Now clean the samples with seqyclean
git clone https://github.com/ibest/GRC_Scripts.git 01-seqyclean # Pulls in seqyclean for github
cd ./01-seqyclean
perl -pi -e 's/\"preproc_report/\".\/preproc_report/g' preproc_experiment.R # Modifies script to play nice on some systems
perl -pi -e 's/oflash\+5/oflash\+3/g' preproc_report # for specific version of flash
perl -pi -e 's/oflash\+5/oflash\+4/g' preproc_report # for specific version of flash
chmod 777 *
nohup ./preproc_experiment.R -f "$SCRIPTS"/02-RecombinationRates/PAR/samples.txt -d ../00-RawData/ -q 10 -m 150 -p $PROCESSORS &
mv ./02* ../ # Move seqyclean output up to the parent directory
cd ../

# Aligned mereged single end data and unmerged paired-end data to the s288c reference for each sample
mkdir 03-Alignments && cd $_
"$SCRIPTS"/02-RecombinationRates/PAR/03-RunAlignment.sh
cd ../

# Discover SNPs between the two parents (S163 and S164).
mkdir ./04-Parents && cd $_
cd ./04-Parents

ln -s ../03-Alignments/S163_aligned.* ./
ln -s ../03-Alignments/S164_aligned.* ./

# Convert to BAM format:
samtools view -bS S163_aligned.se.sam > S163_aligned.se.bam
samtools view -bS S163_aligned.pe.sam > S163_aligned.pe.bam
samtools merge S163_aligned.bam S163_aligned.*bam
samtools sort S163_aligned.bam S163_aligned.sorted

samtools view -bS S164_aligned.se.sam > S164_aligned.se.bam
samtools view -bS S164_aligned.pe.sam > S164_aligned.pe.bam
samtools merge S164_aligned.bam S164_aligned.*bam
samtools sort S164_aligned.bam S164_aligned.sorted

# Create consensus sequences from s288c reference:
samtools mpileup -uf "$SCRIPTS"/reference_seq/s288c_genome.fa ./S163_aligned.sorted.bam | bcftools view -cg - | vcfutils.pl vcf2fq > YPS128_consensus.fq
samtools mpileup -uf "$SCRIPTS"/reference_seq/s288c_genome.fa ./S164_aligned.sorted.bam | bcftools view -cg - | vcfutils.pl vcf2fq > DBVPG1106_consensus.fq

# Make consensus sequences for each sample based on the s288c genome
perl "$SCRIPTS"/02-RecombinationRates/singleline.pl YPS128_consensus.fq > YPS128_consensus.fq2
perl "$SCRIPTS"/02-RecombinationRates/singleline.pl DBVPG1106_consensus.fq > DBVPG1106_consensus.fq2

# Convert consensus sequences to fasta format
perl "$SCRIPTS"/02-RecombinationRates/fq2fa.pl YPS128_consensus.fq2
perl "$SCRIPTS"/02-RecombinationRates/fq2fa.pl DBVPG1106_consensus.fq2

# Change file names for clarity
mv YPS128_consensus.fq2.fasta YPS128_consensus.fa
mv DBVPG1106_consensus.fq2.fasta DBVPG1106_consensus.fa

# Make a SNP list
nucmer --mum --prefix=YPS128_DBVPG1106 YPS128_consensus.fa DBVPG1106_consensus.fa
delta-filter -g -l 10000 YPS128_DBVPG1106.delta > YPS128_DBVPG1106_filtered.delta
show-snps -C -T -r YPS128_DBVPG1106_filtered.delta > YPS128_DBVPG1106_snps.txt

# approximate number of SNPs before filter
cat YPS128_DBVPG1106_snps.txt | wc -l # 73585

python "$SCRIPTS"/02-RecombinationRates/PAR/reformatMummerSNPlist_v2.py # check file for input/output files
python "$SCRIPTS"/02-RecombinationRates/PAR/removeMultiBaseIndels.py # check file for input/output files

# approximate number of snps after filter
cat YPS128_DBVPG1106_nomultibaseindels_snps.txt | wc -l # 73581

# Make a concise SNP list that will be used later
cat YPS128_DBVPG1106_nomultibaseindels_snps.txt | sed 's/\s\s*/ /g' | cut -d' ' -f1-2 > locilist

# Now That we have SNps, get the read counts of each parental allele for each of the samples
cd ../
mkdir 05-CallVariants && cd $_
"$SCRIPTS"/02-RecombinationRates/PAR/04-CallVariants.sh

# Trim the read counts to only include sites in the SNP list created above
cd ../
mkdir 06-TrimAndParse && cd $_
"$SCRIPTS"/02-RecombinationRates/PAR/05-TrimAndParse.sh
cd ../

# Calculate basic summary stats of the parental samples
mkdir 07-SummaryStats && cd $_
R CMD BATCH "$SCRIPTS"/02-RecombinationRates/PAR/01-AnalzyeParents.R # see Rout file for results
cd ../
# End Script
