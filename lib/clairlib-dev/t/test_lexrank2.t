# script: test_lexrank2.t
# functionality: Computes lexrank from a stemmed line-based cluster 

use strict;
use warnings;
use FindBin;
use Test::More tests => 13;

use_ok('Clair::Network');
use_ok('Clair::Network::Centrality::LexRank');
use_ok('Clair::Cluster');
use_ok('Clair::Document');
use_ok('Clair::Util');

my $file_gen_dir = "$FindBin::Bin/produced/lexrank2";
my $file_input_dir = "$FindBin::Bin/input/lexrank2";
my $file_exp_dir = "$FindBin::Bin/expected/lexrank2";

my $c = new Clair::Cluster();

$c->load_lines_from_file("$file_input_dir/lexrank.input");
is($c->count_elements(), 4, "count_elements");

$c->stem_all_documents();
my %cos_matrix = $c->compute_cosine_matrix(text_type => 'stem');

my $n = $c->create_network(cosine_matrix => \%cos_matrix);
is($n->num_nodes, 4, "num_nodes");
is($n->num_links, 12, "num_links");

my $b = Clair::Network::Centrality::LexRank->new($n);
$b->centrality();

$b->save("$file_gen_dir/lexrank.dist");
ok(compare_proper_files("lexrank.dist"), "save" );

my @expected = ( ["0", 0.2733],
                 ["1", 0.1845],
                 ["2", 0.2714],
                 ["3", 0.2708] );

foreach my $e (@expected) {
  my $v = $e->[0];
  if ($n->has_vertex_attribute($v, "lexrank_value")) {
    ok(Clair::Util::within_delta($e->[1],
                                 $n->get_vertex_attribute($v, "lexrank_value"),
                                 0.0001), "lexrank vertex $v");
  }
}

# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
  my $filename = shift;

  return Clair::Util::compare_files("$file_exp_dir/$filename", "$file_gen_dir/$filename");
}
