#!/bin/bash

# Script to process radtags on (flipped) data
# TH 5/6/15. 

module load stacks

# For this analysis, there are four plates that need to remain separated.
# Within each plate, nsiI and pstI reads should be parsed out seperately.
# Within each enzyme directory, barcoded samples need to be demulitplexed.

ls ./ > ../dirs

count=0
NR_CPUS=20 # It will run the following block for each of the four plates
while read line
	do
	set 'echo $line'
	cd $line
		# echo $(pwd)
		cd nsiI
			process_radtags -P -1 ../../../00-Flipped/$line/nsiI/forward_flipped.fq -2 ../../../00-Flipped/$line/nsiI/reverse_flipped.fq -b "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt -o ./ -e nsiI -E phred33 -c -q -s 0 &
		cd ../

		cd pstI
			process_radtags -P -1 ../../../00-Flipped/$line/pstI/forward_flipped.fq -2 ../../../00-Flipped/$line/pstI/reverse_flipped.fq -b "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt -o ./ -e pstI -E phred33 -c -q -s 0 &
		cd ../
	cd ../
let count+=2
[[ $((count%NR_CPUS)) -eq 0 ]] && wait	
done < ../dirs

rm ../dirs

