#!/usr/bin/perl -w
use strict;

my @domains = qw( abortion creation gayRights god guns healthcare);


foreach my $domain (@domains) {
    my $input_dir = "/home/wanchen/work/SomWiebe10_replication/posts_data/$domain";
    my $output_dir = "/home/wanchen/work/SomWiebe10_replication/posts_sents/$domain";
    `mkdir $output_dir` unless (-d $output_dir);

    my @ids = `ls $input_dir`;
    chomp (@ids);
    foreach my $id (@ids) {
        my $input = "$input_dir/$id";
        my @lines = `sentence_segmenter.pl $input`;
        chomp (@lines);
        foreach my $i (3..$#lines) {
            my $in = $i - 3;
            print "$domain\t$lines[0]\t$lines[2]\t$lines[1]\t$id\t$id-$in\n";
            open OUT, ">$output_dir/$id-$in" or die;
            print OUT "$lines[$i]\n";
            close OUT;
        }
    }

}
