#!/usr/local/bin/perl

# script: test_lexrank.pl
# functionality: Computes lexrank on a small network

use strict;
use warnings;
use FindBin;
use Clair::Network;
use Clair::Network::Centrality::LexRank;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/lexrank";

my $n = new Clair::Network();

$n->add_node(0, text => 'This is node 0');
$n->add_node(1, text => 'This is node 1');
$n->add_node(2, text => 'This is node 2');
$n->add_node(3, text => 'This is node 3');
$n->add_node(4, text => 'This is node 4');

my $cent = Clair::Network::Centrality::LexRank->new($n);

$cent->read_lexrank_probabilities_from_file("$input_dir/files-sym.cos.ID");
$cent->read_lexrank_initial_distribution("$input_dir/files.uniform");

# Remove following line to remove lexrank bias:
$cent->read_lexrank_bias("$input_dir/files.bias");

print "Initial distribution:\n";
$cent->print_current_distribution();

print "READ PROBABILITIES\n";


$cent->centrality(jump => 0.5);

print "The computed lexrank distribution is:\n";
$cent->print_current_distribution();
print "\n";

