#!/usr/bin/perl
# script: corpus_to_cos.pl
# functionality: Calculates cosine similarity for a corpus

use strict;
use warnings;

use Getopt::Long;

use Clair::Cluster;
use Clair::IDF;

sub usage;

my $corpus_name = "";
my $basedir = "produced";
my $out_file = "";
my $sample_docs_size = 0;
my $sample_pairs_size = 0;
my $verbose = 0;
my $stem = 1;
my $idf = "default";

my $res = GetOptions("corpus=s" => \$corpus_name, "base=s" => \$basedir,
                     "output:s" => \$out_file, "sample_docs=i" => \$sample_docs_size, "sample_pairs=i" => \$sample_pairs_size,
                     "stem!" => \$stem, "verbose!" => \$verbose, "idf=s" => \$idf);

if (!$res or ($corpus_name eq "") or ($basedir eq "")) {
  usage();
  exit;
}

my $gen_dir = "$basedir";
my $corpus_data_dir = "$gen_dir/corpus-data/$corpus_name";
my $linkfile = "$corpus_data_dir/$corpus_name.links";
my $doc_to_file = "$corpus_data_dir/" . $corpus_name . "-docid-to-file";
my $doc_to_url = "$corpus_data_dir/" . $corpus_name . "-docid-to-url";
my $compress_dbm = "$corpus_data_dir/" . $corpus_name . "-compress-docid";

if ($verbose) { print "Loading corpus into cluster\n"; }
my $cluster = new Clair::Cluster;
load_corpus($cluster, docid_to_file_dbm => $doc_to_file);
$cluster->strip_all_documents;
if ($stem) {
  $cluster->stem_all_documents;
}

if($sample_docs_size){
   $cluster=$cluster->extract_sample_cluster($sample_docs_size);
}

my $text_type = "";
if ($stem) {
  $text_type = "stem";
} else {
  $text_type = "text";
}
my %cos_matrix=();

#set_IDFs();

if($idf eq "corpus"){
    #if ($stem) {
     #         $idf = "$corpus_data_dir/" . $corpus_name . "-idf-s";
     #} else {
      #        $idf = "$corpus_data_dir/" . $corpus_name . "-idf";
     #}
     my $newidf = "$corpus_data_dir/" . $corpus_name . "-idf-s";
     Clair::IDF::open_nidf($newidf);
}elsif($idf eq "none"){
      $Clair::IDF::current_dbmname="none";
}elsif($idf eq "default"){
      Clair::IDF::open_nidf();
}else{
      Clair::IDF::open_nidf($idf);
}

if($sample_pairs_size){
    %cos_matrix = $cluster->compute_cosine_matrix(text_type => $text_type, sample_size=>$sample_pairs_size);
}else{
    %cos_matrix = $cluster->compute_cosine_matrix(text_type => $text_type);
}

#get_IDFs();

# default to corpus name + .cos if no output filename given
if ($out_file eq "") {
  $out_file = $corpus_name . ".cos";
}

my ($vol, $dir, $file);
($vol, $dir, $file) = File::Spec->splitpath($out_file);
if ($dir ne "") {
  unless (-d $dir) {
    mkdir $dir or die "Couldn't create $dir: $!";
  }
}


$cluster->write_cos($out_file, cosine_matrix => \%cos_matrix);

#
# Load a corpus into a cluster
#
sub load_corpus {
  my $self = shift;

  my %parameters = @_;

  my $property = ( defined $parameters{property} ?
                   $parameters{propery} : 'pagerank_transition' );

  my $ignore_EX = ( defined $parameters{ignore_EX} ?
                    $parameters{ignore_EX} : 1 );

  my %docid_to_file = ();

  if (defined $parameters{docid_to_file_dbm}) {
    my $docid_to_file_dbm_file = $parameters{docid_to_file_dbm};
    dbmopen %docid_to_file, $docid_to_file_dbm_file, 0666 or
      die "Cannot open DBM: $docid_to_file_dbm_file\n";
  }

  my %id_hash = ();

  foreach my $id (keys %docid_to_file) {
    if (not exists $id_hash{$id}) {
      if ($id eq "EX") {
        $id_hash{$id} = $id;
      } else {
        my $filename = $docid_to_file{"$id"};
        my ($vol, $dir, $fn) = File::Spec->splitpath($filename);
        my $doc = Clair::Document->new(file => "$filename", id => "$fn",
                                       type => 'html');
        $self->insert($doc->get_id, $doc);
        $id_hash{$id} = $doc;
      }
    }
  }
  return $self;
}

#
# use different IDFs: this is implemented in the hard way: moving the actual IDF files to somewhere else before calculating the value.
#
#
sub set_IDFs {
        my $idf_file = "";

        if ($idf eq 'default') {
                if ($stem) {
                        $idf_file = "$corpus_data_dir/" . $corpus_name . "-idf-s";
                } else {
                        $idf_file = "$corpus_data_dir/" . $corpus_name . "-idf";
                }
                if (-e $idf_file) {
                        Clair::IDF::open_nidf($idf_file);
                } else {
                        print STDERR "Could not find IDF file, have you run index_corpus.pl yet?\n";
                }
        } elsif ($idf eq 'none') {
                `rm -rf $gen_dir/$corpus_name/tmp_idf`;
                `mkdir -p $gen_dir/$corpus_name/tmp_idf`;
                `mv $corpus_data_dir/*idf* $gen_dir/$corpus_name/tmp_idf 2>/dev/null`;
        } else {
                `rm -rf $gen_dir/$corpus_name/tmp_idf`;
                `mkdir -p $gen_dir/$corpus_name/tmp_idf`;
                `mv $gen_dir/$corpus_name/*build-idf.log $gen_dir/$corpus_name/tmp_idf 2>/dev/null`;
                `mv $gen_dir/$corpus_name/*-idf $gen_dir/$corpus_name/tmp_idf 2>/dev/null`;
                `mv $gen_dir/$corpus_name/*-idf-s $gen_dir/$corpus_name/tmp_idf 2>/dev/null`;
                if ($stem) {
                `cp $idf $corpus_data_dir/$corpus_name-idf-s`;
                } else {
                `cp $idf $corpus_data_dir/$corpus_name-idf`;
                }
        }
}

#
# get the IDFs back
#
#
sub get_IDFs {
        `mv $gen_dir/$corpus_name/tmp_idf/* $corpus_data_dir 2>/dev/null`;
        `rm -rf $gen_dir/$corpus_name/tmp_idf`;
}


#
# Print out usage message
#
sub usage
{
        print "usage: $0 -c corpus_name -o out_file [-b base_dir]\n\n";
        print "  -c corpus_name\n";
        print "       Name of the corpus\n";
        print "  -b base_dir\n";
        print "       Base directory filename.  The corpus is loaded from here\n";
        print "  -o out_file\n";
        print "       Name of file to write network to\n";
        print "  --sample_docs sample_size\n";
        print "       Instead of computing cosines for the entire corpus, sample sample_size documents uniformly from the document set\n";
        print "  --sample_pairs sample_size\n";
        print "       Instead of computing cosines for all possible document pairs, sample sample_size pairs uniformly\n";
        print "  --stem or --no-stem\n";
        print "       Use the stemmed or unstemmed version of the corpus to generate the cosine files, default is stem\n";
        print "  --idf [default|none|path_to_idf]\n";
        print "       compute the cosine matrix using different IDFs\n";
        print "       default: use the default IDF of clairlib\n";
        print "       none: don't use any IDF files\n";
        print "       path_to_idf: use some other IDF file\n";

        print "\n";

        print "example: $0 -c bulgaria -o data/bulgaria.graph -b /data0/projects/lexnets/pipeline/produced\n";

        exit;
}

