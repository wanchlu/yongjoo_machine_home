#!/usr/local/bin/perl

# script: test_random_walk.pl
# functionality: Creates a network, assigns initial probabilities and tests
# functionality: taking single steps and calculating stationary distribution 

use strict;
use warnings;
use FindBin;
use Clair::Network;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/random_walk";
my $gen_dir = "$basedir/produced/random_walk";

my $n = new Clair::Network();

$n->add_node(1, text => 'Text for node 1');
$n->add_node(2, text => 'Text for node 2');
$n->add_node(3, text => 'More text');

$n->read_transition_probabilities_from_file("$input_dir/t.txt");
$n->read_initial_probability_distribution("$input_dir/i.txt");

print "READ PROBABILITIES\n";

$n->save_transition_probabilities_to_file("$gen_dir/trans_prob.txt");
$n->make_transitions_stochastic();
$n->save_transition_probabilities_to_file("$gen_dir/stoch_trans_prob.txt");
$n->save_current_probability_distribution("$gen_dir/init_prob.txt");

print "WROTE_PROBABILITES BACK\n";

$n->perform_next_random_walk_step();
$n->perform_next_random_walk_step();
$n->perform_next_random_walk_step();

print "PERFORMED RANDOM WALK STEPS\n";

$n->save_current_probability_distribution("$gen_dir/new_prob.txt");

$n->compute_stationary_distribution();

print "COMPUTED STATIONARY DISTRIBUTION\n";
$n->save_current_probability_distribution("$gen_dir/stat_dist.txt");
print "WROTE RESULTS BACK\n";

print "The computed stationary distribution is:\n";
$n->print_current_probability_distribution();
print "\n";

