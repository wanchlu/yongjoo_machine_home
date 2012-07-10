# script: test_sentence_features.t
# functionality: Using a short document, test many sentence feature functions 

# mjschal edited this file.
# I removed a test that intentionally and correctly generated a warning.  This is
# to prevent warning messages from cluttering up the screen for an enduser of 
# Clairlib-core who is testing his or her installation.

use strict;
use Test::More tests => 34;
use Clair::Document;
use Clair::Cluster;

my $text = "This is the first sentence. This is short. So is this. But perhaps the longest sentence of all is the last sentence.";
my $doc = Clair::Document->new( string => $text, type => "text", id => "doc" );


##########################
# Sentence feature tests #
##########################

# Check to make sure the sentences are being split correctly
is($doc->sentence_count(), 4, "Correct # of sents");

# Shouldn't be able to set sentence features for sentences out of range
my $ret = $doc->set_sentence_feature(4, test_feature => 100);
is(undef, $ret, "Can't set out of range features");

# Should be able to set and get sentence features
$ret = $doc->set_sentence_feature(0, test_feature => 100);
ok($ret, "Set in range freatures");
is($doc->get_sentence_feature(0, "test_feature"), 100,
    "Can get sent feat back");

# should return undef if feature doesn't exist
is($doc->get_sentence_feature(1, "test_feature"), undef,
    "Undefined feature returns undef");

# Return undef after feature has been removed
$doc->remove_sentence_feature(0, "test_feature");
is($doc->get_sentence_feature(0, "test_feature"), undef,
    "Undefined after removed feature");

# Set many features at once
my %s0_feats = ( feature1 => 1, feature2 => 2, feature3 => 3);
$doc->set_sentence_feature(0, %s0_feats);
my %got_s0_feats = $doc->get_sentence_features(0);
is_deeply(\%s0_feats, \%got_s0_feats, "Can set/get list of features");

# Compute a simple feature that counts how many ts or Ts there are 
$doc->compute_sentence_feature( name => "count_t", feature => \&count_t );
my @e_feats = (4, 2, 1, 7);
features_ok($doc, "count_t", \@e_feats);

# Compute a feature that copies the document id to check that a reference
# to the document is actually getting passed to the sentence feature
# sub.
$doc->compute_sentence_feature( name => "did", feature => \&did_feat );
@e_feats = ("doc", "doc", "doc", "doc");
features_ok($doc, "did", \@e_feats);

# Compute a feature that returns the index of the document to check that
# this argument is passed to the feature sub.
$doc->compute_sentence_feature( name => "index", feature => \&index_feat );
@e_feats = (0, 1, 2, 3);
features_ok($doc, "index", \@e_feats);


# This next test has been removed because it (intentionally) generates warning
# messages.

# Compute a feature that just dies in order to make sure that a feature 
# calculation can't crash the system.
#eval {
#    no warnings;
#    $doc->compute_sentence_feature( name => "bad", feature => \&bad_feat );
#};
#is("", $@, "stopped from feature dying");
#features_ok($doc, "bad", [undef, undef, undef, undef]);


# See if we can pass state between calls to the feature subroutine
$doc->remove_sentence_features();
$doc->compute_sentence_feature( name => "state", feature => \&state_feat );
features_ok($doc, "state", [0, 1, 2, 3]);

# Make sure that we can normalize sentence features
$doc->remove_sentence_features();
$doc->compute_sentence_feature( name => "count_t", feature => \&count_t, 
    normalize => 1 );
features_ok($doc, "count_t", [1/2, 1/6, 0, 1]);

# Make sure that normalizes correctly with uniform scores
$doc->remove_sentence_features();
$doc->compute_sentence_feature( name => "unif", feature => \&unif, 
    normalize => 1 );
features_ok($doc, "unif", [1, 1, 1, 1]);

$doc->remove_sentence_features();
$doc->compute_sentence_feature( name => "did", feature => \&did_feat );
$doc->compute_sentence_feature( name => "unif", feature => \&unif );
is($doc->is_numeric_feature("did"), 0, "did not numeric feature" );
ok( $doc->is_numeric_feature("unif"), "unif numeric feature" );
$doc->set_sentence_feature(0, mixed => 1);
$doc->set_sentence_feature(1, mixed => 1);
$doc->set_sentence_feature(2, mixed => 1);
$doc->set_sentence_feature(2, mixed => "string");
is( $doc->is_numeric_feature("mixed"), 0, "mixed not numeric" );


sub features_ok {
    my $doc = shift;
    my $name = shift;
    my $expected = shift;
    for (my $i = 0; $i < @$expected; $i++) {
        my $feat = $doc->get_sentence_feature($i, $name);
        is($feat, $expected->[$i], "$name for $i ok");
    }
}

sub count_t {
    my %params = @_;
    my $doc = $params{document};
    my $sent = $params{sentence};
    $sent =~ s/[^tT]//g;
    return length($sent);
}

sub did_feat {
    my %params = @_;
    my $doc = $params{document};
    return $doc->get_id();
}

sub index_feat {
    my %params = @_;
    return $params{sentence_index};
}

sub char_length {
    my %params = @_;
    return length($params{sentence});
}

sub bad_feat {
    die;
}

sub unif {
    return 0;
}

sub state_feat {
    my %params = @_;

    if (defined $params{state}->{count}) {
        $params{state}->{count} = $params{state}->{count} + 1;
    } else {
        $params{state}->{count} = 0;
    }

    return $params{state}->{count};
}
