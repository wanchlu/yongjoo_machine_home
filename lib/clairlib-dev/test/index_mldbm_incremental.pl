#!/usr/local/bin/perl

# script: test_index_mldbm_incremental.pl
# functionality: Tests index update using Index/mldbm.pm; requires that
# functionality: index_mldbm.pl was run previously

use strict;
use FindBin;
use vars qw/$DEBUG/;

use Benchmark;
use Clair::GenericDoc;
use Clair::Index;
use Data::Dumper;
use File::Find;


$DEBUG = 0;
my %args;
my @files = ();
my $corpus_root = "$FindBin::Bin/input/index/Shakespear";
my $incremental_root = "$FindBin::Bin/input/index/incremental";
my $index_root = "$FindBin::Bin/produced/index_mldbm",
my $stop_word_list = "$FindBin::Bin/input/index/stopwords.txt";
my $filter = "\.html";

# instantiate the index object
my $idx = new Clair::Index(
	DEBUG => $DEBUG,
	stop_word_list => $stop_word_list,
	index_root => $index_root,
	# rw_modules_root => $rw_module_root,	
);

$idx->debugmsg("using stop word list: $stop_word_list", 0) if(-f $stop_word_list);

my $t0;
my $t1;


# let's try incremental adding of index.
@files = ();
find(\&wanted, ( $incremental_root ));
@files = grep { /$filter/ } @files if($filter);
# print Dumper(\@files);


$t0 = new Benchmark;

# insert, build, and sync
for my $f (@files)
{
	my $gdoc = new Clair::GenericDoc(
		DEBUG => 1,
		# module_root => $module_root,
		content => $f,
		stem => 1,
		use_parser_module => "shakespear"
	);

	# insert the document into the index object
	$idx->insert($gdoc);
}
$idx->build();
$idx->sync();


$t1 = new Benchmark;
my $timediff = timestr(timediff($t1, $t0));
$idx->debugmsg("incremental index update took : " . $timediff, 0);


my $doc2 = $idx->index_read($idx->{index_file_format}, "$index_root/document_meta_index.dbm", 1);

$idx->debugmsg("total documents   : " . scalar keys %$doc2, 0);
$idx->debugmsg($doc2, 1);


# to find all the shakespear html files by scenes
sub wanted
{
	return if(-d $File::Find::name || $File::Find::name =~ /full\.html|index\.html|news\.html|^\./);
	push @files, $File::Find::name;
}
