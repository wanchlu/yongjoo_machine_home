#!/usr/local/bin/perl

# script: test_lexrank_large.pl
# functionality: Builds a cluster from a set of files, computes a cosine matrix
# functionality: and then lexrank, then creates a network and a cluster using
# functionality: a lexrank-based threshold of 0.2

use strict;
use warnings;
use FindBin;
use Clair::Network;
use Clair::Network::Centrality::LexRank;
use Clair::Cluster;
use Clair::Document;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/lexrank";

# chdir to the input directory so that the filelist can be relative paths
# (since we don't know the absolute path)
chdir $input_dir;

my $c = new Clair::Cluster();

$c->load_file_list_from_file("filelist.txt", type => 'html', count_id => 1);
$c->strip_all_documents();
$c->stem_all_documents();

print "I'm here.  There are ", $c->count_elements, " documents in the cluster.\n";
my $sent_n = $c->create_sentence_based_network;
print "Now I'm here.\n";
print "Sentence based network has: ", $sent_n->num_nodes(), " nodes.\n";

my %cos_matrix = $c->compute_cosine_matrix(text_type => 'stem');

my $n = $c->create_network(cosine_matrix => \%cos_matrix);
my $cent = Clair::Network::Centrality::LexRank->new($n);

$cent->centrality();


print "FILE LEXRANK\n";
$cent->print_current_distribution();
print "\n";

my $lex_network = $n->create_network_from_lexrank(0.2);
print "There are ", $lex_network->num_nodes, " nodes in the network created from lexrank.\n";

my $lex_cluster = $n->create_cluster_from_lexrank(0.2);
print "There are ", $lex_cluster->count_elements(), " documents in the cluster created from lexrank.\nThey have:\n";

my $lex_docs_ref = $lex_cluster->documents();
my %lex_docs = %$lex_docs_ref;

foreach my $doc (values %lex_docs ) {
        print $doc->count_words, " words\n";
}

