
# Raw data in 00-RawData
# Scripts (including this file) are in 00-Scripts/
# GFC Scripts in 00-Scripts/GRC_Scripts


# To get the raw line numbers (i.e., reads *4) for this run: 
cd ../00-RawData
for sample in $(ls ./); do echo "$sample" $(zgrep -Ec "$" $sample/*R1*); done
cd ../00-Scripts

# To begin, run seqyclean to demultiplex, quality filter, and flash
cd /mnt/home/heth8145/02-Recombination_Rates/00-WGS_Q10/00-Scripts/GRC_Scripts

# Preprocess data
./preproc_experiment.R -f ../samples.txt -d ../../00-RawData -q 10 -m 150 -p 14 

# Move output
mv 0* ../../


# Aligned mereged, single end data to the s288c reference for all samples
cd ../../
mkdir 03-Alignments
cd 03-Alignments
nohup ../00-Scripts/03-RunAlignment.sh & 


# Discover snps between the two parents (S163 and S164). 
# ^ ^ ^ This step can be done while the 03-RunAlignment.sh script is running.
    mkdir ../04-Parents

    cp -r S163* ../04-Parents/ & 
    cp -r S164* ../04-Parents/ & 

    cd ../04-Parents

    # Convert to BAM format:
    samtools view -bS S163_aligned.sam > S163_aligned.bam & 
    samtools view -bS S164_aligned.sam > S164_aligned.bam

    # Convert to sorted BAM format:
    samtools sort S163_aligned.bam S163_aligned.sorted & 
    samtools sort S164_aligned.bam S164_aligned.sorted

    # Create consensus sequences from s288c reference:
    samtools mpileup -uf ../s288c_genome.fa ./S163_aligned.sorted.bam | bcftools view -cg - | vcfutils.pl vcf2fq > YPS128_consensus.fq &
    samtools mpileup -uf ../s288c_genome.fa ./S164_aligned.sorted.bam | bcftools view -cg - | vcfutils.pl vcf2fq > DBVPG1106_consensus.fq &

    # Make a SNPlist 
    perl ../00-Scripts/singleline.pl YPS128_consensus.fq > YPS128_consensus.fq2 
    perl ../00-Scripts/singleline.pl DBVPG1106_consensus.fq > DBVPG1106_consensus.fq2
    
    # Convert to fasta format
    perl ../00-Scripts/fq2fa.pl YPS128_consensus.fq2 
    perl ../00-Scripts/fq2fa.pl DBVPG1106_consensus.fq2

    # Change file names
    mv YPS128_consensus.fq2.fasta YPS128_consensus.fa
    mv DBVPG1106_consensus.fq2.fasta DBVPG1106_consensus.fa

    nucmer --mum --prefix=YPS128_DBVPG1106 YPS128_consensus.fa DBVPG1106_consensus.fa
    delta-filter -g -l 10000 YPS128_DBVPG1106.delta > YPS128_DBVPG1106_filtered.delta
    show-snps -C -T -r YPS128_DBVPG1106_filtered.delta > YPS128_DBVPG1106_snps.txt

    # approximate number of snps before filter
    cat YPS128_DBVPG1106_snps.txt | wc -l

    python ../00-Scripts/reformatMummerSNPlist_v2.py # check file for input/output files
    python ../00-Scripts/removeMultiBaseIndels.py # check file for input/output files

    # approximate number of snps after filter
    cat YPS128_DBVPG1106_nomultibaseindels_snps.txt | wc -l

    # Make a concise loci list that will be used later
    cat YPS128_DBVPG1106_nomultibaseindels_snps.txt | sed 's/\s\s*/ /g' | cut -d' ' -f1-2 > locilist
    
    # Number of snps after filtering mtDNA and plasmid: 
    grep -c -e ^I -e ^X -e ^V locilist 
    # 72926

# Now That we have snps, get the read counts of each parental allele for each of the samples
cd ../
mkdir 04-CallVariants
cd ./04-CallVariants
nohup ../00-Scripts/04-CallVariants.sh & 

# Trim loci to loci list
cd ../
mkdir 05-TrimAndParse
cd ./05-TrimAndParse
nohup ../00-Scripts/05-TrimAndParse.sh & 

# ^ ^ ^ Data are now ready to run in HmmAncestry 









