#!/usr/bin/perl -w
use strict;

open IN, "data/subj_cands3.txt" or die;
while (<IN>) {
    chomp;
    my ($cand, $total_cnt, $pos_cnt, $neg_cnt) = split /\t/, $_;
}
