# script: test_sentence_combiner.t
# functionality: Test a variety of sentence-oriented Document functions, such
# functionality: as sentence scoring, and combining sentence feature scores 

# mjschal edited this file.
# I removed the one test that generates a warning message in order to not have
# warnings cluttering up the screen when an installation of clairlib-core is
# being tested by an end-user.

use strict;
use Test::More tests => 15;
use Clair::Document;

my $text = "The first sentence ends with a period. Does the second sentence? "
         . "Last sentence here!";
my $doc = Clair::Document->new( string => $text, did => "doc", type => "text" );

# Make sure that scores are undefined at the beginning
is($doc->get_sentence_score(0), undef, "can't get uncomputed scores");

# Compute some simple test features. This assumes that the tests for that
# part of the code have already passed.
$doc->compute_sentence_feature( name => "has_q_mark", feature => \&has_q_mark );
$doc->compute_sentence_feature( name => "char_length", 
    feature => \&char_length );

# Get a basic combiner that does a linear combination.
my $combiner = linear_combiner( has_q_mark => 10, char_length => 1 );

# Score the sentences and normalize them
$doc->score_sentences( combiner => $combiner );
my @expected = (1, 16/19, 0);
scores_ok($doc, \@expected, "score_sentences");

# Test the default weight method
$doc->score_sentences( weights => { has_q_mark => 10, char_length => 1} );
scores_ok($doc, \@expected, "score_sentences with default weights");

# Score the sentences, but don't normalize
$doc->score_sentences( combiner => $combiner, normalize => 0 );
@expected = (39, 36, 20);
scores_ok($doc, \@expected, "score_sentences without normalizing");

# A one sentence document should just output its score as 1 (normalized)
my $unit_doc = Clair::Document->new( string => "One sent.", type => "text", 
    did => "unit" );
$unit_doc->compute_sentence_feature( name => "char_length", 
    feature => \&char_length );
$unit_doc->score_sentences( combiner => $combiner );
@expected = (1);
scores_ok($unit_doc, \@expected, "score_sentences with only one sentence");

# Case when score isn't normalized
$unit_doc->score_sentences( combiner => $combiner, normalize => 0 );
@expected = (10);
scores_ok($unit_doc, \@expected, "score_sentences one sent no normalize");

# Give all sentences the same feature, and the resulting scores should be 1
my $doc2 = Clair::Document->new( string => $text, type => "text" );
$doc2->compute_sentence_feature( name => "uniform", feature => \&uniform );
$doc2->score_sentences( combiner => linear_combiner( uniform => 1 ) );
@expected = (1, 1, 1);
scores_ok($doc2, \@expected, "score_sentences uniform feature");


# The following test has been removed because it (intentionally) generates
# a warning message.

# A combiner should always return a real number
# my $doc3 = Clair::Document->new( string => $text, type => "text" );
# $doc3->compute_sentence_feature( name => "uniform", feature => \&uniform );
# my $ret = $doc3->score_sentences( combiner => \&bad_combiner );
# is($ret, undef, "Combiner should always return a real number");


sub scores_ok {
    my $doc = shift;
    my $expected = shift;
    foreach my $i ( 0 .. ($doc->sentence_count() - 1) ) {
        is($doc->get_sentence_score($i), $expected->[$i], "score $i ok");
    }
}

sub has_q_mark {
    my %params = @_;
    chomp $params{sentence};
    if ($params{sentence} =~ /\?/) {
        return 1;
    } else {
        return 0;
    }
}

sub char_length {
    my %params = @_;
    return length($params{sentence});
}

sub uniform {
    return 0;
}

sub linear_combiner {
    my %weights = @_;
    my $combiner = sub {
        my %features = @_;
        my $score = 0;
        foreach my $name (keys %weights) {
            if ($features{$name}) {
                $score += $weights{$name} * $features{$name};
            }
        }
        return $score;
    };
}

sub bad_combiner {
    return "text";
}
