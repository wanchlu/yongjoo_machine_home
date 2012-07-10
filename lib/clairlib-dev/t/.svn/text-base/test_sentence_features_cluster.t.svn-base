# script: test_sentence_features_cluster.t
# functionality: Test the propagation of feature scores between sentences
# functionality: related to each other through clusters. 

use strict;
use Test::More tests => 25;
use Clair::Cluster;
use Clair::Document;

my $text1 = "First sentence from doc1. The second sent from doc1.";
my $text2 = "First sentence from doc2. The second sent from doc2.";

my $doc1 = Clair::Document->new(string => $text1, id => 1);
my $doc2 = Clair::Document->new(string => $text2, id => 2);

my $cluster = Clair::Cluster->new(id => "cluster");
$cluster->insert(1, $doc1);
$cluster->insert(2, $doc2);

$cluster->compute_sentence_feature(name => "cid", feature => \&cid_feat);
$cluster->compute_sentence_feature(name => "did", feature => \&did_feat);

foreach my $did (1, 2) {
    foreach my $i (0, 1) {
        my $cvalue = $cluster->get_sentence_feature($did, $i, "cid");
        my $dvalue = $cluster->get_sentence_feature($did, $i, "did");
        is($cvalue, "cluster", "individ feature score ok");
        is($dvalue, $did, "individ feature score ok");
    }
}

$cluster->remove_sentence_features();

# Test cluster-wide normalization
$cluster->set_sentence_feature(1, 0, feat => 1); # did, sno, feature => value
$cluster->set_sentence_feature(1, 1, feat => 2);
$cluster->set_sentence_feature(2, 0, feat => 3);
$cluster->set_sentence_feature(2, 1, feat => 4);

$cluster->score_sentences( weights => { feat => 1 } );

is( $cluster->get_sentence_score(1, 0), 0, "sent 1" );
is( $cluster->get_sentence_score(1, 1), 1/3, "sent 2" );
is( $cluster->get_sentence_score(2, 0), 2/3, "sent 3" );
is( $cluster->get_sentence_score(2, 1), 1, "sent 4" );

my %scores = ( 1 => [0, 1/3],  2 => [2/3, 1] );
my %got_scores = $cluster->get_sentence_scores();
is_deeply(\%got_scores, \%scores, "hash of scores ok");

$cluster->remove_sentence_features();
$cluster->compute_sentence_feature( name => "state", feature => \&state_feat );
is( $cluster->get_sentence_feature(1, 0, "state"), 1, "state 1.0");
is( $cluster->get_sentence_feature(1, 1, "state"), 2, "state 1.1");
is( $cluster->get_sentence_feature(2, 0, "state"), 3, "state 2.0");
is( $cluster->get_sentence_feature(2, 1, "state"), 4, "state 2.1");

$cluster->remove_sentence_features();
$cluster->compute_sentence_feature( name => "state", feature => \&state_feat,
    normalize => 1);
is( $cluster->get_sentence_feature(1, 0, "state"), 0, "normalized 1.0");
is( $cluster->get_sentence_feature(1, 1, "state"), 1/3, "normalized 1.1");
is( $cluster->get_sentence_feature(2, 0, "state"), 2/3, "normalized 2.0");
is( $cluster->get_sentence_feature(2, 1, "state"), 1, "normalized 2.1");

$cluster->compute_sentence_feature( name => "unif", 
    feature => sub { return 0 }, normalize => 1);
is( $cluster->get_sentence_feature(1, 0, "unif"), 1, "unif 1.0");
is( $cluster->get_sentence_feature(1, 1, "unif"), 1, "unif 1.1");
is( $cluster->get_sentence_feature(2, 0, "unif"), 1, "unif 2.0");
is( $cluster->get_sentence_feature(2, 1, "unif"), 1, "unif 2.1");

sub cid_feat {
    my %params = @_;
    return $params{cluster}->get_id();
}

sub did_feat {
    my %params = @_;
    return $params{document}->get_id();
}

sub state_feat {
    my %params = @_;

    unless (defined $params{state}->{feats}) {
        $params{state}->{feats} = { 1 => [1, 2], 2 => [3, 4] };
    }

    my $did = $params{document}->get_id();
    my $index = $params{sentence_index};

    return $params{state}->{feats}->{$did}->[$index];

}

