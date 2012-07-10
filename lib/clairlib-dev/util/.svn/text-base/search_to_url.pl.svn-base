#!/usr/bin/perl
# script: search_to_url.pl
# functionality: Searches on a Google query and prints a list of URLs

use strict;
use warnings;

use Getopt::Std;
use vars qw/ %opt /;
use Clair::Utils::WebSearch;

sub usage;

my $opt_string = "q:n:";
getopts("$opt_string", \%opt) or usage();

my $num_res = 0;
if ($opt{"n"}) {
  $num_res = $opt{"n"};
} else {
  usage();
  exit;
}

my $query = "";
if ($opt{"q"}) {
  $query = $opt{"q"};
} else {
  usage();
  exit;
}


my @results = @{Clair::Utils::WebSearch::googleGet($query, $num_res)};
foreach my $r (@results)  {
  my ($url, $title, $desc) = split('\t', $r);
  print $url, "\n";
}

sub usage {
  print "usage: $0 -q query -n number_of_results\n";
  print "example: $0 -q pancakes -n 10\n";
}
