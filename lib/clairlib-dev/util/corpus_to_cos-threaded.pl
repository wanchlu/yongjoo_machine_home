#!/usr/bin/perl
# script: corpus_to_cos-threaded.pl
# functionality: Calculates cosine similarity using multiple threads
#

use strict;
use warnings;

use Getopt::Long;
use Clair::Cluster;
use MEAD::SimRoutines;
use Clair::IDF;
use threads;
use threads::shared;
use Thread::Queue;
use Storable qw(freeze thaw dclone);

select STDOUT; $| = 1;

sub usage;

my $corpus_name = "";
my $basedir = "produced";
my $output_file = "";
my $sample_size = 0;

my $res = GetOptions("corpus=s" => \$corpus_name, "base=s" => \$basedir,
		     "output:s" => \$output_file, "sample:i" => \$sample_size);

if (!$res or ($corpus_name eq "") or ($basedir eq "")) {
  usage();
  exit;
}

my $gen_dir = "$basedir";
my $verbose = 0;
my $documents : shared;

my $corpus_data_dir = "$gen_dir/corpus-data/$corpus_name";
my $linkfile = "$corpus_data_dir/$corpus_name.links";
my $doc_to_file = "$corpus_data_dir/" . $corpus_name . "-docid-to-file";
my $doc_to_url = "$corpus_data_dir/" . $corpus_name . "-docid-to-url";
my $compress_dbm = "$corpus_data_dir/" . $corpus_name . "-compress-docid";
my $idf_file = "$corpus_data_dir/" . $corpus_name . "-idf-s";

if ($verbose) { print "Loading corpus into cluster\n"; }
my $cluster = new Clair::Cluster;

print "Loading corpus\n";
load_corpus($cluster, $sample_size, docid_to_file_dbm => $doc_to_file);

$cluster->strip_all_documents;
$cluster->stem_all_documents;

my %documents = ();

print "Computing cosine matrix\n";

open_nidf($idf_file);

my %cos_matrix = compute_cosine_matrix($cluster, text_type => 'stem');

# default to corpus name + .cos if no output filename given
if ($output_file eq "") {
  $output_file = $corpus_name . ".cos";
}

$cluster->write_cos($output_file, cosine_matrix => \%cos_matrix);

#
# Load a corpus into a cluster
#
sub load_corpus {
  my $self = shift;
  my $sample_size = shift;

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
  my @id_array = ();
  my @sample_array = ();
  my %sample_hash = ();

  foreach my $id (keys %docid_to_file) {
    push @id_array, $id;
  }
  my $id_size = scalar(@id_array);

  if ($sample_size > 0) {
    srand;
    for (my $i = 0; $i < $sample_size; $i++) {
      push @sample_array, $id_array[int(rand($id_size))];
    }
  } else {
    @sample_array = @id_array;
  }

  print "Inserting ", scalar(@sample_array), " documents into cluster\n";
  foreach my $id (@sample_array) {
    if (not exists $id_hash{$id}) {
      if ($id eq "EX") {
	$id_hash{$id} = $id;
      } else {
	my $filename = $docid_to_file{"$id"};
	my $doc = Clair::Document->new(file => "$filename", id => "$id",
				       type => 'html');
	$self->insert($doc->get_id, $doc);
	$id_hash{$id} = $doc;
      }
    }
  }
  print "\n";

  return $self;
}


sub compute_cosine_matrix {
  my $self = shift;

  my %parameters = @_;

  my $text_type = "stem";
  if (exists $parameters{text_type}) {
    $text_type = $parameters{text_type};
  }

  # deep copy to keep threads::shared happy
  print "Copying documents object\n";
  %documents = %{$self->{documents}};

  my $i = 0;
  my $j = 0;
  my %cos_hash : shared = ();
  my $global_count : shared = 0;

  # Create the document queue
  print "Creating queue\n";
  my $jobs = new Thread::Queue;

  print "Adding ", scalar(keys %documents), " documents to queue\n";
  my $sum = 0;
  foreach my $doc1_key (keys %documents) {
    $i = 0;
    $j++;

    # setup the shared variable
    # must create nested shared data structures by first creating shared
    # leaf nodes (threads::shared docs)
    $cos_hash{$doc1_key} = &share({});

    foreach my $doc2_key (keys %documents) {
      $i++;
      if ($i < $j) {
	my @obj = ($doc1_key, $doc2_key);
# 	$sum++;
# 	if (($sum % 1000) == 0) {
# 	  print $sum / 1000, "\n";
# 	}
	$jobs->enqueue(freeze(\@obj));
      }
    }
  }

  # Create the worker threads
  print "Creating worker threads\n";
  my $x = 0;
  my @threads = ();
  $threads[$x++] = threads->new(\&threaded_cosine, $x, $jobs, \%cos_hash,
				\$global_count, $text_type) for (0..3);

  # wait for them to exit
  $x = 0;
  $threads[$x++]->join() for (0..3);

  $self->{cosine_matrix} = \%cos_hash;
  return %cos_hash;
}

sub threaded_cosine {
  my $num = shift;
  my $jobs = shift;
  my $cos_hash = shift;
  my $global_count = shift;
  my $text_type = shift;

  for (;;) {
    my $commanddata = thaw($jobs->dequeue_nb);
    return unless $commanddata;
    my ($doc1_key, $doc2_key) = @{$commanddata};
    my $doc1 = $documents{$doc1_key};
    my $doc2 = $documents{$doc2_key};
    my $cos = compute_document_cosine($doc1, $doc2, $text_type);
#    print "thread $num: $doc1_key\n";
    lock ($cos_hash);
    $cos_hash->{$doc1_key}{$doc2_key} = $cos;
    $cos_hash->{$doc2_key}{$doc1_key} = $cos;
#    lock($$global_count);
#    $$global_count++;
#    if (($$global_count % 10) == 0) {
#      print $$global_count / 10, "\n";
#    }
  }
}

#
# Split this out so we can make use of threading
#
sub compute_document_cosine {
  my $document1 = shift;
  my $document2 = shift;
  my $text_type = shift;

  my $text1 = "";
  my $text2 = "";
  if ($text_type eq "stem") {
    $text1 = $document1->get_stem;
    $text2 = $document2->get_stem;
  } elsif ($text_type eq "text") {
    $text1 = $document1->{text};
    $text2 = $document2->{text};
  }

  my $cos = GetLexSim($text1, $text2);

  return $cos;
}


#
# Print out usage message
#
sub usage
{
  print "usage: $0 -c corpus_name -o output_file [-b base_dir]\n\n";
  print "  -c corpus_name\n";
  print "       Name of the corpus\n";
  print "  -b base_dir\n";
  print "       Base directory filename.  The corpus is loaded from here\n";
  print "  -o output_file\n";
  print "       Name of file to write network to\n";
  print "  -s,--sample n\n";
  print "       Take a sample of size n from the documents\n";
  print "\n";

  print "example: $0 -c bulgaria -o data/bulgaria.cos -b /data0/projects/lexnets/pipeline/produced\n";

  exit;
}

