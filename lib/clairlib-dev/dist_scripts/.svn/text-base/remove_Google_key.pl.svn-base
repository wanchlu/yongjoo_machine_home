#!/usr/bin/perl

use strict;

# Remove the Google key from the clairlib version
my $date = `date -I`;
chomp $date;

my $web_search_pm = `cat /data0/projects/clairlib/$date/lib/Clair/Config.pm`;

$web_search_pm =~ s/.*#GOOGLE_KEY.*\n//g;
$web_search_pm =~ s/#GOOGLE_NOKEY\s*//g;

open WEB_SEARCH, "> /data0/projects/clairlib/$date/lib/Clair/Config.pm" or die "Unable to write back modified WebSearch.pm";

print WEB_SEARCH $web_search_pm;
close WEB_SEARCH;
