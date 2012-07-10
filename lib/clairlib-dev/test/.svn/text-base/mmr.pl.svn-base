#!/usr/local/bin/perl

# script: test_mmr.pl
# functionality: Tests the lexrank reranker on a network  

use strict;
use warnings;
use FindBin;
use Clair::Cluster;
use Clair::Network;
use Clair::Network::Centrality::LexRank;
use Clair::Document;


my $input_dir = "$FindBin::Bin/input/mmr";
my $file = "$input_dir/file.txt";
my $bias_file = "$input_dir/bias.txt";
my $lambda = 0.5;

# Split the first document into sentences

open FILE, "< $file" or die "Couldn't open $file: $!";
my $text;
while (<FILE>) {
    $text .= $_;
}
close FILE;
my $document = Clair::Document->new(
    string => $text,
    id => "document",
    type => "text"
);
my @sents = $document->split_into_sentences();


# Split the second document into sentences

open FILE, "< $bias_file" or die "Couldn't open $bias_file: $!";
$text = "";
while (<FILE>) {
    $text .= $_;
}
close FILE;
my $bias_doc = Clair::Document->new(
    string => $text,
    id => "document",
    type => "text"
);
my @bias = $bias_doc->split_into_sentences();


# Make a cluster from the first document's sentences

my $cluster = Clair::Cluster->new();
my $i = 1;
for (@sents) {
    my $doc = Clair::Document->new(
        string => $_,
        type => "text",
        id => $i
    );
    $doc->stem();
    $cluster->insert($i, $doc);
    $i++;
}


# Turn it into a matrix to run lexrank

my %matrix = $cluster->compute_cosine_matrix();
my $network = $cluster->create_network(
    cosine_matrix => \%matrix,
    include_zeros => 1
);
my $cent = Clair::Network::Centrality::LexRank->new($network);
$cent->compute_lexrank_from_bias_sents( bias_sents => \@bias );


# Run MMR reranker 

$network->mmr_rerank_lexrank($lambda);


# Print out the sentences, ordered by lexrank
my $graph = $network->{graph};
my @verts = $graph->vertices();

my %scores = ();
foreach my $vert (@verts) {
    $scores{$vert} = $graph->get_vertex_attribute($vert, "lexrank_value");
}

foreach my $vert (sort { $scores{$b} cmp $scores{$a} } keys %scores) {
    my $sent = $cluster->get($vert)->get_text();
    print "$sent ($scores{$vert})\n";
}

