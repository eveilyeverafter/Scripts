#!/bin/bash
# TrimAndParse.sh

# SNPLIST="../../00-First_Miseq_14_tetrads/03-Alignments/YPS128_DBVPG1106_snps.noMultiBase.reformatted.txt"
# cat $SNPLIST | sed 's/\s\s*/ /g' | cut -d' ' -f1-2 > locilist


for plate in `seq 1 4`; 
do
    cd ./Plate$plate  
        while read line
                do
                set 'echo $line'
                bcftools view -ce -l ../../../00-WGS_Q00/04-Parents/locilist ../../01-Processing/03-CallVariants/Plate"$plate"/"$line"_Yvar.raw.bcf > "$line"_Yvar.trim.vcf
                bcftools view -ce -l ../../../00-WGS_Q00/04-Parents/locilist ../../01-Processing/03-CallVariants/Plate"$plate"/"$line"_Dvar.raw.bcf  > "$line"_Dvar.trim.vcf   
        done < ../../00-Scripts/barcodes1504.txt

        while read line
                do
                set 'echo $line'
                ../../00-Scripts/ParseVCF2.pl "$line"_Yvar.trim.vcf > "$line"_Ycounts.txt 
                ../../00-Scripts/ParseVCF2.pl "$line"_Dvar.trim.vcf > "$line"_Dcounts    
        done < ../../00-Scripts/barcodes1504.txt
        cd ../
done



echo 'Data ready for analysis in R. '


