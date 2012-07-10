#!/usr/bin/perl -w
use strict;
my $MAXIT = 20;
my $testsize = 200;

#foreach my $trainsize (1200, 1400, 1600, 1800, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000, 15000, 20801){
foreach my $trainsize ( 50) {

	my $acc_sum = 0;
	print "Trainsize: $trainsize\n";
	my $cnt = 1;
	`./shuffle.pl ppattach3.devtt |head -$testsize >testfile/$testsize.1`;
	foreach my $it (1..$MAXIT) {
		`./shuffle.pl ppattach3.train |head -$trainsize >trainfile/$trainsize.$cnt`;
	#	`./shuffle.pl ppattach3.devtt |head -$testsize >testfile/$testsize.$cnt`;
		`cat "trainfile/$trainsize.$cnt" "testfile/$testsize.1" > "network/$trainsize.$cnt"`;
		`perl convert_to_tumbl_format.pl "network/$trainsize.$cnt"`;
		`perl convert_tumbl_to_edgelist.pl "network/$trainsize.$cnt.tumbl" >"network/$trainsize.$cnt.edgelist"`;
		my $acc = `./run.sh "trainfile/$trainsize.$cnt" "testfile/$testsize.1"`;
		chomp ($acc);
		$acc_sum += $acc;
		print "Sample $cnt: $acc\n";
		$cnt ++;
	}
	my $avg = $acc_sum/$MAXIT;
	print "\nAverage accuracy: $avg\n\n";
}

