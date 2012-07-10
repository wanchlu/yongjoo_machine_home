#!/usr/local/bin/perl

# script: test_biased_lexrank.pl
# functionality: Computes the lexrank value of a network given bias sentences

use strict;
use warnings;
use FindBin;
use Clair::Config;
use Clair::Cluster;
use Clair::Document;
use Clair::NetworkWrapper;

my @sents = ("The president's neck is missing", 
             "The human torch was denied a bank loan today",
             "The verdict was mail fraud");
my @bias = ("The president's neck is missing",
             "The president was given a bank loan");

print "Sentences:\n";
map { print "\t$_\n" } @sents;
print "\nBias sentences:\n";
map { print "\t$_\n" } @bias;

my $cluster = Clair::Cluster->new();
my $i = 1;

for (@sents) {
    chomp;
    my $doc = Clair::Document->new(
        string => $_,
        type => "text",
    );
    $doc->stem();
    $cluster->insert($i, $doc);
    $i++;
}

my %matrix = $cluster->compute_cosine_matrix();
my $network = $cluster->create_network(
    cosine_matrix => \%matrix, 
    include_zeros => 1
);
my $wn = Clair::NetworkWrapper->new(
    prmain => $PRMAIN,
    network => $network
);

my @verts = $wn->{graph}->vertices();

my $lr = Clair::Network::Centrality::LexRank->new($network);

my $lrv = $lr->compute_lexrank_from_bias_sents( bias_sents=>\@bias );

for (my $i =0; $i < @verts; $i++) {
    print "$sents[$i]\t", $lrv->element($i + 1, 1), "\n";
}
