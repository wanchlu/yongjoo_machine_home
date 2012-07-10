#!/usr/bin/perl -w
use strict;
my $MAXIT = 30;

foreach my $trainsize (1200, 1400, 1600, 1800, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000, 15000, 20801){
#foreach my $trainsize (10, 25, 50, 75, 100, 150, 200, 250, 300, 350, 400, 450, 500, 600, 700, 800, 900, 1000) {

	my $acc_sum = 0;
	print "Trainsize: $trainsize\n";
	foreach my $it (1..$MAXIT) {
		`./shuffle.pl ppattach3.train |head -$trainsize >trainfile/$trainsize`;
		my $acc = `./run.sh "trainfile/$trainsize" ppattach3.devtt`;
		chomp ($acc);
		$acc_sum += $acc;
		print "$acc, ";
	}
	my $avg = $acc_sum/$MAXIT;
	print "\nAverage accuracy: $avg\n\n";
}

