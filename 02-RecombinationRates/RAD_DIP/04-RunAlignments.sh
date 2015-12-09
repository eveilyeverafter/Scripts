#!/bin/bash


for plate in `seq 1 4`;
do
	cd ./Plate$plate

	count=0
	NR_CPUS=20
	while read line
			do
			set 'echo $line'
			echo 'In plate '$plate'. Processing barcode '$line
			
			bowtie2 -p 1 -x "$SCRIPTS"/reference_seq/bowtie2indeces/s288cIndex -U ../../../01-Processing/01-process_radtags/Plate"$plate"/both/sample_"$line".extendedFrags.fastq > "$line"_aligned.se.sam & 
			bowtie2 -p 1 -x "$SCRIPTS"/reference_seq/bowtie2indeces/s288cIndex -1 ../../../01-Processing/01-process_radtags/Plate"$plate"/both/sample_"$line".notCombined_1.fastq -2 ../../01-process_radtags/Plate$plate/both/sample_"$line".notCombined_2.fastq -I 400 -X 800 > "$line"_aligned.pe.sam & 
	
	let count+=2
	[[ $((count%NR_CPUS)) -eq 0 ]] && wait
	done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt


	cd ../
done


