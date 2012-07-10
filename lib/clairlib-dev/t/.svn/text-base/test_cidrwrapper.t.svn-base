# script: test_cidrwrapper.t
# functionality: Using CIDR::Wrapper, add a document cluster and verify
# functionality: clustering 

use strict;
use warnings;
use FindBin;
use Test::More;
use Clair::Config;
use DB_File;

if (not defined $CIDR_HOME or not -d $CIDR_HOME) {
    plan( skip_all => 
        '$CIDR_HOME not defined or doesn\'t exist in Clair::Config' );
} else {
    plan( tests => 6 );
}

use_ok("Clair::CIDR::Wrapper");
use_ok("Clair::Cluster");

my $cidr = Clair::CIDR::Wrapper->new( 
    cidr_home => $CIDR_HOME, 
    dest => "$FindBin::Bin/produced/cidrwrapper/temp.cidr"
);

my $cluster = Clair::Cluster->new();
$cluster->load_documents("$FindBin::Bin/input/cidrwrapper/*");
$cidr->add_cluster($cluster);

my @results = $cidr->run_cidr();
is(@results, 2, "Two clusters");

foreach my $map(@results) {
    my $cluster = $map->{cluster};
    my $docs = $cluster->documents();
    if ($cluster->count_elements() == 2) {
        ok(exists $docs->{"fed1.txt"}, "fed1.txt exists");
        ok(exists $docs->{"fed2.txt"}, "fed2 txt exists");
    } else {
        ok(exists $docs->{"41.docsent"}, "41.docsent exists");
    }
}
