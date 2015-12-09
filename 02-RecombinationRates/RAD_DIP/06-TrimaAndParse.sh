#!/bin/bash


for plate in `seq 1 4`; 
do
    cd ./Plate$plate  
        while read line
                do
                set 'echo $line'
                bcftools view -ce -l "$SNPDIR"/locilist ../../01-Processing/03-CallVariants/Plate"$plate"/"$line"_Yvar.raw.bcf > "$line"_Yvar.trim.vcf
                bcftools view -ce -l "$SNPDIR"/locilist ../../01-Processing/03-CallVariants/Plate"$plate"/"$line"_Dvar.raw.bcf  > "$line"_Dvar.trim.vcf   
        done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt

        while read line
                do
                set 'echo $line'
                "$SCRIPTS"/02-RecombinationRates/ParseVCF2.pl "$line"_Yvar.trim.vcf > "$line"_Ycounts.txt 
                "$SCRIPTS"/02-RecombinationRates/ParseVCF2.pl "$line"_Dvar.trim.vcf > "$line"_Dcounts    
        done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt
        cd ../
done



echo 'Data ready for analysis in R. '

