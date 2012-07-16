#!/usr/bin/perl -w
use strict;
use Clair::Utils::Stem;

my @domains = qw( abortion creation gayRights god guns healthcare);
foreach my $domain (@domains) {
    my $input_dir = "/home/wanchen/work/SomWiebe10_replication/stemmed_sents/$domain";

    my @files = `ls $input_dir`;
    chomp (@files);
    foreach my $file (@files) {
        my $input = "$input_dir/$file";
        open IN, $input or die;
        my $sent = <IN>;
        close IN;
        my $post_id = $file;
        $post_id =~ s/-\d+//g;
        print $domain."\t".$post_id."\t".$file."\t";

        my @tokens = split /\s+/, $sent;
        foreach my $t (@tokens) {
            my ($w, $pos) = split /\//, $t;
            if ($pos =~ m/^(PRP.?|NN.?|RB|VB.?|JJ.?)$/) {
                print stem($w)." ";
           }
        }
        print "\n";
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
