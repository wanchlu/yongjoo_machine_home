#!/usr/bin/perl -w
use Clair::Network::Writer::Edgelist;

my $fname = shift; 
#my $reader = Clair::Network::Reader::EdgeList->new();
#my $network = $reader->read_network($fname);
#my $export = Clair::Network::Writer::Edgelist->new();
#$export->write_network($network, "$fname.edges");
`print_network_stats.pl --input="$fname" --all >"$fname.stats"`;

