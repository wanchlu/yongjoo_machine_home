# script: test_biased_lexrank.t
# functionality: Computes the lexrank value of a network given bias sentences

use strict;
use FindBin;
use Test::More;
use Clair::Config;

if (not defined $PRMAIN or -d $PRMAIN) {
    plan( skip_all =>
        '$PRMAIN not defined in Clair::Config or doesn\'t exist' );
} else {
    plan( tests => 5 );
}

use_ok("Clair::Cluster");
use_ok("Clair::Document");
use_ok("Clair::NetworkWrapper");
use_ok("Clair::Network::Centrality::LexRank");

my @sents = ("The president's neck is missing",
             "The human torch was denied a bank loan today",
             "The verdict was mail fraud");
my @bias = ("The president's neck is missing",
             "The president was given a bank loan");
my @expected = (1, 2, 3);

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
    network => $network,
    clean => 1
);

my @verts = $wn->{graph}->vertices();

my $bet = Clair::Network::Centrality::LexRank->new($wn);

$bet->compute_lexrank_from_bias_sents( bias_sents=>\@bias );
my $lrv = $wn->get_property_vector(\@verts, "lexrank_value");

my %scores;
for (my $i =0; $i < @verts; $i++) {
    $scores{$verts[$i]} = $lrv->element($i + 1, 1);
}
my @sorted = sort { $scores{$a} <=> $scores{$b} } keys %scores;

is(@sorted, @expected, "Correct order");
