# script: test_random_walk.t
# functionality: Creates a network, assigns initial probabilities and tests
# functionality: taking single steps and calculating stationary distribution 

use strict;
use warnings;
use FindBin;

use Test::More tests => 7;

my $file_gen_dir = "$FindBin::Bin/produced/random_walk";
my $file_input_dir = "$FindBin::Bin/input/random_walk";
my $file_exp_dir = "$FindBin::Bin//expected/random_walk";

use_ok('Clair::Network');
use_ok('Clair::Util');

my $n = new Clair::Network();

$n->add_node(1, text => 'Text for node 1');
$n->add_node(2, text => 'Text for node 2');
$n->add_node(3, text => 'More text');

$n->read_transition_probabilities_from_file("$file_input_dir/t.txt");
$n->read_initial_probability_distribution("$file_input_dir/i.txt");

$n->save_transition_probabilities_to_file("$file_gen_dir/trans_prob.txt");
ok(compare_proper_files("trans_prob.txt"), 
    "save_transition_probabilities_to_file");

$n->make_transitions_stochastic();
$n->save_transition_probabilities_to_file("$file_gen_dir/stoch_trans_prob.txt");
ok(compare_proper_files("stoch_trans_prob.txt"), "... 2" );

$n->save_current_probability_distribution("$file_gen_dir/init_prob.txt");
ok(compare_proper_files("init_prob.txt"), 
    "save_current_probability_distribution");


$n->perform_next_random_walk_step();
$n->perform_next_random_walk_step();
$n->perform_next_random_walk_step();


$n->save_current_probability_distribution("$file_gen_dir/new_prob.txt");
ok(compare_proper_files("new_prob.txt"), "... 2" );

$n->compute_stationary_distribution();

$n->save_current_probability_distribution("$file_gen_dir/stat_dist.txt");
ok(compare_proper_files("stat_dist.txt"), "... 3");



# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
  my $filename = shift;

  return Clair::Util::compare_files("$file_exp_dir/$filename", "$file_gen_dir/$filename");
}

