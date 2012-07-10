#!/usr/bin/perl
# Tool to manage corpus directories

use strict;
use warnings;

use File::Path;
use File::Spec;
use Getopt::Long;

sub usage;

my $corpus_name = "";
my $basedir = "";
my $delete = 0;
my $verbose = 0;

my $res = GetOptions("corpus=s" => \$corpus_name, "base=s" => \$basedir,
                     "delete" => \$delete,
                     "verbose" => \$verbose);

if ($basedir eq "") {
  $basedir = ".";
}

my $corpus_data_dir = "$basedir/corpus-data/$corpus_name";
my $corpus_download_dir = "$basedir/download/$corpus_name";
my $corpus_corpora_dir = "$basedir/corpora/$corpus_name";
my @del_dirs = ( "$basedir/corpus-data/$corpus_name",
                 "$basedir/corpus-data/$corpus_name-tf",
                 "$basedir/corpus-data/$corpus_name-tf-s",
                 "$basedir/download/$corpus_name",
                 "$basedir/corpora/$corpus_name"
               );
my @del_files = ("$basedir/$corpus_name.download.uniq");

if (!$res) {
  usage();
}

if ($delete and ($corpus_name eq "")) {
  print STDERR "Delete requires a corpus name\n";
  exit;
}

if ($delete) {
  # check if directories and files exist
  my @final_dirs = ();
  my @final_files = ();
  foreach my $dir (@del_dirs) {
    if (-d $dir) {
      push @final_dirs, $dir;
    }
  }
  foreach my $file (@del_files) {
    if (-e $file) {
      push @final_files, $file;
    }
  }
  print "We are about to delete the the following directories and files:\n  ";
  print join("\n  ", (@final_dirs, @final_files));
  print "\nProceed? [y/n]\n";
  my $ans;
  chomp($ans = <STDIN>);
  if($ans =~ /^[yY]/) {
    foreach my $dir (@final_dirs) {
      if (-d $dir) {
        print "Deleting $dir\n";
        rmtree $dir;
      }
    }
    foreach my $file (@final_files) {
      if (-e $file) {
        print "Deleting $file\n";
        unlink $file;
      }
    }
  }
}

#
# Print out usage message
#
sub usage
{
  print "usage: $0 --input input_file [--output output_file] [--start start] [--end end] [--step step]\n\n";
  print "  --corpus corpus";
  print "       Name of the corpus to modify\n";
  print "  --delete\n";
  print "       Delete the corpus\n";
  print "\n";

  print "example: $0 --corpus acl_anthology --delete\n";

  exit;
}
