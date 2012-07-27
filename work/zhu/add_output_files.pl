#!/usr/bin/perl -w
use strict;

my $dir = shift;
`rm -f $dir/*/*train*sim`;
`rm -f $dir/*/*train*out`;
`rm -f $dir/*/*labels`;
`rm -f $dir/*/*shuffle`;

my @simfiles = `ls $dir/*/*sim`;
chomp(@simfiles);

foreach my $file (@simfiles) {
    my $trainfile = $file;
    $trainfile =~ s/sim/train/g;
    my $testfile = $file;
    $testfile =~ s#\/\d+\.sim$#\/test#g;
    my $trainlabel = $trainfile.".labels";
    my $testlabel = $testfile.".labels";
    my $output = $file;
    $output =~ s/sim/out/g;
    my $accfile = $file;
    $accfile =~ s/sim/acc/g;
    `./data/convert_to_zhu_format2.pl $trainfile $testfile`;
    my $f1 = `./zhu -graph $file -trainlabels $trainlabel -testlabels $testlabel -out $output -classes 2`;
    chomp($f1);

    $f1 =~ m/.*:\s+(.*)$/;
    `echo "$f1" > $accfile`;
}

`rm -f $dir/*/*labels`;
`rm -f $dir/*/*shuffle`;
`rm -f $dir/*/*train*sim`;
`rm -f $dir/*/*train*out`;
