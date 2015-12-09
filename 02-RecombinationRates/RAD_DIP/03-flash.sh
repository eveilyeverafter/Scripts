#!/bin/bash

# Script to flash samples 

# For this analysis, there are four plates that need to remain separated.
# Each plate has 96 barcoded samples. Barcodes are stored in a file called: 

for plate in `seq 1 4`;
do
	cd ./Plate$plate
	cd ./both

	count=0
	NR_CPUS=20
	while read line
			do
			set 'echo $line'
			echo 'In plate '$plate'. Flashing barcode '$line
			
			flash --max-overlap 275 -t 1 -o sample_"$line" sample_"$line".1.fq sample_"$line".2.fq >> sample_"$line".log & 

	let count+=1
	[[ $((count%NR_CPUS)) -eq 0 ]] && wait
	done < "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt


	cd ../../
done




