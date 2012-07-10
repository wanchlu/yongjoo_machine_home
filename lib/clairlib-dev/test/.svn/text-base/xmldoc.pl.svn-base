#!/usr/local/bin/perl

# script: test_xmldoc.pl
# functionality: Tests the XML to text function of Document 

use strict;
use warnings;
use Clair::Document;
use Clair::Cluster;
use FindBin;

my $doc = Clair::Document->new(
			    file => "$FindBin::Bin/input/xmldoc/dow-clean.xml",
			    type => "xml");

$doc->xml_to_text();
my $text = $doc->get_text();
print "Text:\n$text\n";

my @sents = $doc->get_sent();
print "Sentences:\n";
my $i = 1;
for (@sents) {
    print "$i $_\n";
    $i++;
}
