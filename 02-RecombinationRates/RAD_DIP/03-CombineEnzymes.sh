#!/bin/bash

# Script to combine pstI and nsiI fastq data into a single pair of fastq files for each barcode
# TH 5/6/15

# For this analysis, there are four plates that need to remain separated.
# Each plate has 96 barcoded samples. Barcodes are stored in a file called: 


for plate in `seq 1 4`;
do
	cd ./Plate$plate

	count=0
	NR_CPUS=4
	while read line
			do
			set 'echo $line'
			echo 'In plate '$plate'. Processing barcode '$line
			# copy the pstI files to the both directory
			cp ./pstI/sample_$line.1.fq ./both/sample_$line.1.fq
			cp ./pstI/sample_$line.2.fq ./both/sample_$line.2.fq

			# the append the nsiI files to the both directory
			cat ./nsiI/sample_$line.1.fq >> ./both/sample_$line.1.fq
			cat ./nsiI/sample_$line.2.fq >> ./both/sample_$line.2.fq


	let count+=1
	[[ $((count%NR_CPUS)) -eq 0 ]] && wait
	done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt


	cd ../
done

