#!/usr/local/bin/perl

# script: test_document.pl
# functionality: Creates Documents from strings, files, strips and stems them,
# functionality: splits them into lines, sentences, counts words, saves them 

use strict;
use warnings;
use FindBin;
use Clair::Document;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/document";
my $gen_dir = "$basedir/produced/document";

# Create a text document specifying the text directly
my $doc1 = new Clair::Document(string => 'She sees the facts with instruments happily with embarassements.',
		               type => 'text', id => 'doc1');

# Create a text document by specifying the file to open
my $doc2 = new Clair::Document(file => "$input_dir/test.txt",
	                       type => 'text', id => 'doc2');

# Create an HTML document
my $doc3 = new Clair::Document(string => '<html><body><p>This is the HTML</p>'
	                       . '<p>She sees the facts with instruments happily with embarassements.</p></body></html>',
			       type => 'html', id => 'doc3');

# Compute the text from the HTML
my $doc3_text = $doc3->strip_html;
print "The text from document 3:\n$doc3_text\n\n";

# Stem the text of the document
my $doc3_stem = $doc3->stem;
print "The stemmed text from document 3:\n$doc3_stem\n\n";

# Split the document into lines and sentences
# (Note that split_into_sentences uses MxTerminator which requires
# Perl 5.8)
my @doc3_lines = $doc3->split_into_lines;
my @doc3_sentences = $doc3->split_into_sentences;
print "\nDocument 3 has ", scalar @doc3_sentences, " sentences.\n\n"; 

# Count the number of words in each document
my $doc1_words = $doc1->count_words;
my $doc2_words = $doc2->count_words;
my $doc3_words = $doc3->count_words;
print ("Document 1 has $doc1_words words, Document2 has $doc2_words, and Document 3 has $doc3_words.\n");

# Print the text version to the screen, then saved the stemmed version to disk
print "The text from document 3 is:\n";
$doc3->print(type => 'text');
print "\n";
$doc3->save(file => "$gen_dir/document_output.stem", type => 'stem');
