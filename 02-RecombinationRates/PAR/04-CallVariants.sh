#!/bin/bash
# CallVariants.sh
# May 7th, 2015

 ls ../02-Cleaned/ > ../samples


    count=0
    NR_CPUS=12
    while read line 
        do 
     	set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Running mpileup on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        samtools view -bS ../03-Alignments/"$line"_aligned.se.sam > "$line"_aligned.se.bam
        samtools view -bS ../03-Alignments/"$line"_aligned.pe.sam > "$line"_aligned.pe.bam
        samtools merge "$line"_aligned.bam "$line"_aligned.*bam
        samtools sort "$line"_aligned.bam "$line"_aligned.sorted
        samtools mpileup -I -uf ../04-Parents/YPS128_consensus.fa ./"$line"_aligned.sorted.bam 2> stderr.txt  | bcftools view -b - > "$line"_Yvar.raw.bcf & 
        if [ $(grep -n $line ../samples | cut -d: -f 1) -ge $(cat ../samples | wc -l) ]
        then
            samtools mpileup -I -uf ../04-Parents/DBVPG1106_consensus.fa ./"$line"_aligned.sorted.bam  2> stderr.txt  | bcftools view -b - > "$line"_Dvar.raw.bcf
            #echo "yes"
        else
            #echo "no"
            samtools mpileup -I -uf ../04-Parents/DBVPG1106_consensus.fa ./"$line"_aligned.sorted.bam  2> stderr.txt  | bcftools view -b - > "$line"_Dvar.raw.bcf &
        fi
        let count+=2
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < ../samples



# Filter reads so that they are within the range [0,100]. 

    # count=0

    # while read line
    #     do
    #     set 'echo $line'
    #     echo '~~~~~~~~~~~~~~~~~~~~  Running mpileup on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
    #     bcftools view "$line"_Yvar.raw.bcf | vcfutils.pl varFilter -D 100 -d 0 > "$line"_Yvar.flt.vcf &
    #     if [ $(grep -n $line ../samples | cut -d: -f 1) -ge $(cat ../samples | wc -l) ]
    #         then
    #             bcftools view "$line"_Dvar.raw.bcf | vcfutils.pl varFilter -D 100 -d 0 > "$line"_Dvar.flt.vcf & 
    #         else
    #             bcftools view "$line"_Dvar.raw.bcf | vcfutils.pl varFilter -D 100 -d 0 > "$line"_Dvar.flt.vcf &
    #     fi
    #     let count+=2
    #     [[ $((count%NR_CPUS)) -eq 0 ]] && wait
    # done < ../samples


