# script: test_summary.t
# functionality: Test many basic functions of Document for summarization,
# functionality: varying summarization ratio, order conditions, as well as
# functionality: test Cluster's summarization functions 

use strict;
use Test::More tests => 117;
use Clair::Cluster;
use Clair::Document;
use Clair::SentenceFeatures qw(:all);

# Some sample text for the documents
my $text1 = "Mary had a little lamb. Her fleece was white as snow (the lamb's fleece, that is).";
my $text2 = "Jack and Jill went up the hill. Then they rode their bikes down the hill.";
my $text3 = "She's a jar with a heavy lid. She's my pop-quiz kid. You know she begs me not to miss her.";

# Make the docs and put them in a cluster
my $cluster = Clair::Cluster->new();
my $doc1 = make_doc($text1, "doc1");
my $doc2 = make_doc($text2, "doc2");
my $doc3 = make_doc($text3, "doc3");

# Compute the features
my %features = ('length' => \&length_feature, 'position' => \&position_feature);
my %weights = ( 'length' => 1, 'position' => 1 );
$cluster->compute_sentence_features(%features);

# Test the summaries
$doc1->score_sentences(weights => \%weights);
my @summary = $doc1->get_summary();
my @expected = ( 0, 1 );
doc_summary_ok( \@summary, \@expected, $doc1, "no size" );

# smmaller sized summary
@summary = $doc1->get_summary( size => 1 );
@expected = ( 1 );
doc_summary_ok( \@summary, \@expected, $doc1, "size" );

# ignore natural sent order
@summary = $doc1->get_summary( preserve_order => 0 );
@expected = ( 1, 0 );
doc_summary_ok( \@summary, \@expected, $doc1, "unpreserved order" );

# try to get more than two sents
@summary = $doc1->get_summary( size => 10 );
@expected = (0, 1);
doc_summary_ok( \@summary, \@expected, $doc1, "take > 2" );

# Try it with a larger document
$doc3->score_sentences( weights => \%weights );
@summary = $doc3->get_summary( size => 2 );
@expected = ( 0, 2 );
doc_summary_ok( \@summary, \@expected, $doc3, "larger doc, size" );

# ignore order
@summary = $doc3->get_summary( preserve_order => 0 );
@expected = ( 2, 0, 1 );
doc_summary_ok( \@summary, \@expected, $doc3, "larger doc, unpres. order" );

# now do a cluster-wide test.  
$cluster->score_sentences( weights => \%weights );
@summary = $cluster->get_summary( size => 4 );
@expected = ( ["doc1", 1], ["doc2", 0], ["doc2", 1], ["doc3", 2] );
cluster_summary_ok(\@summary, \@expected, $cluster, "default cluster");

@summary = $cluster->get_summary( size => 4, preserve_order => 0 );
@expected = ( ["doc1", 1], ["doc3", 2], ["doc2", 1], ["doc2", 0] );
cluster_summary_ok(\@summary, \@expected, $cluster, "no order");

# specify a document ordering
@summary = $cluster->get_summary( size => 4, 
    document_order => [ "doc3", "doc1", "doc2" ]);
@expected = ( ["doc3", 2], ["doc1", 1], ["doc2", 0], ["doc2", 1] );
cluster_summary_ok(\@summary, \@expected, $cluster, "spec order");

sub make_doc {
    my $text = shift;
    my $did = shift;
    my $doc = Clair::Document->new( string => $text, id => $did );
    $cluster->insert($did, $doc);
    return $doc;
}

sub doc_summary_ok {
    my $summary = shift;
    my $expected = shift;
    my $doc = shift;
    my $name = shift || "";
    my $did = $doc->get_id();
    is( scalar @$summary, scalar @$expected, "summary length $name" );

    my @sents = $doc->get_sentences();
    for (my $i = 0; $i < @$summary; $i++) {
        my $exp_index = $expected[$i];
        my $text = $sents[$exp_index];
        my %feats = $doc->get_sentence_features($exp_index);
        my $score = $doc->get_sentence_score($exp_index);

        my $sent_map = $summary->[$i];
        
        is( $sent_map->{'index'}, $exp_index, "index sent $did.$i $name" );
        is( $sent_map->{text}, $text, "text sent $did.$i $name" );
        is_deeply( $sent_map->{features}, \%feats, "feats sent $did.$i $name" );
        is( $sent_map->{score}, $score, "score sent $did.$i $name" );
    }

}

sub cluster_summary_ok {
    my $summary = shift;
    my $expected = shift;
    my $cluster = shift;
    my $name = shift || "noname";

    is( scalar @$summary, scalar @$expected, "summary length" );
    my $docs = $cluster->documents();

    for (my $i = 0; $i < @$summary; $i++) {
        my ($exp_did, $exp_index) = @{ $expected->[$i] };
        my @sents = $docs->{$exp_did}->get_sentences();
        my $text = $sents[$exp_index];
        my %feats = $cluster->get_sentence_features($exp_did, $exp_index);
        my $score = $cluster->get_sentence_score($exp_did, $exp_index);
        my $sent_map = $summary->[$i];

        is( $sent_map->{did}, $exp_did, "$name: did sent $i" );
        is( $sent_map->{'index'}, $exp_index, "$name: index sent $i" );
        is_deeply( $sent_map->{features}, \%feats, "$name: feats sent $i");
        is( $sent_map->{score}, $score, "$name: score sent $i" );
        is( $sent_map->{text}, $text, "$name: text sent $i" );
    }

}
