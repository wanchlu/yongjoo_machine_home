#!/usr/bin/perl -w
use strict;

my @domains = qw( abortion creation gayRights god guns healthcare);

foreach my $domain (@domains) {
    my $input_dir = "/home/wanchen/work/SomWiebe10_replication/posts_data/$domain";
    my @ids = `ls $input_dir`;
    chomp (@ids);
    foreach my $id (@ids) {
        my $input = "$input_dir/$id";
        my @lines = `sentence_segmenter.pl $input`;
        #print STDERR $_ foreach (@lines);
        my $label = 0;
        if ($lines[0] =~ m/stance2/) {
            $label = 1;
        }
        foreach my $i (3..$#lines) {
            my $in = $i - 3;
            print "$domain\t$label\t$id\t$id-$in\t$lines[$i]";
        }
    }
}
