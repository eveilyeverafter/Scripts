#!/bin/bash
# TrimAndParse.sh


 
	while read line
		do
		set 'echo $line'
		bcftools view -ce -l "$SNPDIR"/locilist ../04-CallVariants/"$line"_Yvar.raw.bcf > "$line"_Yvar.trim.vcf & 
		bcftools view -ce -l "$SNPDIR"/locilist ../04-CallVariants/"$line"_Dvar.raw.bcf > "$line"_Dvar.trim.vcf
	done < ../samples

	while read line
		do
		set 'echo $line'
		"$SCRIPTS"/02-RecombinationRates/ParseVCF2.pl "$line"_Yvar.trim.vcf > "$line"_Ycounts.txt &  
		"$SCRIPTS"/02-RecombinationRates/ParseVCF2.pl "$line"_Dvar.trim.vcf > "$line"_Dcounts 	 
	done < ../samples
	



echo 'Data ready for analysis in R. '
