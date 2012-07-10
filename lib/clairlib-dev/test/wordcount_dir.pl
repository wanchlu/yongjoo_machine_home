#!/usr/local/bin/perl

# script: test_wordcount_dir.pl
# functionality: Counts the words in each file of a directory; outputs report 

use strict;
use warnings;
use Clair::Document;
use FindBin;

my $prefix = "$FindBin::Bin/input/wordcount_dir";

#Count words in every Document in a file and return max,min,avergage:
opendir(DIR, $prefix);
my @files = grep { /\.txt$/ } readdir(DIR);
closedir(DIR);

my $doc;

my $num_files = scalar @files;
die "No files in $prefix" if $num_files == 0;

my $file = shift @files;
$file = "$prefix/$file";
$doc = new Clair::Document(type=>'text',file=>$file);
my $max = $doc->count_words();
my $maxFile = $file;
my $min = $doc->count_words();
my $minFile = $file;
my $temp;
my $avg = 0;

foreach $file (@files) {
    $file = "$prefix/$file";
    next unless -f $file;
    $doc = new Clair::Document( type => 'text', file => $file );
    $temp = $doc->count_words();
    $avg = $avg + $temp;
    if($temp > $max){
        $max = $temp;
        $maxFile = $file;
    }
    if($temp < $min){
        $min = $temp;
        $minFile = $file;
    }
}

$avg = $avg / $num_files;
print "The minimum number of words is $min words in file $minFile\n";
print "The maximum number of words is $max words in file $maxFile\n";
print "The average number of words is $avg words\n";
