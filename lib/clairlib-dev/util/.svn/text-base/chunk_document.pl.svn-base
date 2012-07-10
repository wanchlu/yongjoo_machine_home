#!/usr/local/bin/perl 
#
# script: chunk_document
#
# functionality: Breaks a text file into multiple files of a given word length
#

use strict;
use warnings;
use Getopt::Long;
use File::Spec;

sub usage;

my $in_file = "";
my $out_dir = "";
my $out_file = "";
my $word_limit = 500;
my $vol = "";
my $dir = "";
my $prefix = "";

my $res = GetOptions("input=s" => \$in_file,
											"output=s" => \$out_dir,
											"words=i" => \$word_limit);

# check for input 
if( $in_file eq "" ){
  usage();
  exit;
}

# check for output directory
if( $out_dir eq "" ){
	usage();
	exit;
} else {
  unless (-d $out_dir) {
    mkdir $out_dir or die "Couldn't create $out_dir: $!";
  }
}

# open infile
open(IN,$in_file) or die "Can't open $in_file: $!";

# get infile name
($vol, $dir, $prefix) = File::Spec->splitpath($in_file);

# read in infile, split into words and print words to outfile till you reach
# word_limit, then start new outfile

my @line = ();
my @bin = ();
my $dump = "";
my $count = 1;
my $word = "";

$out_file = $out_dir.'/'.$prefix.'.'.$word_limit;

while(<IN>){
	#split line into words and move into array
  my @line = split(/ /, $_);

  #add words to array until it's $word_limit long
	foreach $word (@line){
		if($#bin < $word_limit) {
			push (@bin, $word);
    } else {
      $dump = join(' ', @bin);
			#print "writing: $out_file.$count\n";
			open(OUT, ">$out_file.$count") or die "Can't open $out_file: $!";      
			print OUT $dump;
			close OUT;
			@bin = ($word);
			$count++;
		}
	}
}

#get last words
$dump = join(' ', @bin);
#print "writing: $out_file.$count\n";
open(OUT, ">$out_file.$count") or die "Can't open $out_file: $!";
print OUT $dump;
close OUT;

#
# Print out usage message
#
sub usage
{
  print "usage: $0 --input input_file --output output_dir [--words word_limit]\n\n";
  print "  --input input_file\n";
	print "     Name of the input file\n";
	print "  --output output_dir\n";
	print "     Name of the output directory.\n";
  print "  --words word_limit\n";
	print "     Number of words to include in each file.  Defaults to 500.\n";
	print "\n";
	print "example: $0 --input file.txt --output ./corpus --words 1000\n";
	exit;
}
 
