#!/usr/bin/perl -w
my $node_cnt = 0;
while (<>){
	chomp;
	$node_cnt++;
	my @tokens = split /\s+/;
	foreach my $i(1..$#tokens) {
		print $node_cnt . " " . $tokens[$i] ."\n";
	}
}
	
