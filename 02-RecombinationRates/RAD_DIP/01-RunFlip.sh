#!/bin/bash

# Script to flip reads if the restriction site and barcode are on the paired-end
# TH 5/6/15. Modified from PAH

for plate in `seq 1 4`;
do
	cd ./Plate$plate
	echo 'Flipping plate '$plate' for pstI'
	cd ./pstI
		"$SCRIPTS"/02-RecombinationRates/RAD_DIP/flip_best_rad_pstI.pl "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt  ../../../../00-RawData/Sample_Plate$plate/*R1* ../../../../00-RawData/Sample_Plate$plate/*R2* forward_flipped.fq reverse_flipped.fq
	cd ../
	echo 'Flipping plate '$plate' for nsiI'
	cd ./nsiI
		"$SCRIPTS"/02-RecombinationRates/RAD_DIP/flip_best_rad_nsiI.pl "$SCRIPTS"/02-RecombinationRates/RAD_DIP/barcodes1504.txt ../../../../00-RawData/Sample_Plate$plate/*R1* ../../../../00-RawData/Sample_Plate$plate/*R2* forward_flipped.fq reverse_flipped.fq
	cd ../../

done
