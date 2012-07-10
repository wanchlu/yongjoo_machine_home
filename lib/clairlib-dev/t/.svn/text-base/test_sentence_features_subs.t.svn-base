# script: test_sentence_features_subs.t
# functionality: Test the assignment of standard features, such as length,
# functionality: position, and centroid, to sentences in a small Document 

use strict;
use Test::More tests => 8;
use Clair::Document;
use Clair::SentenceFeatures qw(length_feature position_feature centroid_feature);

my $text = "Roses are red. Violets are blue. Sugar is sweet. This is the longest sentence.";
my $doc = Clair::Document->new(string => $text);

my %feats = ( 
    lf => \&length_feature, 
    pf => \&position_feature,
#    cf => \&centroid_feature
);

my %expected = (
    lf => [3, 3, 3, 5],
    pf => [1, 3/4, 2/4, 1/4]
);

$doc->compute_sentence_features(%feats);

features_ok($doc, "lf", $expected{lf});
features_ok($doc, "pf", $expected{pf});

sub features_ok {
    my $doc = shift;
    my $name = shift;
    my $expected = shift;
    for (my $i = 0; $i < @$expected; $i++) {
        my $feat = $doc->get_sentence_feature($i, $name);
        is($expected->[$i], $feat, "$name for $i ok");
    }
}

