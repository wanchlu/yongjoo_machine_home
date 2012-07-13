#!/usr/bin/perl -w
use strict;

my %ngram;
open IN, "data/unigram.txt" or die;
while (<IN>) {
    chomp;
    my ($w, $c) = split /\t/, $_;
    $ngram{$w} = $c;
}
close IN;
open IN, "data/bigram.txt" or die;
while (<IN>) {
    chomp;
    my ($w, $c) = split /\t/, $_;
    $ngram{$w} = $c;
}
close IN;
open IN, "data/trigram.txt" or die;
while (<IN>) {
    chomp;
    my ($w, $c) = split /\t/, $_;
    $ngram{$w} = $c;
}
close IN;

my %p_pos;
my %p_neg;

open IN, "data/subj_cands3.txt" or die;
while (<IN>) {
    chomp;
    my ($cand, $total_cnt, $pos_cnt, $neg_cnt) = split /\t/, $_;
    next if not exists $ngram{$cand};
    #next if ($pos_cnt == 0 and $neg_cnt == 0);
    $p_pos{$cand} = $pos_cnt / $ngram{$cand};
    $p_neg{$cand} = $neg_cnt / $ngram{$cand};
}
close IN;

open OUT, ">data/subj_pos_rank.txt" or die;
foreach my $k ( reverse (sort { $p_pos{$a} <=> $p_pos{$b} } keys %p_pos) ){
    print OUT "$k\t$p_pos{$k}\t$p_neg{$k}\t$ngram{$k}\n";
}
close OUT;
open OUT, ">data/subj_neg_rank.txt" or die;
foreach my $k ( reverse (sort { $p_neg{$a} <=> $p_neg{$b} } keys %p_neg) ){
    print OUT "$k\t$p_pos{$k}\t$p_neg{$k}\t$ngram{$k}\n";
}
close OUT;
open OUT, ">data/subj_diff_rank.txt" or die;
foreach my $k ( sort { $p_pos{$a} - $p_neg{$a} <=> $p_pos{$b} - $p_neg{$b} } keys %p_pos) {
        print OUT "$k\t$p_pos{$k}\t$p_neg{$k}\t$ngram{$k}\n";
        }
        close OUT;
