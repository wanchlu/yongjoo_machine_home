# script: test_graf.t
# functionality: As part of Clair::Polisci, test basic Graf functions like
# functionality: to_document 

use strict;
use Clair::Polisci::Graf;
use Clair::Polisci::Speaker;
use Test::More tests => 4;


# TEST 1

eval {
    my $graf = Clair::Polisci::Graf->new();
};
ok($@, "Graf needs source, index, content, speaker");
undef $@;



my $speaker = Clair::Polisci::Speaker->new(
    source => "source",
    id => "speakerID"
);

my $content = "Sentence one. Sentence two. Sentence three.";
my @exp_sents = ( "Sentence one.", "Sentence two.", "Sentence three." );

my $graf = Clair::Polisci::Graf->new(
    source => "source",
    index => 1,
    content => $content,
    speaker => $speaker
);

my $doc = $graf->to_document();
my @sents = $doc->split_into_sentences();
foreach my $i (0 .. $#exp_sents) {
    my $exp_sent = $exp_sents[$i];

    # TESTS 2 - 4
    like($sents[$i], qr/$exp_sent/, "Split into sents ($i)");
}
