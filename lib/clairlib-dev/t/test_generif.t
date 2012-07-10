# script: test_generif.t
# functionality: Test Clair::Bio::GeneRIF's basic record retrieval functions 

use strict;
use warnings;
use FindBin;
use File::Copy;
use Clair::Bio::GeneRIF;
use Test::More tests => 5;

my $docs_dir = "$FindBin::Bin/input/generif";
my $out_dir = "$FindBin::Bin/produced/generif";
my $testfile = "test_inter.txt";
my $testfile2 = "test_inter2.txt";

unless (-d $out_dir) {
    mkdir($out_dir) or die "Could not create directory $out_dir: $!";
}

if (-f "$out_dir/$testfile") {
    unlink("$out_dir/$testfile") or die "Could not delete pre-existing output file $out_dir/$testfile: $!";
}

if (-f "$out_dir/$testfile.dbm") {
    unlink("$out_dir/$testfile.dbm") or die "Could not delete pre-existing DBM output file $out_dir/$testfile.dbm: $!";
}

copy("$docs_dir/$testfile", "$out_dir/$testfile")
    or die "Could not copy $docs_dir/$testfile to $out_dir/$testfile: $!";

my $generif = Clair::Bio::GeneRIF->new(
    path => "$out_dir/$testfile"
);

is($generif->get_total_records(), 9, "Test records before");

$generif = Clair::Bio::GeneRIF->new(
    path => "$out_dir/$testfile"
);
is($generif->get_total_records(), 9, "Same number of records");

# Trim off the bottom line
system("head -9 $out_dir/$testfile > $out_dir/$testfile2");
move("$out_dir/$testfile2", "$out_dir/$testfile");


$generif = Clair::Bio::GeneRIF->new(
    path => "$out_dir/$testfile",
    reload => 1
);
is($generif->get_total_records(), 8, "Test records after");


my @records = $generif->get_records_from_id(1224324);
is(@records, 2, "Sample records size");
my $record = $records[0];
is($record->[4], "", "Convert '-' to ''");
