#!/usr/local/bin/perl -w
use strict;

use Clair::Cluster;
use Clair::Network::Centrality::LexRank;
use Clair::Document;
use File::Copy;


my $stem = shift;

my @titleforid = ();

my $index = 0 ;

open IN, "$stem.txt";

while(my $title = <IN>){
    chomp $title;
    $titleforid[$index] = $title;
    ++$index;
}
close IN;

my $i = 0 ;
my %used_num;
my $random_num;

my $cluster = Clair::Cluster->new();
$cluster->load_lines_from_file("$stem.txt");

$cluster->stem_all_documents();

print "Now computing Cosine similarity\n";

my %cos_hash = $cluster->compute_cosine_matrix();

my $tt;
my $pp;

open OUT, ">$stem.cos";
#print "\n";
#print "COSINE MATRIX:\n";
#print "########################################################\n";
foreach $tt (sort keys %cos_hash){
    foreach $pp (sort keys %{$cos_hash{$tt}}){
        print OUT "$tt $pp $cos_hash{$tt}{$pp}\n";
    }
   # print "\n";
}
close OUT;
#print "########################################################\n";
#print"\n";
print "LexRank Distribution:\n\n";

my $network = $cluster->create_network(cosine_matrix => \%cos_hash);
#$network->export_to_Pajek($network, "99win.net");

my $cent  = Clair::Network::Centrality::LexRank->new($network);
$cent->save_lexrank_probabilities_to_file("$stem.prob");
#$cent->centrality();
my $dist = $cent->normalized_centrality();
open OUTF, ">$stem.lr";

foreach my  $v (sort {$dist->{$b} <=> $dist->{$a};} keys %{$dist}){
    print OUTF  "$v   $dist->{$v}\n";#\"$titleforid[$v]\"\n";
}
close OUTF;
