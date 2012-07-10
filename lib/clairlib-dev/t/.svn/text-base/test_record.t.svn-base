# script: test_record.t
# functionality: As part of Clair::Polisci, confirm Record's Graf selection
# functionality: functionalities, as well as conversion functions. 

use strict;
use warnings;
use Test::More tests => 9;
use Clair::Polisci::Speaker;
use Clair::Polisci::Graf;
use Clair::Polisci::Record;
use Clair::Document;
use Clair::Cluster;

my @speakers;
foreach my $i (0 .. 2) {
    my $speaker = Clair::Polisci::Speaker->new(
        source => "source",
        id => $i
    );
    push @speakers, $speaker;
}

my $record = Clair::Polisci::Record->new( source => "source" );

my @all_grafs;
my @odd_grafs;
my $cluster = Clair::Cluster->new();
foreach my $i (0 .. 5) {
    my $graf = Clair::Polisci::Graf->new(
        source => "source",
        index => $i, 
        content => "This is graf $i. ",
        speaker => $speakers[$i % 3]
    );

    # Add some property to the odd-indexed grafs
    if ($i % 2) {
        $graf->{some_flag} = 1;
        push @odd_grafs, $graf;
    }

    if ($i == 3) {
        $graf->{another_flag} = "on";
    }

    push @all_grafs, $graf;
    $record->add_graf($graf);
    $cluster->insert($i, Clair::Document->new( 
        string=>"This is graf $i. ",
        type => "text"
    ));
}

my $content = "This is graf 0. This is graf 1. This is graf 2. This is graf 3. This is graf 4. This is graf 5. ";
my $doc = Clair::Document->new(
    string => $content,
    type => "text"
);
my @just_3 = ($all_grafs[3]);
my @just_speaker0 = ($all_grafs[0], $all_grafs[3]);

# TEST 1
is($record->size(), 6, "Graf->size()");

# TEST 2
my @result = $record->get_grafs();
is_deeply(\@all_grafs, \@result, "Get all grafs");

# TEST 3
@result = $record->get_grafs( speaker => $speakers[0] );
is_deeply(\@just_speaker0, \@result, "Get just speaker 0");

# TEST 4
@result = $record->get_grafs( some_flag => 1 );
is_deeply(\@odd_grafs, \@result, "Get some_flag grafs");

# TEST 5
@result = $record->get_grafs( another_flag => "on" );
is_deeply(\@just_3, \@result, "Get another_flag grafs");

# TEST 6
@result = $record->get_grafs( another_flag => "foo" );
is_deeply([], \@result, "Get an empty list");

# TEST 7
is($content, $record->to_string(), "to_string");

# TEST 8
is_deeply($doc, $record->to_document(), "Convert to document");

# TEST 9
is_deeply($cluster, $record->to_graf_cluster(), "Convert to graf cluster");
