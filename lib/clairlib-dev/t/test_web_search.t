# script: test_web_search.t
# functionality: Test Clair::Utils::WebSearch and its use of the Google
# functionality: search API for returning varying numbers of webpages
# functionality: in response to queries 

use strict;
use warnings;
use FindBin;
use Clair::Config;
use Test::More;

if (not defined $GOOGLE_DEFAULT_KEY) {
    plan(skip_all => "GOOGLE_DEFAULT_KEY not defined in Clair::Config");
} else {
    plan(tests => 5);
}

use_ok('Clair::Utils::WebSearch');
use_ok('Clair::Util');

my $file_gen_dir = "$FindBin::Bin/produced/web_search";
my $file_exp_dir = "$FindBin::Bin/expected/web_search";

Clair::Utils::WebSearch::download("http://tangra.si.umich.edu/", 
   "$file_gen_dir/tangrapage");
ok(compare_proper_files("tangrapage"), "WebSearch::download" );

my @results = @{Clair::Utils::WebSearch::googleGet("Westminster Abbey", 15)};
# We cannot be sure what the results will be, but we can be pretty safe
# that there will be at least 15

is(scalar @results, 15, "googleGet 1");

@results = @{Clair::Utils::WebSearch::googleGet("Arwad Island", 25)};
# Again, we don't know how what the results will be, but this call should
# return exactly 25
is(scalar @results, 25, "googleGet 2");


# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
  my $filename = shift;

  return Clair::Util::compare_files("$file_exp_dir/$filename", "$file_gen_dir/$filename");
}

