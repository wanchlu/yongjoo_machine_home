#!/usr/local/bin/perl

# script: test_html.pl
# functionality: Tests the html stripping functionality in Documents 

use strict;
use warnings;
use FindBin;
use Clair::Document;

my $input_dir = "$FindBin::Bin/input/html";

#Take in a single file and parse the html, then document output the file

my $doc = new Clair::Document(type=>'html',file=>"$input_dir/test.html");
print "HTML version:\n";
my $html = $doc->get_html();
print "$html\n";

print "Stripped version:\n";
my $stripped = $doc->strip_html();
print "$stripped\n";
