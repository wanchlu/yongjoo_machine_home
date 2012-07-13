#!/usr/bin/perl -w
use strict;
use Clair::Utils::Stem;

my %unigram;
my %bigram;
my %trigram;

my @doclist = `cat doclist.xbankSubset doclist.ulaSubset doclist.ula-luSubset doclist.opqaSubset doclist.mpqaOriginalSubset doclist.attitudeSubset`;
chomp (@doclist);

foreach my $doc (@doclist) {
    my $textfile = "docs/$doc";
    open IN, "$textfile" or die;
    local $/=undef;
    my $entire_string = <IN>;
    close IN;
    my @tokens = split /\s+/, $entire_string;
    # stem and construct unigrams
    foreach my $i (0..$#tokens) {
        $tokens[$i] = stem($tokens[$i]);
        $unigram{$tokens[$i]} = 0 if not exists $unigram{$tokens[$i]};
        $unigram{$tokens[$i]} ++;
    }
    # bigram
    foreach my $i (1..$#tokens) {
        my $bi = $tokens[$i-1]."_".$tokens[$i];
        $bigram{$bi} = 0 if not exists $bigram{$bi};
        $bigram{$bi} ++;
    }
    # trigram
    foreach my $i (2..$#tokens) {
        my $tri = $tokens[$i-2]."_".$tokens[$i-1]."_".$tokens[$i];
        $trigram{$tri} = 0 if not exists $trigram{$tri};
        $trigram{$tri} ++;
    }
}

open OUT, ">data/unigram.txt";
foreach my $k (reverse (sort { $unigram{$a} <=> $unigram{$b} } keys %unigram)) {
    print OUT "$k\t$unigram{$k}\n";
}
close OUT;

open OUT, ">data/bigram.txt";
foreach my $k (reverse (sort { $bigram{$a} <=> $bigram{$b} } keys %bigram)) {
    print OUT "$k\t$bigram{$k}\n";
}
close OUT;


open OUT, ">data/trigram.txt";
foreach my $k (reverse (sort { $trigram{$a} <=> $trigram{$b} } keys %trigram)) {
    print OUT "$k\t$trigram{$k}\n";
}
close OUT;

sub stem{
    my $word = shift;
    $word= lc($word);
    $word = "be" if ($word =~ m/\b(is|are|was|were)\b/);
    $word = "have" if ($word =~ m/\b(has|had)\b/);
    $word = "do" if ($word =~ m/\b(did|does)\b/);
    my $stemmer = new Clair::Utils::Stem();
    return $stemmer->stem($word);
}


