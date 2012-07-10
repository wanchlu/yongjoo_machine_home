# script: test_lexrank.t
# functionality: Computes lexrank on a small network 

use strict;
use warnings;
use FindBin;

use Test::More tests => 7;

use_ok('Clair::Network');
use_ok('Clair::Network::Centrality::LexRank');
use_ok('Clair::Util');

my $file_gen_dir = "$FindBin::Bin/produced/lexrank";
my $file_input_dir = "$FindBin::Bin/input/lexrank";
my $file_exp_dir = "$FindBin::Bin/expected/lexrank";

my $n = new Clair::Network();

$n->add_node(0, text => 'This is node 0');
$n->add_node(1, text => 'This is node 1');
$n->add_node(2, text => 'This is node 2');
$n->add_node(3, text => 'This is node 3');
$n->add_node(4, text => 'This is node 4');

my $b = Clair::Network::Centrality::LexRank->new($n);

$b->read_lexrank_probabilities_from_file("$file_input_dir/files-sym.cos.ID");
$b->read_lexrank_initial_distribution("$file_input_dir/files.uniform");

# Remove following line to remove lexrank bias:
$b->read_lexrank_bias("$file_input_dir/files.bias");

$n->save_transition_probabilities_to_file("$file_gen_dir/trans_prob");
$b->save_lexrank_probabilities_to_file("$file_gen_dir/init_prob");
ok( compare_proper_files("trans_prob"), "trans_prob" );
ok( compare_proper_files("init_prob"), "init_prob" );

$b->centrality(jump => 0.5);

$b->save_lexrank_probabilities_to_file("$file_gen_dir/final5_prob");
ok( compare_proper_files("final5_prob"), "final5_prob" );

$b->centrality(jump => 0.1);
$b->save_lexrank_probabilities_to_file("$file_gen_dir/final1_prob");
ok(compare_proper_files("final1_prob"), "final1_prob" );

# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
  my $filename = shift;

  return Clair::Util::compare_files("$file_exp_dir/$filename", "$file_gen_dir/$filename");
}

