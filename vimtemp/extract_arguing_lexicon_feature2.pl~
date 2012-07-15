#!/usr/bin/perl -w
use strict;
open IN, "inter/arguing_lexicon_feature.txt" or die;
while (<IN>) {
    chomp;
    my ($domain, $stance, $topic, $topic_text, $post_id, $sent_id, $sent, $arguing_lex, $sent_pos, $sent_neg, $sent_pol) = split /\t/, $_;
    $sent =~ s/^\s+//g;
    $sent =~ s/\s+$//g;
    my @words = split /\s+/, $sent;
    print "$domain\t$stance\t$topic\t$topic_text\t$post_id\t$sent_id\t";
    # search for trigram in the arguing lexicon
    my $i = 0;
    foreach my $i (0..$#words) {
        print $sent_pol."_".$words[$i]." ";
    }
    print "\n";
}


