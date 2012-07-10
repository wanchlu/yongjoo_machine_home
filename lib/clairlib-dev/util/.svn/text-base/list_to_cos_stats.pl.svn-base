#!/usr/local/bin/perl -w
# script: list_to_cos_stats.pl
#functionality: takes in text file of lines of data, creates corpus of documents
#               with one line per document, creates cosine file of documents
#               and prints out stats for different cosine cutoffs

use warnings;
use Getopt::Long;

sub usage;
$usage = "USAGE: list_to_cos_stats.pl in_file data_dir corpus_name\n";

my $corpus = "";
my $base_dir = "produced";
my $data_dir = "data";
my $infile = "";
my $step = "0.1";

my $res = GetOptions("corpus=s" => \$corpus, "base=s" => \$base_dir,
                     "data=s" => \$data_dir, "input=s" => \$infile, "step=s" => \$step);

#$bin = "/data0/projects/clairlib-dev/util";

if ( ! $infile || ! $data_dir || ! $corpus || !$res) {
  usage();;
  exit;
}

open IN, $infile or die "Can't open $infile\n";

if( -d $data_dir) {
  print "Data dir $data_dir already exists!\n";
  exit;
}else{
  `mkdir $data_dir`;
}

$i = 0;
while (<IN>) {
  open OUT, ">$data_dir/$i";
  print OUT $_;
  close OUT;
  $i++;
}
 
print "--> directory_to_corpus\n";
`directory_to_corpus.pl -c $corpus -d $data_dir -b $base_dir`;

print "--> index_corpus\n";
`index_corpus.pl -c $corpus -b $base_dir --notf -nolinks --nostats`;

print "--> corpus_to_cos\n";
`corpus_to_cos.pl -c $corpus -b $base_dir -o $corpus.cos`;

print "--> corpus_to_stats\n";
`cos_to_stats.pl -i $corpus.cos --step $step -o $corpus.cos.stats --graphs`;

sub usage {
  print "usage: $0 --corpus corpus [--base base_dir] [--data data_dir] --input input_file\n\n";
  print "  --corpus corpus\n";
  print "       Name of the corpus to index\n";
  print "  --base base_dir\n";
  print "       Base directory filename. Default: produced\n";
  print "  --data data_dir\n";
  print "       Directory where input data files will be created. Default: data\n";
  print "  --input input_file\n";
  print "       List file with one data item per line\n";
  print "  --step step\n";
  print "       Step for cos_to_stats.pl. Default: 0.1\n";
  print "\n";
 
  die;
}
