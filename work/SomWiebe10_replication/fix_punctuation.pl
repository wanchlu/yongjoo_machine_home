#!/usr/bin/perl -w
use strict;
my @domains = qw( abortion creation gayRights god guns healthcare);
foreach my $domain (@domains) {
    my $input_dir = "/home/wanchen/work/SomWiebe10_replication/data/SomasundaranWiebe-politicalDebates/$domain";
    my $output_dir = "/home/wanchen/work/SomWiebe10_replication/posts_data/$domain";
    my @ids = `ls $input_dir`;
    chomp (@ids);
    foreach my $id (@ids) {
        my $input = "$input_dir/$id";
        my $output = "$output_dir/$id";
        open IN, $input or die;
        open OUT, ">$output" or die;
        my @lines = <IN>;
        print OUT $lines[0], $lines[1], $lines[2];
        foreach my $i (3..$#lines) {
            my $new_line = $lines[$i];
            $new_line =~ s/([a-z\.;\)]\s*[\.,i;"?\)])([\(A-Z\-])/$1 $2/g;
            $new_line =~ s/\.\.\.(\S)/... $1/g;
            $new_line =~ s/\.\.([A-Z])/.. $1/g;
            $new_line =~ s/([^\-])-+\s+/$1 /g;
            $new_line =~ s/\s+-+([^\-])/ $1/g;
            $new_line =~ s/\.\-+/. /g;
            $new_line =~ s/(\W)'/$1"/g;
            $new_line =~ s/'(\W)/"$1/g;
            $new_line =~ s/([^\w\s])"/$1 "/g;
            $new_line =~ s/n\?t /n't /g;
            $new_line =~ s/\?s /'s /g;
            $new_line =~ s/\s+/ /g;
            $new_line =~ s/\s+^//g;
            #print $lines[$i]."\n", $new_line."\n\n";
            print OUT $new_line;
        }
    }
}

