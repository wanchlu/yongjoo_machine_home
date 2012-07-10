# script: test_cidr.t
# functionality: Verify CIDR functionality, document sketches, cluster
# functionality: insertion, clustering  

use Test::More tests => 15;
use Clair::CIDR;
use Clair::Document;

my $cidr = Clair::CIDR->new();

#######################
# Test _sketch_document
#######################
my $text1 = "The Cat loves the Dog";
my $doc1 = Clair::Document->new( type => "text", string => $text1, id => 1 );

my $sketch1 = $cidr->_sketch_document($doc1);
is( $sketch1->get_text(), "cat loves dog", "get_text" );

my $text2 = join " ", ( ("spam") x 500 );
my $exp2 = join " ", ( ("spam") x 200 );
my $doc2 = Clair::Document->new( type => "text", string => $text2, id => 2 );
my $sketch2 = $cidr->_sketch_document($doc2);
is( $sketch2->get_text(), $exp2, "get_text with spam" );


##################################
# Test _insert_into_sketch_cluster 
##################################
my $text3 = "The Cat and the dog live in Egypt";
my $doc3 = Clair::Document->new( type => "text", string => $text3, id => 3 );
my $sketch3 = $cidr->_sketch_document($doc3);
my $cluster3 = Clair::Cluster->new();
my %centroid3 = $cidr->_insert_into_sketch_cluster($sketch3, $cluster3);
ok(defined $centroid3{cat}, "centroid{cat} defined");
ok(defined $centroid3{dog}, "centroid{dog} defined");
ok(defined $centroid3{live}, "centroid{live} defined");
ok(defined $centroid3{egypt}, "centroid{egypt} defined");

# eleven words
my $text4 = "physiological statistically president establishment constricted "
          . "limitations monkey specialise specimen nominated adventure";
my $doc4 = Clair::Document->new( type => "text", string => $text4, id => 4 );
my $cidr4 = Clair::CIDR->new( keep_words => 10, keep_threshold => 100 );
my $sketch4 = $cidr4->_sketch_document($doc4);
my %centroid4 = $cidr4->_insert_into_sketch_cluster($sketch4, 
    Clair::Cluster->new());
is(scalar keys %centroid4, 10, "ten word cluster");
$cidr4->param( keep_threshold => 0 );
my %centroid5 = $cidr4->_insert_into_sketch_cluster($sketch4, 
    Clair::Cluster->new());
is(scalar keys %centroid5, 11, "now eleven words");


################
# Test cluster()
################
my @text = ("Cats and dogs chase each other.", "Cats chase mice.", 
    "Hello, Mr. President.");
my $cluster = Clair::Cluster->new();
for (my $i = 0; $i< @text; $i++) {
    my $doc = Clair::Document->new( id => $i, type => "text", 
        string => $text[$i] );
    $cluster->insert($doc->get_id(), $doc);
}

my $cidr5 = Clair::CIDR->new();
my @results = $cidr5->cluster($cluster);
is(scalar @results, 2, "clustered into 2 clusters");
foreach my $hashref (@results) {
    my $subcluster = $hashref->{cluster};
    my $centroid = $hashref->{centroid};

    if ($subcluster->count_elements() == 1) {
        ok($subcluster->has_document(2), "unit subcluster contains 2");
        ok(defined $centroid->{hello}, "unit subcluster centroid{hello}");
    } elsif ($subcluster->count_elements() == 2) {
        ok($subcluster->has_document(0), "subcluster contains 0");
        ok($subcluster->has_document(1), "subcluster contains 1");
        ok(defined $centroid->{cats}, "subcluster centroid{cats}");
        ok(defined $centroid->{chase}, "subcluster centroid{chase}");
    }

}
