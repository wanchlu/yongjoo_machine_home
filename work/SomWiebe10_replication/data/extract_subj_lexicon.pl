#!/usr/bin/perl -w
use strict;
use Clair::Utils::Stem;

open IN, "subjclueslen1-HLTEMNLP05.tff" or die;
while (<IN>) {
    if (m/ word1=([\w\-]+) .* priorpolarity=([\w\-]+)$/) {
        my $w = $1;
        my $pol = $2;
        my $stemmed = stem($w);
        print "$stemmed\t$pol\n";
    }
    else {
        print "error $_";
    }
}

sub stem{
    my $word = shift;
    $word= lc($word);
    $word = "be" if ($word =~ m/\b(is|are|was|were)\b/);
    $word = "have" if ($word =~ m/\b(has|had)\b/);
    $word = "do" if ($word =~ m/\b(did|does)\b/);
    my $stemmer = new Clair::Utils::Stem();
    return $stemmer->stem($word);
}
