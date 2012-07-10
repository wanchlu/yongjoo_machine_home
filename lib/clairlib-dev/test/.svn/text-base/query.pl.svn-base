#!/usr/local/bin/perl

# script: query.pl
# functionality: Requires indexes to be built via index_*.pl scripts, shows
# functionality: queries implemented in Clair::Info::Query, single-word and
# functionality: phrase queries, meta-data retrieval methods

use strict;
use FindBin;
# use lib "$FindBin::Bin/../lib";
# use lib "$FindBin::Bin/lib"; # in case you are outside the current dir
use vars qw/$DEBUG/;

use Benchmark;
use Clair::Index;
use Clair::Info::Query;
use Data::Dumper;
use POSIX;


$DEBUG = 0;
my %args;
# my @indexes = qw/word_idx document_idx document_meta_idx/;


$DEBUG = 0;
my $index_root = "$FindBin::Bin/produced/index_mldbm",
my $index_root_dirfiles = "$FindBin::Bin/produced/index_dirfiles",
my $stop_word_list = "$FindBin::Bin/input/index/stopwords.txt";


my $t0;
my $t1;

#
# Initializing index
#
$t0 = new Benchmark;

  # instantiate the index object first.
  my $idx = new Clair::Index(DEBUG => $DEBUG, index_root => $index_root);

  $idx->debugmsg("pre-loading necessary meta indexes.. please wait", 0);

	# and then pass the index object into the query constructor.
  my $q = new Clair::Info::Query(DEBUG => $DEBUG, index_object => $idx, , stop_word_list => $stop_word_list);

$t1 = new Benchmark;
my $timediff_init = timestr(timediff($t1, $t0));
$idx->debugmsg("index initialization took : " . $timediff_init, 0);


# test some queries
my $output;

$idx->debugmsg("processing query: 'king'", 0);
$output = $q->process_query("king");
print Dumper($output);

$idx->debugmsg('processing query: "julius caesar"', 0);
$output = $q->process_query('"julius caesar"');
print Dumper($output);

$idx->debugmsg('document frequency for: "caesar"', 0);
$output = $q->document_frequency("caesar");
print Dumper($output);

$idx->debugmsg('term frequency for: "caesar" in doc 76', 0);
$output = $q->term_frequency("76 caesar");
print Dumper($output);

$idx->debugmsg('document_title for doc_id: 37', 0);
$output = $q->document_title("37");
print Dumper($output);

$idx->debugmsg('document_content for doc_id: 37', 0);
$output = $q->document_content("73", 0);
print Dumper($output);


# these results only show up after the incrental index update
$idx->debugmsg("processing query: 'romeo'", 0);
$output = $q->process_query("romeo");
print Dumper($output);

$idx->debugmsg("processing query: 'romeo juliet'", 0);
$output = $q->process_query('"romeo juliet"');
print Dumper($output);



$idx->debugmsg("USING dirfiles formatted index", 0);

undef $idx;
undef $q;

  # instantiate the index object first.
  $idx = new Clair::Index(DEBUG => $DEBUG, index_root => $index_root_dirfiles, index_file_format => "dirfiles"); # NOTE index_file_format param

  $idx->debugmsg("pre-loading necessary meta indexes.. please wait", 0);

	# and then pass the index object into the query constructor.
  $q = new Clair::Info::Query(DEBUG => $DEBUG, index_object => $idx, , stop_word_list => $stop_word_list);

# test some queries
my $output;

$idx->debugmsg("dirfiles processing query: 'king'", 0);
$output = $q->process_query("king");
print Dumper($output);

$idx->debugmsg('dirfiles processing query: "julius caesar"', 0);
$output = $q->process_query('"julius caesar"');
print Dumper($output);

$idx->debugmsg('dirfiles document frequency for: "caesar"', 0);
$output = $q->document_frequency("caesar");
print Dumper($output);
