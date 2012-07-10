# script: test_mead_summary.t
# functionality: Tests the ability of Clair::MEAD::Summary to preserve
# functionality: features of sentences and other basic functions 

use strict;
use warnings;
use Test::More tests => 14;
use Clair::MEAD::Summary;

# Testing on this object
my $extract = [
    {
        TEXT => "Sentence one.",
        DID => 1,
        SNO => 2,
        RSNT => 2,
        PAR => 1,
        FEATURES => 
            {
                "Feature1" => 1,
                "Feature2" => 2,
                "Feature3" => 3
            }
    },
    {
        TEXT => "Sentence two.",
        DID => 1,
        SNO => 3,
        RSNT => 2,
        PAR => 1,
        FEATURES => 
            {
                "Feature1" => 1,
                "Feature2" => 2,
                "Feature3" => 3
            }
    },
    {
        TEXT => "Sentence three.",
        DID => 2,
        SNO => 1,
        RSNT => 1,
        PAR => 2,
        FEATURES => 
            {
                "Feature1" => 1,
                "Feature2" => 2,
                "Feature3" => 3
            }
    },
    {
        TEXT => "Sentence four.",
        DID => 2,
        SNO => 2,
        RSNT => 1,
        PAR => 1,
        FEATURES => 
            {
                "Feature1" => 1,
                "Feature2" => 2,
                "Feature3" => 3
            }
    },
];

my $summary = Clair::MEAD::Summary->new($extract);

is($summary->size(), 4, "Four sents");

is($summary->to_string(), "Sentence one. Sentence two. Sentence three. Sentence four.", "Default order");

my %order = ( 1 => 2, 2 => 1 );
$summary->set_doc_order(%order);
is($summary->to_string(), "Sentence three. Sentence four. Sentence one. Sentence two.", "Reorder");

my @dids = sort $summary->get_dids();
is_deeply(\@dids, [1, 2], "DIDs");

is(undef, $summary->get_sent(0), "Zero sent undef");
is(undef, $summary->get_sent(5), "Five sent undef");

$summary->set_doc_order(1 => 1, 2 => 2);

my $esent = {
    text => "Sentence one.",
    sno => 2,
    did => 1,
    rsnt => 2,
    par => 1
};
my %sent = $summary->get_sent(1);
#is_deeply($esent, \%sent, "Get sentence by index");

is($esent->{text}, $summary->get_text(1), "get_text");
is($esent->{sno}, $summary->get_sno(1), "get_sno");
is($esent->{did}, $summary->get_did(1), "get_did");
is($esent->{rsnt}, $summary->get_rsnt(1), "get_rsnt");
is($esent->{par}, $summary->get_par(1), "get_par");

is(undef, $summary->get_features(0), "Zero feat undef");
is(undef, $summary->get_features(5), "Five feat undef");

my $efeats = {
    Feature1 => 1,
    Feature2 => 2,
    Feature3 => 3,
};
my %feats = $summary->get_features(1);
is_deeply($efeats, \%feats, "features");


