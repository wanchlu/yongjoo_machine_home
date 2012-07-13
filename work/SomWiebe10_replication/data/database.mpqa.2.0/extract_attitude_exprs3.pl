#!/usr/bin/perl -w
use strict;

my %pos_cnt;
my %neg_cnt;
my %total_cnt;

open IN, "data/atti_cands2.txt" or die;
while (<IN>) {
    chomp;
    my ($cand, $intensity, $pol) = split /\t/, $_;
    $cand =~ s/_$//g;
    if (not exists $total_cnt{$cand}) {
        $total_cnt{$cand} = 0;
        $pos_cnt{$cand} = 0;
        $neg_cnt{$cand} = 0;
    }
    $total_cnt{$cand} ++;
    next if not defined ($pol);
    if ($pol =~ m/(agree|arguing)-pos/) {
        $pos_cnt{$cand} ++;
    }elsif ($pol =~ m/(agree|arguing)-neg/) {
        $neg_cnt{$cand} ++;
    }
}
close IN;

open IN, "subj_lexicon.txt" or die;
my %subj_lexicon;
while (<IN>) {
    chomp;
    my ($w, $pol) = split /\s+/, $_;
    $subj_lexicon{$w} = $pol if not exists $subj_lexicon{$w};
}
close IN;

foreach my $key (reverse (sort { $total_cnt{$a} <=> $total_cnt{$b} } keys %total_cnt) ) {
    if (not exists $subj_lexicon{$key} ){
        print "$key\t$total_cnt{$key}\t$pos_cnt{$key}\t$neg_cnt{$key}";
        print "\n";
    }
}

    
