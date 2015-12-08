##################
#!/bin/bash
ls ../02-Cleaned/ > dirs

count=0
NR_CPUS=14
while read line
    do
    set 'echo $line'
    bowtie2 -p 1 -x ../00-Scripts/bowtie2indeces/s288cIndex -U ../02-Cleaned/"$line"/"$line"_merged_SE.fastq > "$line"_aligned.se.sam &   
    bowtie2 -p 1 -x ../00-Scripts/bowtie2indeces/s288cIndex -1 ../02-Cleaned/"$line"/"$line"_notcombined_PE1.fastq -2 ../02-Cleaned/"$line"/"$line"_notcombined_PE2.fastq -I 400 -X 800 > "$line"_aligned.pe.sam & 
    let count+=2
    [[ $((count%NR_CPUS)) -eq 0 ]] && wait  
done < dirs
###################

