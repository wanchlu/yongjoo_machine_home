#!/usr/bin/perl -w
use strict;

my @domains = qw( abortion creation gayRights god guns healthcare);
foreach my $domain (@domains) {
    my $input_dir = "/home/wanchen/work/SomWiebe10_replication/stemmed_sents/$domain";

    my @files = `ls $input_dir`;
    chomp (@files);
    foreach my $file (@files) {
        my $input = "$input_dir/$file";
        open IN, $input or die;
        my $sent = <IN>;
        close IN;
        print $domain."\t".$file."\t";

        my @tokens = split /\s+/, $sent;
        foreach my $t (@tokens) {
            my ($w, $pos) = split /\//, $t;
            if ($pos =~ m/^(NN.?|RB|VB.?|JJ.?)$/) {
                print "$w ";
            }
        }
        print "\n";
    }
}

