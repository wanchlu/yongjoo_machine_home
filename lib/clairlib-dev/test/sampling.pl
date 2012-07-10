#!/usr/local/bin/perl

# script: test_sampling.pl
# functionality: Exercises network sampling using RandomNode and ForestFire 

#!/usr/bin/perl

use strict;
use warnings;
use Clair::Network;
use Clair::Network::Sample::RandomNode;
use Clair::Network::Sample::ForestFire;

my $net = new Clair::Network();

$net->add_node("A");
$net->add_node("B");
$net->add_node("C");
$net->add_node("D");
$net->add_node("E");
$net->add_edge("A", "B");
$net->add_edge("A", "C");
$net->add_edge("A", "D");
$net->add_edge("B", "C");
$net->add_edge("B", "D");

my $sample = Clair::Network::Sample::RandomNode->new($net);

$sample->number_of_nodes(2);

print "Original network: ", $net->{graph}, "\n";
print "Sampling 2 nodes using random node selection\n";
my $new_net = $sample->sample();

print "New network: ", $new_net->{graph}, "\n";

my $fire = new Clair::Network::Sample::ForestFire($net);

print "Sampling 3 nodes using Forest Fire model\n";
$new_net = $fire->sample(3, 0.9);

print "New network: ", $new_net->{graph}, "\n";
