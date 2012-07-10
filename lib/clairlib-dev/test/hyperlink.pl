#!/usr/local/bin/perl

# script: test_hyperlink.pl
# functionality: Makes and populates a cluster, builds a network from
# functionality:  hyperlinks between them; then tests making a subset


use strict;
use warnings;
use FindBin;
use Clair::Network;
use Clair::Cluster;
use Clair::Document;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/hyperlink";

my $c = new Clair::Cluster();
my $d1 = new Clair::Document(id => 1, type => 'text', string => 'Document 1');
$c->insert(1, $d1);
my $d2 = new Clair::Document(id => 2, type => 'text', string => 'Document 2');
$c->insert(2, $d2);
my $d3 = new Clair::Document(id => 3, type => 'text', string => 'Document 3');
$c->insert(3, $d3);
my $d4 = new Clair::Document(id => 4, type => 'text', string => 'Document 4');
$c->insert(4, $d4);

my $n = $c->create_hyperlink_network_from_file("$input_dir/t06.links");

print "Original edges:\n";
$n->print_hyperlink_edges();
my $n2 = $n->create_subset_network_from_file("$input_dir/t06.subset");
print "\nNew edges:\n";
$n2->print_hyperlink_edges();
