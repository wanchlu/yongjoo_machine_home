#!/usr/local/bin/perl

# script: test_lexrank2.pl
# functionality: Computes lexrank from a stemmed line-based cluster

use strict;
use warnings;
use FindBin;
use Clair::Network;
use Clair::Cluster;
use Clair::Document;
use Clair::Network::Centrality::LexRank;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/lexrank";

my $c = new Clair::Cluster();

$c->load_lines_from_file("$input_dir/t02_lexrank.input");
$c->stem_all_documents();
my %cos_matrix = $c->compute_cosine_matrix(text_type => 'stem');

my $n = $c->create_network(cosine_matrix => \%cos_matrix);

my $cent = Clair::Network::Centrality::LexRank->new($n);

$cent->centrality();


print "SENT LEXRANK\n";
$cent->print_current_distribution();
print "\n";
