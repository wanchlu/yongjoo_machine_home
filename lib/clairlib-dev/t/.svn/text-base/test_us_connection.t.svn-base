# script: test_us_connection.t
# functionality: Test the Clair::Polisci::US::Connection class and the
# functionality: contents of the underlying DB.  This test is not intended
# functionality: for general distribution (i.e. you may not have it in your
# functionality: copy of clairlib) 

use strict;
use Test::More;
use Clair::Polisci::US::Connection;

my $con = Clair::Polisci::US::Connection->new(
    user => "root",
    password => "",
    host => "localhost",
    database => "polisci_us"
);

# mjschal adds the following sanity check to make sure that this set of tests is only
# run if the above creation of a Connection successfully results in a connection to
# a DB.  For instance, the server this code is running on may not have a MYSQL server
# installed, which means that $con->{dbh} may equal undef.

if ($con->{dbh}) {
    plan(tests => 9);
} else {
    plan(skip_all => "because Connection object created, but cannot connect to a DB");
}

my @result;
my %mask = (
    min_date => "2004-11-01",
    max_date => "2004-11-30"
);

# TEST 1 - all nov records
@result = $con->get_records(%mask);
is(scalar @result, 846, "November size");

# TEST 2 - just the house
$mask{chamber} = "House";
@result = $con->get_records(%mask);
is(scalar @result, 445, "November house size");

# TEST 3 - just the senate
$mask{chamber} = "Senate";
@result = $con->get_records(%mask);
is(scalar @result, 401, "Novemeber senate size");

# TEST 4 - find some title matches
%mask = (
    min_date => "1999-04-13",
    max_date => "1999-04-15",
    chamber => "House",
    title_regex => "PRAYER"
);
@result = $con->get_records(%mask);
is(scalar @result, 2, "Two prayers");

# TEST 5 - body regex to get rid of one prayer
$mask{body_regex} = "earnest";
@result = $con->get_records(%mask);
is(scalar @result, 1, "One prayer");

# TESTS 6-9 - make sure the record/grafs are loaded correctly
%mask = (
    min_date => "1999-04-13",
    max_date => "1999-04-15",
    chamber => "House",
    title_regex => "CAMPAIGN FINANCE REFORM",
    body_regex => "Blue Dog Caucus"
);
@result = $con->get_records(%mask);
is(scalar @result, 1, "get records");
my $record = $result[0];
my @speech_grafs = $record->get_grafs(
    graf_type_id => 1
);
is(scalar @speech_grafs, 5);
like($speech_grafs[0]->{content}, /Blue Dog Caucus/, "content check");

my @non_speech_grafs = $record->get_grafs(
    graf_type_id => 2
);
is(scalar @non_speech_grafs, 2, "get_grafs");
