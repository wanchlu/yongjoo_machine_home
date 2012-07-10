# script: test_eutils.t
# functionality: Test Clair::Bio::EUtils' hash2args and build_url 

use strict;
use Clair::Bio::EUtils qw(hash2args build_url);
use Test::More tests => 3;

my %hash = (
    foo => "bar",
    baz => "qux",
    '<foo>' => "hello world"
);

my $str = hash2args(%hash);
is($str, "%3Cfoo%3E=hello%20world&baz=qux&foo=bar", "hash2args");

%hash = ( foo => "bar" );
my $base1 = "http://foo.bar/thing.cgi";
my $base2 = "http://foo.bar/thing.cgi?";

is(build_url(base => $base1, args => \%hash), "$base1?foo=bar", "build_url");
is(build_url(base => $base2, args => \%hash), "$base1?foo=bar", "build_url 2");
