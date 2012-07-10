# script: test_lexrank3.t
# functionality: Computes lexrank from line-based, stripped and stemmed
# functionality: cluster 

use strict;
use warnings;
use FindBin;
use Test::More tests => 9;

use_ok('Clair::Network');
use_ok('Clair::Network::Centrality::LexRank');
use_ok('Clair::Cluster');
use_ok('Clair::Document');
use_ok('Clair::Util');

my $file_gen_dir = "$FindBin::Bin/produced/lexrank3";
my $file_input_dir = "$FindBin::Bin/input/lexrank3";
my $file_exp_dir = "$FindBin::Bin/expected/lexrank3";

my $c = new Clair::Cluster();

$c->load_documents("$file_input_dir/*", type => 'html', count_id => 1);
is($c->count_elements, 5, "count_elements");

$c->strip_all_documents();
$c->stem_all_documents();
my %cos_matrix = $c->compute_cosine_matrix(text_type => 'stem');

my $n = $c->create_network(cosine_matrix => \%cos_matrix);
is($n->num_nodes, 5, "num_nodes");

is($n->num_links, 20, "num_links");

my $b = Clair::Network::Centrality::LexRank->new($n);
$b->centrality();


$b->save("$file_gen_dir/lexrank_result");
ok(compare_proper_files("lexrank_result"), "save");


# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
  my $filename = shift;

  return Clair::Util::compare_files("$file_exp_dir/$filename", "$file_gen_dir/$filename");
}

