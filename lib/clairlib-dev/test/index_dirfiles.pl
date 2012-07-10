#!/usr/local/bin/perl

# script: test_index_dirfiles.pl
# functionality: Tests index update using Index/dirfiles.pm, index is created
# functionality: in produces/index_dirfiles, complementary to index_mldbm.pl

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
my %args;
my @files = ();
my $corpus_root = "$FindBin::Bin/input/index/Shakespear";
my $incremental_root = "$FindBin::Bin/input/index/incremental";
my $index_root = "$FindBin::Bin/produced/index_dirfiles",
my $stop_word_list = "$FindBin::Bin/input/index/stopwords.txt";
my $filter = "\.html";

# Determine the GenericDoc module root here
# my @libpaths = grep { -d $_ && $_ =~ /GenericDoc/ } @INC;
# my $module_root = shift @libpaths;

# @libpaths = grep { -d $_ && $_ =~ /Index/ } @INC;
# my $rw_module_root = shift @libpaths;

GetOptions(\%args, 'help', 'man', 'debug=i', 'datadir=s', 'listfile=s', 'filter=s', 'stop_word_list=s') or pod2usage(2);
pod2usage(1) if($args{help});
pod2usage(-exitstatus => 0, -verbose => 2) if($args{man});
$corpus_root = $args{datadir} if($args{datadir});
$DEBUG = $args{debug} if($args{debug});
$stop_word_list = $args{stop_word_list} if($args{stop_word_list});



# instantiate the index object
my $idx = new Clair::Index(
	DEBUG => 1,
	stop_word_list => $stop_word_list,
	index_root => $index_root,
	index_file_format => "dirfiles",
);

$idx->debugmsg("using stop word list: $stop_word_list", 0) if(-f $stop_word_list);

my $t0;
my $t1;

#
# Finding files
#
$idx->debugmsg("using files from: $corpus_root", 0);

$t0 = new Benchmark;

 find(\&wanted, ( $corpus_root ));
 @files = grep { /$filter/ } @files if($filter);

$idx->debugmsg("total of " . scalar @files . " files retrieved from '$corpus_root'", 0);

$t1 = new Benchmark;
my $timediff_find = timestr(timediff($t1, $t0));


#
# Preparing Index
#
$idx->debugmsg("constructing index object with documents", 0);
$t0 = new Benchmark;

for my $f (@files)
{
	my $gdoc = new Clair::GenericDoc(
		DEBUG => $DEBUG,
		# module_root => $module_root,
		content => $f,
		stem => 1,
		use_parser_module => "shakespear"
	);

	# insert the document into the index object
	$idx->insert($gdoc);
}
$t1 = new Benchmark;
my $timediff_prep = timestr(timediff($t1, $t0));



#
# Building Index
#
$t0 = new Benchmark;
$idx->debugmsg("building index, please wait...", 0);
$idx->clean(); # cleans up any existing index.
my ($invidx, $docidx, $wordidx) = $idx->build();
$t1 = new Benchmark;
my $timediff_build = timestr(timediff($t1, $t0));


#
# Writing Index
#
$t0 = new Benchmark;
$idx->debugmsg("sync-ing (saving) to disk", 0);
$idx->sync();
$t1 = new Benchmark;
my $timediff_sync = timestr(timediff($t1, $t0));


# you can use the methods from the submodules this way
my $hash = $idx->index_read("dirfiles", "caesar");
print Dumper($hash);

# print Dumper($hash);


# my $doc = $idx->index_read($idx->{index_file_format}, "$index_root/document_meta_idx.dbm", 1);
# my $words = $idx->index_read($idx->{index_file_format}, "$index_root/word_idx.dbm", 1);
my $space = `du -sk $index_root`; 
$space = $1 if($space =~ /(\d+)\s+/);
# my @sorted_words = reverse sort { $words->{$a}->{count} <=> $words->{$b}->{count} } keys %$words;

# $idx->debugmsg("total documents   : " . scalar keys %$doc, 0);
# $idx->debugmsg("total unique words: " . scalar keys %$words, 0);
$idx->debugmsg("disk space used   : " . $space . " KB", 0);
$idx->debugmsg("file collect took : " . $timediff_find, 0);
$idx->debugmsg("data prep took    : " . $timediff_prep, 0);
$idx->debugmsg("index build took  : " . $timediff_build, 0);
$idx->debugmsg("index write took  : " . $timediff_sync, 0);
# $idx->debugmsg("top 20 words      : list below", 0);

# for my $i (0..19)
# {
	# my $w = $sorted_words[$i];
	# $idx->debugmsg("   $w $words->{$w}->{count}", 0);
# }


# $idx->debugmsg($doc, 1);



# to find all the shakespear html files by scenes
sub wanted
{
	return if(-d $File::Find::name || $File::Find::name =~ /full\.html|index\.html|news\.html|^\./);
	push @files, $File::Find::name;
}

