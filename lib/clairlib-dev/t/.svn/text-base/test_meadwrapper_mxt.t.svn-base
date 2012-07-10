# script: test_meadwrapper_mxt.t
# functionality: Test basic Clair::MEAD::Wrapper functions, such as
# functionality: summarization, varying compression ratios, feature sorting,
# functionality: etc., having assumed the use of MxTerminator as a sentence
# functionality: splitting tool 

use strict;
use warnings;
use FindBin;
use Clair::Config;
use Test::More;

use vars qw($SENTENCE_SEGMENTER_TYPE $JMX_HOME);

if (not defined $MEAD_HOME or not -d $MEAD_HOME) {
    plan( skip_all => 
        '$MEAD_HOME not defined in Clair::Config or doesn\'t exist' );
} else {
    if (not defined $JMX_HOME) {
        plan( skip_all => '$JMX_HOME not defined in Clair::Config.' );
    } else {
        plan( tests => 15 );
    }
}

my $old_SENTENCE_SEGMENTER_TYPE = $SENTENCE_SEGMENTER_TYPE;
$SENTENCE_SEGMENTER_TYPE = "MxTerminator";

use_ok("Clair::MEAD::Wrapper");
use_ok("Clair::Cluster");
use_ok("Clair::Document");

my $cluster_dir = "$FindBin::Bin/produced/meadwrapper";
my $cluster = Clair::Cluster->new();
$cluster->load_documents("$FindBin::Bin/input/meadwrapper/*");

my $mead = Clair::MEAD::Wrapper->new( 
    mead_home => $MEAD_HOME,
    cluster => $cluster,
    cluster_dir => $cluster_dir
);

my %files = ( "fed1.txt" => 1, "fed2.txt" => 1, "41" => 1);
my @dids = $mead->get_dids();
for (@dids) {
    ok(exists $files{$_}, "listing dids: $_ exists");
}


map { delete $ENV{$_} } keys %ENV;

my @summary1 = $mead->run_mead();
is(@summary1, 13, "Generic summary");

$mead->add_option("-s -p 100");
my @summary2 = $mead->run_mead();
is(@summary2, 64, "No compression");
# This test is only appropriate for Text::Sentence.
#is(@summary2, 61, "No compression");

my @expected_features = sort ("Centroid", "Length", "Position");
my @features = sort $mead->get_feature_names();

is(scalar @features, scalar @expected_features, "Feature names");

for (my $i = 0; $i < @features; $i++) {
    ok($features[$i] eq $expected_features[$i], 
        "Feature names: $features[$i]");
}

my %features = $mead->get_feature("Centroid");
my $centroid_41 = scalar @{ $features{"41"} };
my $centroid_fed1 = scalar @{ $features{"fed1.txt"} };
my $centroid_fed2 = scalar @{ $features{"fed2.txt"} };

is($centroid_41, 26, "Centroid scores: 41");
is($centroid_fed1, 21, "Centroid scores: fed1.txt");
is($centroid_fed2, 18, "Centroid scores: fed2.txt");

$SENTENCE_SEGMENTER_TYPE = $old_SENTENCE_SEGMENTER_TYPE;
