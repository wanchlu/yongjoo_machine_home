# script: test_xmldoc.t
# functionality: Test the get_text and get_sent functions of Document, basing
# functionality: them on an XML file input to Document 

use strict;
use warnings;
use Test::More tests => 3;
use Clair::Document;
use Clair::Cluster;
use FindBin;

my $doc = Clair::Document->new(
			    file => "$FindBin::Bin/input/xmldoc/dow-clean.xml",
			    type => "xml");

$doc->xml_to_text();

my $text = $doc->get_text;
like($text, qr/combining traditional craftsmanship/, "get_text");

my @sent = $doc->get_sent;
like($sent[3], qr/Ludivine Sagnier/, "get_sent 3");
like($sent[5], qr/craftsmanship/, "get_sent 5");

