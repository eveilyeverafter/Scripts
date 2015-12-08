#!/usr/bin/perl -w
use strict; use warnings;


# To use: ./script_name.pl <barcodes.txt> <forward.fastq> <reverse.fastq> <forward_flipped.fastq> <reverse_flipped.fastq>
 

open (IN, $ARGV[0]);
my %counts = ();
while(<IN>) {
	chomp($_);
	$counts{$_} = 0;
}
close IN;

open (IN1, $ARGV[1]);
open (IN2, $ARGV[2]);
open (OUT1, ">$ARGV[3]");
open (OUT2, ">$ARGV[4]");
my $forward; my $reverse; my $barcode;
my $name1; my $name2; my $third1; my $third2; my $qual1; my $qual2;
while($name1 = <IN1>) {
	$name2 = <IN2>;
	$forward = <IN1>;
	$reverse = <IN2>;
	$third1 = <IN1>; $third2 = <IN2>; $qual1 = <IN1>; $qual2 = <IN2>;
	my $which = 0; my $for; my $rev;
	if(substr($forward, 10, 5) eq "TGCAT") {
		if(substr($reverse, 10, 5) eq "TGCAT") {
			$for = substr($forward, 2, 8);
			$rev = substr($reverse, 2, 8);
			if(exists $counts{$for} && (exists $counts{$rev}) == 0) {
				$which = 1; $barcode = $for;
			}
			elsif((exists $counts{$for}) == 0 && exists $counts{$rev}) {
				$which = 2; $barcode = $rev;
			}
		}
		else {
			$barcode = substr($forward, 2, 8);
			if(exists $counts{$barcode}) {$which = 1; }
		}
	}
	elsif(substr($reverse, 10, 5) eq "TGCAT") {
		$barcode = substr($reverse, 2, 8);
		if(exists $counts{$barcode}) {$which = 2; }
	}
	if($which == 1) {
		my $temp1 = substr($forward, 2);
		my $temp2 = substr($qual1, 2);
		print OUT1 "$name1$temp1$third1$temp2";
		print OUT2 "$name2$reverse$third2$qual2";
	}
	elsif($which == 2) {
		my $temp1 = substr($reverse, 2);
		my $temp2 = substr($qual2, 2);
		print OUT1 "$name2$temp1$third2$temp2";
		print OUT2 "$name1$forward$third1$qual1";
	}
}
close IN1;
close IN2;
close OUT1;
close OUT2;

