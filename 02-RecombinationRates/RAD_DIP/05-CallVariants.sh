#!/bin/bash
# Dec 9th, 2015

for plate in `seq 1 4`; 
do
    cd ./Plate$plate
    count=0
    NR_CPUS=10
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Converting se sam to bam on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | cut -d: -f 1) -ge $(cat "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | wc -l) ]
        then
            samtools view -bS ../../02-Alignments/Plate$plate/"$line"_aligned.se.sam > "$line"_aligned.se.bam
            # echo "yes"
        else
            # echo "no"
            samtools view -bS ../../02-Alignments/Plate$plate/"$line"_aligned.se.sam > "$line"_aligned.se.bam & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt
 
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Converting pe sam to bam on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | cut -d: -f 1) -ge $(cat "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | wc -l) ]
        then
            samtools view -bS ../../02-Alignments/Plate$plate/"$line"_aligned.pe.sam > "$line"_aligned.pe.bam
            # echo "yes"
        else
            # echo "no"
            samtools view -bS ../../02-Alignments/Plate$plate/"$line"_aligned.pe.sam > "$line"_aligned.pe.bam & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt
 
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Making aligned files on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | cut -d: -f 1) -ge $(cat "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | wc -l) ]
        then
            samtools merge "$line"_aligned.bam "$line"_aligned.*bam
            # echo "yes"
        else
            # echo "no"
            samtools merge "$line"_aligned.bam "$line"_aligned.*bam & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt
 
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Sorting aligned files on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | cut -d: -f 1) -ge $(cat "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | wc -l) ]
        then
            samtools sort "$line"_aligned.bam "$line"_aligned.sorted
            # echo "yes"
        else
            # echo "no"
            samtools sort "$line"_aligned.bam "$line"_aligned.sorted & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt
 
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Running mpileup on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | cut -d: -f 1) -ge $(cat "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt | wc -l) ]
        then
            samtools mpileup -I -uf "$SNPDIR"/YPS128_consensus.fa ./"$line"_aligned.sorted.bam  2> stderr.txt  | bcftools view -b - > "$line"_Yvar.raw.bcf
            # echo "yes"
        else
            # echo "no"
            samtools mpileup -I -uf "$SNPDIR"/YPS128_consensus.fa ./"$line"_aligned.sorted.bam  2> stderr.txt  | bcftools view -b - > "$line"_Yvar.raw.bcf & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt

    cd ../
done

 
