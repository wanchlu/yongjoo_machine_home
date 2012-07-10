#!/usr/local/bin/perl

# script: test_read_dirfiles.pl
# functionality: Requires index_*.pl scripts to have been run, shows how to
# functionality: access the document_index and the inverted_index, how to
# functionality: use common access API to retrieve information

use strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib"; # if you are outside of bin path.. just in case
use vars qw/$DEBUG/;

use Benchmark;
use Clair::GenericDoc;
use Clair::Index;
use Data::Dumper;
use File::Find;
use Getopt::Long;
use Pod::Usage;


$DEBUG = 0;
my $index_root = "$FindBin::Bin/produced/index_dirfiles",
my $index_root_mldbm = "$FindBin::Bin/produced/index_mldbm",
my $stop_word_list = "$FindBin::Bin/input/index/stopwords.txt";


# instantiate the index object
my $idx = new Clair::Index(
	DEBUG => 1,
	stop_word_list => $stop_word_list,
	index_root => $index_root,
	index_file_format => "dirfiles",
);

$idx->debugmsg("trying to read the document, positional index hash from: $index_root", 0);

my $hash = {};
my $count = 0;

$hash = $idx->index_read("dirfiles", "caesar");
$count = scalar keys %{$hash->{caesar}};
$idx->debugmsg("total of $count docs contain the word 'caesar'");

$hash = $idx->index_read("dirfiles", "king");
$count = scalar keys %{$hash->{king}};
$idx->debugmsg("total of $count docs contain the word 'king'");

$idx->{index_root} = $index_root_mldbm;
$hash = $idx->index_read("mldbm", "caesar");
$count = scalar keys %{$hash->{caesar}};
$idx->debugmsg("total of $count docs contain the word 'caesar' from mldbm");

$hash = $idx->index_read("mldbm", "king");
$count = scalar keys %{$hash->{caesar}};
$idx->debugmsg("total of $count docs contain the word 'king' from mldbm");

# or access the meta index by supplying the third parameter, with 2nd parameter
# as the meta index name.
$idx->{index_root} = $index_root;
my $dochash = $idx->index_read("dirfiles", "document_meta_index", 2); # document id 2
print Dumper($dochash);

my $dochash2 = $idx->index_read("dirfiles", "document_index", 100); # document id 100
print Dumper($dochash2);

my $dochash3 = $idx->index_read("dirfiles", "document_index", "all"); # return everything in document_index
$count = scalar keys %{$dochash3};
$idx->debugmsg("retrieved total of $count doc data from document_index");

my $dochash4 = $idx->index_read("dirfiles", "document_meta_index", "all"); # return everything for document_meta_index
$count = scalar keys %{$dochash4};
$idx->debugmsg("retrieved total of $count doc meta data from document_meta_index");
