#!/usr/bin/perl -w
use strict;
use Clair::Utils::Stem;

my @domains = qw( abortion creation gayRights god guns healthcare);
foreach my $domain (@domains) {
    my $input_dir = "/home/wanchen/work/SomWiebe10_replication/posts_sents/$domain";
    my $output_dir = "/home/wanchen/work/SomWiebe10_replication/parsed_sents/$domain";
    `mkdir $output_dir ` unless (-d $output_dir);

    my @files = `ls $input_dir`;
    chomp (@files);
    my %post;
    foreach my $file (@files) {
        my ($post_id, $sent_id) = split "-", $file;
        $post{$post_id} = 1;
    }
    foreach my $post_id (keys %post) {
        my @post_sents = `ls $input_dir/$post_id-*`;
        chomp (@post_sents);
        my $input_string = join " ", @post_sents;
        my $output = "$output_dir/$post_id";
        `./lexparser.sh $input_string > $output` ;
    }

#    foreach my $file (@files) {
#        next if ($file =~ m/parsed/);
#        my $input = "$input_dir/$file";
#        my $output = "$output_dir/$file";
#        `./lexparser.sh $input > $output` ;
#    }
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
