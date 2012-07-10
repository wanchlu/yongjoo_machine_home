#!/usr/local/bin/perl

# script: test_pagerank.pl
# functionality: Creates a small cluster and runs pagerank, displaying
# functionality: the pagerank distribution

use strict;
use warnings;
use FindBin;
use Clair::Network;
use Clair::Network::Centrality::PageRank;
use Clair::Cluster;
use Clair::Document;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/pagerank";

my $c = new Clair::Cluster();
my $doc1 = new Clair::Document(id => 1, type => 'text', string => 'This is document 1');
my $doc2 = new Clair::Document(id => 2, type => 'text', string => 'This is document 2');
my $doc3 = new Clair::Document(id => 3, type => 'text', string => 'This is document 3');
my $doc4 = new Clair::Document(id => 4, type => 'text', string => 'This is document 4');
$c->insert(1, $doc1);
$c->insert(2, $doc2);
$c->insert(3, $doc3);
$c->insert(4, $doc4);

my $n = $c->create_hyperlink_network_from_file("$input_dir/link.txt");

my $cent = Clair::Network::Centrality::PageRank->new($n);
$cent->centrality();

print "NODE PAGERANK\n";
$cent->print_current_distribution();
print "\n";

