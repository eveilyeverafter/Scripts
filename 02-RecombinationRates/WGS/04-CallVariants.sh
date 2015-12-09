#!/bin/bash
# Dec 9th, 2015 for WGS data

plate=WGS
    count=0
    NR_CPUS=12
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Converting se sam to bam on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line ../samples | cut -d: -f 1) -ge $(cat ../samples | wc -l) ]
        then
            samtools view -bS ../03-Alignments/"$line"_aligned.se.sam > "$line"_aligned.se.bam
            # echo "yes"
        else
            # echo "no"
            samtools view -bS ../03-Alignments/"$line"_aligned.se.sam > "$line"_aligned.se.bam & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < ../samples
 
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Converting pe sam to bam on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line ../samples | cut -d: -f 1) -ge $(cat ../samples | wc -l) ]
        then
            samtools view -bS ../03-Alignments/"$line"_aligned.pe.sam > "$line"_aligned.pe.bam
            # echo "yes"
        else
            # echo "no"
            samtools view -bS ../03-Alignments/"$line"_aligned.pe.sam > "$line"_aligned.pe.bam & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < ../samples
 
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Making aligned files on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line ../samples | cut -d: -f 1) -ge $(cat ../samples | wc -l) ]
        then
            samtools merge "$line"_aligned.bam "$line"_aligned.*bam
            # echo "yes"
        else
            # echo "no"
            samtools merge "$line"_aligned.bam "$line"_aligned.*bam & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < ../samples
 
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Sorting aligned files on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line ../samples | cut -d: -f 1) -ge $(cat ../samples | wc -l) ]
        then
            samtools sort "$line"_aligned.bam "$line"_aligned.sorted
            # echo "yes"
        else
            # echo "no"
            samtools sort "$line"_aligned.bam "$line"_aligned.sorted & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < ../samples
 
    while read line 
        do 
        set 'echo $line' 
        echo '~~~~~~~~~~~~~~~~~~~~  Running mpileup on plate '$plate', sample '$line'  ~~~~~~~~~~~~~~~~~~~~'
        if [ $(grep -n $line ../samples | cut -d: -f 1) -ge $(cat ../samples | wc -l) ]
        then
            samtools mpileup -I -uf "$SNPDIR"/YPS128_consensus.fa ./"$line"_aligned.sorted.bam  2> stderr.txt  | bcftools view -b - > "$line"_Yvar.raw.bcf
            # echo "yes"
        else
            # echo "no"
            samtools mpileup -I -uf "$SNPDIR"/YPS128_consensus.fa ./"$line"_aligned.sorted.bam  2> stderr.txt  | bcftools view -b - > "$line"_Yvar.raw.bcf & 
        fi        
        let count+=1
        [[ $((count%NR_CPUS)) -eq 0 ]] && wait 
    done < ../samples

 
