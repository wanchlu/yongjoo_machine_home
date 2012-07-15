#!/usr/bin/perl -w
use strict;
use Clair::Utils::Stem;

my %p_pos;
my %p_neg;
my $arg_lex_file = shift;
open IN, "$arg_lex_file" or die;
while (<IN>) {
    chomp;
    my ($lex, $p_pos, $p_neg, $ttt)  = split /\t/, $_;
    $p_pos{$lex} = $p_pos;
    $p_neg{$lex} = $p_neg;
}
close IN;
#open IN, "inter/pre_process.txt" or die;
#while (<IN>) {
#    chomp;
#    my ($domain, $stance, $topic, $topic_text, $post_id, $sent_id, $sent) = split /\t/, $_;
#    my @words = split /[^a-zA-Z0-9_\-']+/, $sent;
#    my @stemmed_words = ();
#    next if $#words < 0;
#    foreach my $w (@words) {
#        $w =~ s/^[\-'_]+//g;
#        $w =~ s/[\-'_]+$//g;
#        next if not defined ($w);
#        push (@stemmed_words, stem($w));
#    }
#    my $stemmed_sent = join " ", @stemmed_words;
#    print "$domain\t$stance\t$topic\t$topic_text\t$post_id\t$sent_id\t$stemmed_sent\n";
#}
my @domains = qw( abortion creation gayRights god guns healthcare);
foreach my $domain (@domains) {
    my $input_dir = "/home/wanchen/work/SomWiebe10_replication/posts_sents/$domain";
    my $output_dir = "/home/wanchen/work/SomWiebe10_replication/stemmed_sents/$domain";
    `mkdir $output_dir` unless (-d $output_dir);

    my @files = `ls $input_dir`;
    chomp (@files);
    foreach my $file (@files) {
        next unless $file =~ m/pos$/;
        my $input = "$input_dir/$file";
        open IN, $input or die;
        $file =~ s/\.pos$//g;
        open OUT, ">$output_dir/$file" or die;

        my $sent_pos = 0;
        my $sent_neg = 0;

        my $sent = <IN>;
        close IN;

        my @tokens = split /\s+/, $sent;
        my @words = ();
        foreach my $t (@tokens) {
            my ($w, $pos) = split /\//, $t;
            print OUT stem($w)."/".$pos." ";
            push (@words, $w);
        }
        close OUT;
        # search for trigram in the arguing lexicon
        my $i = 0;
        while ($i <= $#words-2 ) {
            if (not defined ($words[$i]) or not defined ($words[$i+1]) or not defined ($words[$i+2]) ) {
                $i ++;
                next;
            }
            my $trigram = $words[$i]."_".$words[$i+1]."_".$words[$i+2];
            if (exists $p_pos{$trigram}) {
#                print " $trigram";-
                $sent_pos += $p_pos{$trigram};
                $sent_neg += $p_neg{$trigram};
                delete $words[$i];
                delete $words[$i+1];
                delete $words[$i+2];
                $i += 3;
            } else {
                $i ++;
            }
        }
        $i = 0;
        while ($i <= $#words-1 ) {
            if (not defined ($words[$i]) or not defined ($words[$i+1]) ) {
                $i ++;
                next;
            }
            my $bigram = $words[$i]."_".$words[$i+1];
            if (exists $p_pos{$bigram}) {
                #               print " $bigram";-
                $sent_pos += $p_pos{$bigram};
                $sent_neg += $p_neg{$bigram};
                delete $words[$i];
                delete $words[$i+1];
                $i += 2;
            } else {
                $i ++;
            }
        }
        $i = 0;
        while ($i <= $#words) {
            if (not defined ($words[$i]) ) {
                $i ++;
                next;
            }
            my $unigram = $words[$i];
            if (exists $p_pos{$unigram}) {
                #     print " $unigram";
                $sent_pos += $p_pos{$unigram};
                $sent_neg += $p_neg{$unigram};
                delete $words[$i];
            }
            $i ++;
        }
        my $sent_pol = "ap";
        $sent_pol = "an" if ($sent_neg > $sent_pos);
        print "$domain\t$file\t";
        next if ($sent_neg == $sent_pos);  # neutral
        foreach my $t (@tokens) {
            my ($w, $pos) = split /\//, $t;
            if ($pos =~ m/^(NN.?|RB|VB.?|JJ.?)$/) {
                print $sent_pol."_".stem($w)." ";
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
