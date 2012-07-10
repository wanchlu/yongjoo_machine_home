# script: test_document.t
# functionality: Test basic Document functionality: stripping, splitting,
# functionality: TF generation, filtering, etc. 

use strict;
use warnings;
use Test::More tests => 28;
use FindBin;

use_ok('Clair::Document');
use_ok('Clair::Cluster');

my $file_gen_dir = "$FindBin::Bin/produced/document";
my $file_input_dir = "$FindBin::Bin/input/document";

my $doc1 = Clair::Document->new(
    string => 'I am some pretty nifty text...',
    type => 'text',
);

# Test word count
is($doc1->count_words(), 6, "word count");


# Test for correct html stripping
my $doc2 = Clair::Document->new( file => "$file_input_dir/test.html", 
    type => 'html');
my $stripped_text = $doc2->strip_html();
is($stripped_text, "This is a test.\n\n", "strip_html");


# Test for split_into_lines
my $doc3 = Clair::Document->new( file => "$file_input_dir/test.txt", 
    type => 'text');
my $line_count = scalar $doc3->split_into_lines();
is($line_count, 5, "split_into_lines");


# Test for split_into_sentences
my $sentence_count = scalar $doc3->split_into_sentences();
is($sentence_count, 7, "split_into_sentences");




# Make sure that we can get the stemmed document without calling stem 
# directly.
my $stem_doc = Clair::Document->new( string => "This is unstemmed text.",
    type => "text" );
my $stemmed_text = $stem_doc->get_stem();
ok(defined $stemmed_text, "get_stem");

# Test TF calculations
my $text = "Cat cats dog mouse mouse mouse dog.";
my $doc = Clair::Document->new( string => $text, type => "text", id => 1 );
my %tf = $doc->tf();

is(scalar keys %tf, 3, "numterms stemmed");
is($tf{cat}, 2, 'tf{cat} stemmed');
is($tf{dog}, 2, 'tf{dog} stemmed');
is($tf{mous}, 3, 'tf{mous} stemmed');

# should be able to do an unstemmed version
%tf = $doc->tf( type => "text");
is(scalar keys %tf, 4, "numterms stemmed");
is($tf{Cat}, 1, 'tf{Cat} unstemmed');
is($tf{cats}, 1, 'tf{cats} unstemmed');
is($tf{dog}, 2, 'tf{dog} unstemmed');
is($tf{mouse}, 3, 'tf{mouse} unstemmed');

%tf = $doc->tf( type => "text", punc => 1);
is(scalar keys %tf, 5, "numterms stemmed");
is($tf{Cat}, 1, 'tf{Cat} unstemmed');
is($tf{cats}, 1, 'tf{cats} unstemmed');
is($tf{dog}, 2, 'tf{dog} unstemmed');
is($tf{p_period}, 1, 'tf{p_period} unstemmed');
is($tf{mouse}, 3, 'tf{mouse} unstemmed');
# Get stemmed unique words
$doc = Clair::Document->new( string => "Cat dog cats.", type => "text" );
$doc->stem();
my @words = sort $doc->get_unique_words( type => "stem" );
is_deeply(\@words, ["cat", "dog"], "stemmed unique words");

# Shouldn't automatically stem
$doc = Clair::Document->new( string => "Cat cats cat cat", type => "text");
@words = sort $doc->get_unique_words( type => "text" );
is_deeply(\@words, ["Cat", "cat", "cats"], "unstemmed unique words");

# Should default to getting stemmed
$doc = Clair::Document->new( string => "Cat cats cat cat", type => "text");
$doc->stem();
@words = sort $doc->get_unique_words();
is_deeply(\@words, ["cat"], "stemmed unique words default");

# Filter sentences from a document
$doc = Clair::Document->new( 
    string => "I like rice. Rice is good. I prefer to eat it with soy sauce.", 
    type => "text", id => "doc" );
my $filtered_doc = $doc->filter_sents( matches => "(?i)rice" );
like($filtered_doc->get_text(), qr/I like rice\.Rice is good\./,
    "fileterd by match");
is($filtered_doc->get_id(), "doc", "preserves id");
$filtered_doc = $doc->filter_sents( test => sub { length($_) >= 25 } );
like($filtered_doc->get_text(), qr/I prefer to eat it with soy sauce\./, 
    "filtered by sub");

