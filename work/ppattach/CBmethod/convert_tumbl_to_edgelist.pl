#!/usr/bin/perl -w
use strict;
my $max = 0;
my $input = shift;
open IN, "$input" or die;
while (<IN>) {
	my @tokens = split /\s+/, $_;
	if ($tokens[1] > $max) {
		$max = $tokens[1];
	}
}
close IN;
open IN, "$input" or die;
while (<IN>) {
        my @tokens = split /\s+/, $_;
	my $new = $tokens[0]+$max;
	print $new." ".$tokens[1]."\n";
}
close IN;
