# script: test_networkwrapper_sents.t
# functionality: Test the NetworkWrapper's lexrank generation for a small        
# functionality: cluster of documents built from an array of sentences 

use strict;
use FindBin;
use Clair::Config;
use Test::More;

if (not defined $PRMAIN or -d $PRMAIN) {
    plan( skip_all => 
        '$PRMAIN not defined in Clair::Config or doesn\'t exist' );
} else {
    plan( tests => 7 );
}

use_ok("Clair::Cluster");
use_ok("Clair::Document");
use_ok("Clair::NetworkWrapper");
use_ok("Clair::Network::Centrality::CPPLexRank");


my @sents           = ( "foo bar",    "bar baz",    "baz foo"    );
my @expected_scores = ( [0.30, 0.32], [0.41, 0.43], [0.24, 0.26] );

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
my $wrapped_network = Clair::NetworkWrapper->new(
    prmain => $PRMAIN,
    network => $network,
    clean => 1
);
my $cent = Clair::Network::Centrality::CPPLexRank->new($network);
$cent->centrality();

my @vertices = $wrapped_network->{graph}->vertices();
my $vector = $wrapped_network->get_property_vector(\@vertices, 
    "lexrank_value");

my @actual_scores;
for (my $i = 0; $i < ($vector->dim())[0]; $i++) {
    push @actual_scores, $vector->element($i + 1, 1);
}

for (my $i = 0; $i < @sents; $i++) {
    ok($expected_scores[$i]->[0] <= $actual_scores[$i] &&
       $actual_scores[$i] <= $expected_scores[$i]->[1], "Sentence: $sents[$i]");
}
