#!/usr/local/bin/perl

# script: test_cluster.pl
# functionality: Creates a cluster, a sentence-based network from it,
# functionality: calculates a binary cosine and builds a network based
# functionality: on the cosine, then exports it to Pajek 

# Note: Make sure java is in your path, it is used by the splitter.

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Clair::Document;
use Clair::Cluster;
use Clair::Network;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/cluster";
my $gen_dir = "$basedir/produced/cluster";

# Create a cluster
my $c = new Clair::Cluster;

my $count = 0;

# Read every document from the the 'text' directory
# And insert it into the cluster
# Convert from HTML to text, then stem as we do so
while ( <$input_dir/*> ) {
	my $file = $_;

	my $doc = new Clair::Document(type => 'html', file => $file, id => ++$count);
	$doc->strip_html;
	$doc->stem;

	$c->insert($count, $doc);
}

print "Loaded ", $c->count_elements, " documents.\n";

print "Creating sentence based network.\n";
my $n = $c->create_sentence_based_network();
print "Created sentence based network with: ", $n->num_nodes(), " documents and ", $n->num_links, " edges.\n";

# Compute the cosine matrix
my %cos_matrix = $c->compute_cosine_matrix;

# Find the largest cosine
my %largest_cosine = $c->get_largest_cosine;
print "The largest cosine is ", $largest_cosine{'value'}, " produced by ",
      $largest_cosine{'key1'}, " and ", $largest_cosine{'key2'}, ".\n";

# Compute the binary cosine using threshold = 0.15, 
# then write it to file 'docs/produced/text.cosine'
my %bin_cosine = $c->compute_binary_cosine(0.15);
$c->write_cos("$gen_dir/text.cosine", cosine_matrix => \%bin_cosine);

# Create a network using the binary cosine,
# then export the network to Pajek
$n = $c->create_network(cosine_matrix => \%bin_cosine);
my $export = Clair::Network::Writer::Pajek->new();
$export->set_name('cosine_network');
$export->write_network($n, "$gen_dir/test.pajek");

$c->save_documents_to_directory($gen_dir, 'text');
