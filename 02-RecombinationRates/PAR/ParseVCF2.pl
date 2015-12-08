#!/usr/bin/perl
use strict; 
use warnings;
my $DEBUG=1;
# my @counts=();
# my $DEBUG2=1;
open(FILE, $ARGV[0]) || die("CHECK FILE NAME");
my @lines = <FILE>;
close FILE;
my $lines;

foreach $lines (@lines){
	# print "$lines" if ($DEBUG);
	# my $match;
	if($lines =~ m/([a-zA-Z]+)\t(\d+)\t/g){
		print($1,"\;",$2,"\;");

		if($lines =~ m/DP4=(\d+)\,(\d+)\,(\d+),(\d+)\;/g){
			print($1,"\;",$2,"\;",$3,"\;",$4,"\n");
		}
		else {
			print("0","\;","0","\;","0","\;","0","\n");
		}
	}
}
exit 666;
