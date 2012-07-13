#!/usr/bin/perl -w
use strict;
use Clair::Utils::Stem;

open IN, "data/subjective.txt" or die;
while (<IN>) {
    chomp;
    my ($ann_attr, $sent, $intensity, $polarity, $attitude_type) = split /\t/, $_; 
    my $stemmed_sent = stem($sent);
    my @tokens = split /\s+/, $stemmed_sent;
    foreach my $i (0..$#tokens) {
        foreach my $j (0..$i) {
            print "$tokens[$j]_";
        }
        print "\t$polarity" if defined($polarity);
        print "\n";
    }
}

sub stem{
    my $sent = shift;
    my $stemmer = new Clair::Utils::Stem;
    $sent = lc($sent);
    $sent =~ s/^\s+//g;
    $sent =~ s/\s+$//g;
    my @words = split /[^a-zA-Z0-9_\-']+/, $sent;
    my $stemmed = '';
    for my $i (0..2) {
        next if ($i > $#words);
        $words[$i] = "be" if ($words[$i] =~ m/\b(is|are|was|were)\b/);
        $words[$i] = "have" if ($words[$i] =~ m/\b(has|had)\b/);
        $words[$i] = "do" if ($words[$i] =~ m/\b(did|does)\b/);
        $stemmed = $stemmed." ".$stemmer->stem($words[$i]);
    }
    $stemmed =~ s/^\s+//g;
    $stemmed =~ s/\s+$//g;
    return $stemmed;
}
