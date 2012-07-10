#!/usr/bin/perl
# script: sentences_to_docs.pl
# functionality: Converts a document with sentences into a set of
# functionality: documents with one sentence per document
#
# Make sure a Java interpreter is in your path

use strict;
use warnings;

use File::Spec;
use Getopt::Long;
use Clair::Cluster;
use Clair::Document;

sub usage;

my $in_file = "";
my $dirname = "";
my $basename = "";
my $output_dir = "";
my $single = 0;
my $type = "text";
my $verbose = 0;

my $res = GetOptions("input=s" => \$in_file, "directory=s" => \$dirname,
		     "output=s" => \$output_dir, "singlefile" => \$single,
                     "type=s" => \$type, "verbose" => \$verbose);

if (!$res or ($output_dir eq "")) {
  usage();
  exit;
}

my $vol;
my $dir;
my $prefix;
($vol, $dir, $prefix) = File::Spec->splitpath($output_dir);

if ($dir ne "") {
  unless (-d $dir) {
    mkdir $dir or die "Couldn't create $dir: $!";
  }
}


my $cluster = 0;
if ($dirname ne "") {
  my $pwd = `pwd`;
  chomp $pwd;
  chdir $dirname or die "Couldn't change to $dirname: $!\n";
  if ($verbose) { print "Loading documents from directory $dirname\n"; }
  $cluster = new Clair::Cluster(id => $dirname);
  $cluster->load_documents("*", type => $type, filename_id => 1);
  chdir $pwd or die "Couldn't change back to $pwd: $!\n";
} elsif ($in_file ne "") {
  if ($verbose) { print "Loading documents from file $in_file\n"; }
  my $doc = new Clair::Document(file => $in_file, type => $type,
				id => "document");
  my %docs = ("document", $doc);
  $cluster = new Clair::Cluster(documents => \%docs, id => $in_file);
} else {
  usage();
  exit;
}
if ($verbose) { print "Loaded ", $cluster->count_elements, " documents\n"; }

if ($type eq "html") {
  if ($verbose) { print "Stripping html\n"; }
  $cluster->strip_all_documents();
}
  

if ($verbose) { print "Creating sentence based cluster\n"; }
my $sentence_cluster = $cluster->create_sentence_based_cluster();

if ((not $single) and (! -d "$output_dir")) {
  if ($verbose) { print "Creating directory $output_dir\n"; }
  mkdir $output_dir;
}

if ($verbose) { print "Saving documents to $output_dir\n"; }
if ($single) {
  # save to single file
  $sentence_cluster->save_documents_to_file($output_dir, 'text');
} else {
  # save to directory
  $sentence_cluster->save_documents_to_directory($output_dir, 'text', name_count => 0);
}

sub usage {
  print "$0: Parse document into sentences and save into a directory or file\n\n";
  print "usage: $0 [--singlefile] --input in_file [--directory directory_name] --output output\n";

  print "  --input in_file\n";
  print "       Input file to parse into sentences\n";
  print "  --directory in_dir\n";
  print "       Input directory to parse into sentences\n";
  print "  --type document_type\n";
  print "       Document type, one of: text, html, stem\n";
  print "  --singlefile\n";
  print "       If true, write output into a single file, one line per sentence\n";
  print "  --output output\n";
  print "       Output filename or directory\n";
  print "\n";

  print "example: $0 -i test/sentences.txt -o sentences\n";
}
