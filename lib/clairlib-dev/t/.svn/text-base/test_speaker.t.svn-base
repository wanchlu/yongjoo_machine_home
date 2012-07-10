# script: test_speaker.t
# functionality: As part of Clair::Polisci, confirm Speaker object equality
# functionality: functions 

use strict;
use warnings;
use Test::More tests => 5;
use Clair::Polisci::Speaker;

my $speaker;

# TEST 1

eval {
    $speaker = Clair::Polisci::Speaker->new();
};
ok($@, "new w/o a source or id should die");

my $speaker1 = Clair::Polisci::Speaker->new(
    source => "source1",
    id => 1
);

my $speaker2 = Clair::Polisci::Speaker->new(
    source => "source1",
    id => 1
);

my $speaker3 = Clair::Polisci::Speaker->new(
    source => "source2",
    id => 1
);


# TEST 2
ok($speaker1->equals($speaker1), "Speaker should equal self");

# TEST 3
ok($speaker1->equals($speaker2), "Speaker 1 should equal speaker 2");

# TEST 4
ok($speaker2->equals($speaker1), "Speaker 2 should equal speaker 1");

# TEST 5
ok(!$speaker3->equals($speaker1), "Speaker 1 shouldn't equal speaker 3");
