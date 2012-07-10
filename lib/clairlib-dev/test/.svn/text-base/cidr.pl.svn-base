#!/usr/local/bin/perl

# script: test_cidr.pl
# functionality: Creates a CIDR from input files and writes sample
# functionality: centroid files 

use warnings;
use strict;
use FindBin;
use Clair::Cluster;
use Clair::CIDR;
use Getopt::Long;

my $input_dir = "$FindBin::Bin/input/cidr";
my $output_dir = "$FindBin::Bin/produced/cidr";

unless (-d $output_dir) {
    mkdir $output_dir or die "Couldn't mkdir $output_dir: $!";
}

opendir INPUT, $input_dir or die "Couldn't opendir $input_dir: $!";
my @files = map { "$input_dir/$_" } grep { /\.txt$/ } readdir INPUT;
closedir INPUT;

my $cluster = Clair::Cluster->new();
$cluster->load_file_list_array(\@files, type => "text");

my $cidr = Clair::CIDR->new();
my @results = $cidr->cluster($cluster);

chdir $output_dir or die "Couldn't chdir to $output_dir: $!";
foreach my $result (@results) {

    my $cluster = $result->{cluster};
    my $centroid = $result->{centroid};

    my @words= sort { $centroid->{$b} <=> $centroid->{$a} } keys %$centroid;
    my $docs = $cluster->documents();

    my $str = "$words[0]_$words[1]_$words[2]";
    mkdir "$str" or die "Couldn't mkdir $output_dir/$str: $!";

    open CENTROID, "> $str/centroid.txt" 
        or die "Couldn't open $str/centroid.txt: $!";
    foreach my $word (@words) {
        print CENTROID "$word\t$centroid->{$word}\n";
    }
    close CENTROID; 

    $cluster->save_documents_to_directory($str, "text");

    print "cluster: $str\n";
    map { print "\t$_\n" } keys %{ $cluster->documents() };
    print "\n";

}
