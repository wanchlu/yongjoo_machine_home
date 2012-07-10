#!/usr/bin/perl

use strict;

my %feathash;
my $maxfeat = 0;

my $trainFile = shift;
my $testFile = shift;

my $train_label_file = shift;

open (TRAIN, $trainFile);
open (NEWTRAIN, ">$trainFile.tumbl");

my $count = 0;

while (<TRAIN>) {
  chomp;
  $count++;
  my @feats = split (/\s+/);
  foreach my $f (@feats) {
    print NEWTRAIN hashvalue($f), "\t", $count, "\t1\n";
  }
}

close TRAIN;
close NEWTRAIN;

open (TEST, $testFile);
open (NEWTEST, ">$testFile.tumbl");

my $count = 0;

while (<TEST>) {
  chomp;
  $count++;
  my @feats = split (/\s+/);
  foreach my $f (@feats) {
    print NEWTEST hashvalue($f), "\t", $count, "\t1\n";
  }
}

close TEST;
close NEWTEST;


open (TRAINLABELS, $train_label_file);
open (NEWTRAINLABELS, ">$train_label_file.tumbl");
while (<TRAINLABELS>) {
  my @probs = split (/\s+/);
  my $maxprob = 0;
  for my $i (0..$#probs) {
    if ($probs[$i] > $probs[$maxprob]) {
      $maxprob = $i;
    }
  }
  print NEWTRAINLABELS "$maxprob\n";
}

close TRAINLABELS;
close NEWTRAINLABELS;


sub hashvalue {
  my $f = shift;
  if (exists $feathash{$f}) {
    return $feathash{$f};
  }
  else {
    $feathash{$f} = ++$maxfeat;
    return $maxfeat;
  }
}
