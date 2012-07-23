#!/usr/bin/perl

use strict;


my %feathash;
my $maxfeat = 0;

my $trainFile = shift;
my $trainsize = shift;
my $testFile = shift;

`perl shuffle.pl $trainFile | perl shuffle.pl | head -$trainsize > $trainFile.$trainsize.shuffle`;

open (TRAIN, "$trainFile.$trainsize.shuffle");
open (TRAINLABELS, ">$trainFile.$trainsize.labels");

my $count = 0;

my @featrefs;

while (<TRAIN>) {
  chomp;
  $count++;
  my @feats = split (/\s+/);
  print TRAINLABELS "$count\t", shift(@feats), "\n";
  push (@featrefs, \@feats);
}

close TRAIN;
close TRAINLABELS;

open (TEST, $testFile);
open (TESTLABELS, ">$testFile.labels");

while (<TEST>) {
  chomp;
  my @feats = split (/\s+/);
  print TESTLABELS shift(@feats), "\n";
  push (@featrefs, \@feats);
}

close TEST;
close TESTLABELS;


open (NEWTRAIN, ">$trainFile.$trainsize.sim");

for (my $i=0; $i < $#featrefs; $i++) {
  for (my $j=$i+1; $j <= $#featrefs; $j++) {
    my $same = 0;
    for (my $k=0; $k <= $#{$featrefs[$i]}; $k++) {
      if ($featrefs[$i][$k] eq $featrefs[$j][$k]) {
        $same++;
      }
    }
    if ($same > 0) {
      print NEWTRAIN $i+1, "\t", $j+1, "\t$same", "\n";
##      print NEWTRAIN $j+1, "\t", $i+1, "\t$same", "\n";
    }
  }
}

close NEWTRAIN;

