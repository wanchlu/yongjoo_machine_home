#!/usr/local/bin/perl

# script: test_lexrank3.pl
# functionality: Computes lexrank from line-based, stripped and stemmed
# functionality: cluster

use strict;
use warnings;
use FindBin;
use Clair::Network;
use Clair::Cluster;
use Clair::Document;
use Clair::Network::Centrality::LexRank;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/lexrank";

# Switch to the input directory so that the file list can be
# just filenames without paths (since we don't know absolute path)
chdir "$input_dir";

my $c = new Clair::Cluster();

$c->load_file_list_from_file("filelist.txt", type => 'html', count_id => 1);
$c->strip_all_documents();
$c->stem_all_documents();
my %cos_matrix = $c->compute_cosine_matrix(text_type => 'stem');

my $n = $c->create_network(cosine_matrix => \%cos_matrix);

my $cent = Clair::Network::Centrality::LexRank->new($n);
$cent->centrality();


print "FILE LEXRANK\n";
$cent->print_current_distribution();
print "\n";
