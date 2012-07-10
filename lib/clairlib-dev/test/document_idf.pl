#!/usr/local/bin/perl

# script: test_document_idf.pl
# functionality: Loads documents from an input dir; strips and stems them,
# functionality: and then builds an IDF from them 

use strict;
use warnings;
use FindBin;
use DB_File;
use Clair::Document;
use Clair::Cluster;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/document_idf";
my $gen_dir = "$basedir/produced/document_idf";

my $c = Clair::Cluster::->new();

$c->load_documents("$input_dir/*.txt", type => 'html');

$c->strip_all_documents();
$c->stem_all_documents();

my %idf_hash = $c->build_idf("$gen_dir/idf-dbm", type => 'text');

foreach my $k (keys %idf_hash) {
	print "$k\t", $idf_hash{$k}, "\n";
}
