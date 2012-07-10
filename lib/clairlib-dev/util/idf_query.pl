#!/usr/local/bin/perl
# script: get_idf.pl
# functionality: Looks up idf values for terms in a corpus

use strict;
use warnings;
use Getopt::Long;
use File::Spec;
use Clair::Utils::Idf;

sub usage;

my $base_dir = "";
my $out_file = "";
my $corpus_name = "";
my $query = "";
my $all = '';
my $stemmed = '';
my $dir;
my $vol;
my $file;


my $res = GetOptions("basedir=s" => \$base_dir, "output=s" => \$out_file,
			"corpus=s" => \$corpus_name, 
			"query=s" => \$query,
			"all" => \$all,
			"stemmed" => \$stemmed); 

# check for input dir
if( $base_dir eq "" ){
  usage();
  exit;
}

# check for corpus name
if( $corpus_name eq "" ){
  usage();
  exit;
}

# check for output file
if ($out_file ne "") {
  ($vol, $dir, $file) = File::Spec->splitpath($out_file);
  if ($dir ne "") {
    unless (-d $dir) {
      mkdir $dir or die "Couldn't create $dir: $!";
    }
  }

  open(OUTFILE, "> $out_file");
  *STDOUT = *OUTFILE;
  select OUTFILE; $| = 1;
}

# make unbuffered
select STDOUT; $| = 1;
select STDERR; $| = 1;
select STDOUT;

# check for word query
if( $query eq "" ){
  $all = 1;
} 

# create idf object
my $idf = Clair::Utils::Idf->new(rootdir => "$base_dir", 
                                 corpusname => "$corpus_name", 
				 stemmed => $stemmed); 

# get idfs
my %idfs = $idf->getIdfs(); 

# print words and idfs to output
if( $all ){
  foreach my $k (keys %idfs) { 
    print "$k: " . $idfs{$k} . "\n"; 
  }
} elsif( $idfs{$query} ) {
  print "$query: " . $idfs{$query} . "\n";
} else {
  print "$query not found\n";
}


#
# Print out usage message
#
sub usage
{
  print "usage: $0 --basedir base_dir --corpus corpus_name [--output output_file] [--query word] [--all] [--stemmed]\n\n";
  print "  --basedir base_dir\n";
  print "      Base directory filename.  The corpus is generated here.\n";
  print "  --corpus corpus_name\n";
  print "      Name of the corpus.\n";
  print "  --output output_file\n";
  print "      Name of output file.  If not given, dumps to stdout.\n";
  print "  --query word\n";
  print "      Term to query.\n";
  print "  --all\n";
  print "      Print out all words and IDF's.  Default.\n";
  print "  --stemmed\n";
  print "      Set whether the input is already stemmed.\n";
  print "\n";
  print "example: $0 --basedir /data0/corpora/sfi/abs/produced --corpus ABS --output ./abs.idf --query hahn --stemmed\n";
  exit;
}
