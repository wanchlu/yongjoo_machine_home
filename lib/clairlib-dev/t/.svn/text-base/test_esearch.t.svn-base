# script: test_esearch.t
# functionality: Perform a few basic ESearch queries 

use strict;
use warnings;
use Test::More tests => 6;
use Clair::Bio::EUtils::ESearch;

my %query = (
    term => "cancer",
    reldate => 60,
    datetype => "edat",
    retmax => 100
);

my $esearch = new Clair::Bio::EUtils::ESearch(%query);
my @ids = @{ $esearch->{IdList} };

is(scalar @ids, 100, "Return 100");

# Each ID should be at least 5 digits long
my $ok = 1;
foreach my $id (@ids) {
    if ($id < 10000) {
        $ok = 0;
        last;
    }
}
ok($ok, "IDs are large enough");
is($esearch->{RetMax}, 100, "RetMax");
ok(length($esearch->{WebEnv}) >= 10, "WebEnv long enough");

# Wait before making another query
sleep(3);

%query = (
    term => "david states",
    mindate => "2002/10/15",
    maxdate => "2002/11/30"
);
$esearch = new Clair::Bio::EUtils::ESearch(%query);
@ids = @{ $esearch->{IdList} };
is(scalar @ids, 1, "idlist");
is($ids[0], 12434005, "first id");
