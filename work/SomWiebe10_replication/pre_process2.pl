#!/usr/bin/perl -w
use strict;
use Clair::Utils::Stem;

open IN, "inter/pre_process.txt" or die;
while (<IN>) {
    chomp;
    my ($domain, $label, $post_id, $sent_id, $sent) = split /\t/, $_;
    my @words = split /[^a-zA-Z0-9_\-']+/, $sent;
    my @stemmed_words = ();
    next if $#words < 0;
    foreach my $w (@words) {
        $w =~ s/^[\-'_]+//g;
        $w =~ s/[\-'_]+$//g;
        next if not defined ($w);
        push (@stemmed_words, stem($w));
    }
    my $stemmed_sent = join " ", @stemmed_words;
    print "$domain\t$label\t$post_id\t$sent_id\t$stemmed_sent\n";
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
