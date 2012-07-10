#!/usr/local/bin/perl

# script: genericdoc.pl
# functionality: Tests parsing of simple text/html file/string, conversion
# functionality: into xml file, instantiation via constructor and morph()

use strict;
use FindBin;
use Data::Dumper;
use Clair::GenericDoc;

my $DEBUG = 0;
my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/document";
my $output_dir = "$basedir/produced/genericdoc";
my $testtxt = "$input_dir/test.txt";
my $testhtml = "$input_dir/test.html";


my $doc = new Clair::GenericDoc(
 content => $testtxt,
 use_system_file_cmd => 1,
 DEBUG => $DEBUG,
);

$doc->debugmsg("testing with $testtxt", 0);

  my $type = $doc->document_type($testtxt);

$doc->debugmsg("OK - document type is: $type", 0) if $type;


$doc->debugmsg("extracting content of $testtxt", 0);

  my $result = $doc->extract();

$doc->debugmsg("OK - content:\n". Dumper($result), 0) if $result;


$doc->debugmsg("converting to xml", 0);

  my $xml = $doc->to_xml($result->[0]);
  $doc->save_xml($xml, "$output_dir/test.xml");

$doc->debugmsg("saving to: $output_dir/test.xml", 0);
$doc->debugmsg("OK - output exists $output_dir/test.xml", 0) if -f "$output_dir/test.xml";


$doc->debugmsg("reading from xml", 0);

  my $hash = $doc->from_xml("$output_dir/test.xml");

$doc->debugmsg("OK - content:\n". Dumper($hash), 0) if scalar keys %$hash;



$doc->debugmsg("testing with $testhtml", 0);

  my $type2 = $doc->document_type($testhtml);

$doc->debugmsg("OK - document type is: $type2", 0) if $type2;


$doc->debugmsg("extracting content of $testhtml", 0);

	$doc->{content} = $testhtml;
	$doc->{stem} = 0; # suppress stemming
	$doc->{lowercase} = 0; # suppress lowercasing
  my $result2 = $doc->extract();

$doc->debugmsg("OK - content:\n". Dumper($result2), 0) if $result2;


$doc->debugmsg("using the shakespear parser module", 0);
# by supplying "use_parser_module", you can force the system to use 
# a specific parsing module.
my $doc2 = new Clair::GenericDoc(
 use_parser_module => "shakespear",
 content => $testhtml,
 # use_system_file_cmd => 1,
 DEBUG => $DEBUG,
);

my $result3 = $doc2->extract();

$doc->debugmsg("content:\n". Dumper($result3), 0);



my $doc3 = new Clair::GenericDoc(
 use_parser_module => "shakespear",
 content => $testhtml,
 # use_system_file_cmd => 1,
 DEBUG => $DEBUG,
 cast => 1, # we want the return object to be Clair::Document
);

print "Notice the Clair::Genericdoc gives you the ability to dynamically instantiate Clair::Document\n";
$doc->debugmsg("OK - properly converted:\n" . Dumper($doc3)) if UNIVERSAL::isa($doc3, "Clair::Document");

$doc3->strip_html();
my $count = $doc3->count_words();
print "The Clair::Document object has text:\n". $doc3->{text} . "\n";
print "The Clair::Document object has $count words\n";



my $doc4 = $doc->morph();
print "What happens when you 'morph()' the existing Clair::Genericdoc object?\n";
print Dumper($doc4);
