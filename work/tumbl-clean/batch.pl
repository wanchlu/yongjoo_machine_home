#!/usr/bin/perl -w
use strict;

#foreach my $sample ( 10,25,50,75,100,150,200,250,300,350,400,450,500,750,1000 ){
my $it = 0;
foreach ($it = 0; $it <10; $it++) {
foreach my $sample ( 10){
	`./shuffle.pl "data/A.train" | head -n$sample | ./data/convert_to_edgelist.pl | sort | uniq > "data/A.edges.$sample.$it"`;
	print "-----------\nNumber of tuples: $sample\n\n";
	print 	`print_network_stats.pl --input="data/A.edges.$sample.$it" `;

}
}
