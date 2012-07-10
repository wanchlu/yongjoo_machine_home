# script: test_mmr.t
# functionality: Tests the lexrank mmr reranker on a network   

use strict;
use warnings;
use FindBin;
use Test::More;
use Clair::Config;

if ( not defined $PRMAIN or not -e $PRMAIN ) {
    plan( skip_all => "PRMAIN not defined in Clair::Config or doesn't exist" )
} else {
    plan( tests => 6 );
}

use_ok("Clair::Cluster");
use_ok("Clair::Document");
use_ok("Clair::NetworkWrapper");

my @sents = ("foo bar", "bar baz", "baz qux");
my @mmr   = ([-.01,.01], [.03,.05], [.99,1.00]);

my $cluster = Clair::Cluster->new();
my $i = 1;
for (@sents) {
    chomp;
    my $doc = Clair::Document->new(
        string => $_,
        type => "text",
        id => $i
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

$wn->compute_lexrank();
my $lr_vector = $wn->get_property_vector(\@verts, "lexrank_value");

$wn->mmr_rerank_lexrank(0.5);
my $mmr_vector = $wn->get_property_vector(\@verts, "lexrank_value");

for (my $i = 0; $i < @verts; $i++) {
    my $act = $mmr_vector->element($i + 1, 1);
    ok($mmr[$i]->[0] <= $act && $act <= $mmr[$i]->[1], "lambda = 1, vert $i");
}

