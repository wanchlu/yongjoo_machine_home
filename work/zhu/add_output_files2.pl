#!/usr/bin/perl -w
use strict;

my $dir = shift;
`rm -f $dir/*/*train*sim`;
`rm -f $dir/*/*train*out`;
`rm -f $dir/*/*labels`;
`rm -f $dir/*/*shuffle`;

my @simfiles = `ls $dir/*sim`;
chomp(@simfiles);


foreach my $file (@simfiles) {
    my $trainfile = $file;
    $trainfile =~ s/sim/train/g;
    my $testfile = $file;
    $testfile =~ s#\/\d+\.sim$#\/test#g;
#    my $trainsize = 1;
    #   if ($trainfile =~ m/.*\/(\d+)\.train$/) {
    #   $trainsize = $1;
    # }
    my $trainlabel = $trainfile.".labels";
    my $testlabel = $testfile.".labels";
    my $output = $file;
    $output =~ s/sim/out/g;
    `./data/convert_to_zhu_format2.pl $trainfile $testfile`;
    `./zhu -graph $file -trainlabels $trainlabel -testlabels $testlabel -out $output -classes 2`;
}

#`rm -f $dir/*labels`;
#`rm -f $dir/*shuffle`;
`rm -f $dir/*train*sim`;
`rm -f $dir/*train*out`;
