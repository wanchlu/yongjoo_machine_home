#!/usr/bin/perl
# script: extract_ngrams.pl
# author: Jonathan DePeri
# functionality: Extracts n-gram counts from a file or set of files in a directory,
#                or from a previously dumped n-gram dictionary. Provides options
#                to ignore thresholds having few occurrences.

use strict;
use warnings;

use Clair::Cluster;
use Clair::LM::Ngram qw(load_ngramdict dump_ngramdict extract_ngrams write_ngram_counts enforce_count_thresholds);
use File::Spec;
use Getopt::Long;

my $readfiles = "";
my $format;
my $loaddump = "";
my $writeout = "";
my $dumpout = "";
my $N;
my $mincount;
my $topcount;
my $stem = 0;
my $segment = 0;
my $sort = 0;
my $engine = "Clairlib";
my $verbose = 0;
my $help = 0;

my $res = GetOptions("readfiles=s"=> \$readfiles,
                     "format=s"   => \$format,
                     "loaddump=s" => \$loaddump,
                     "writeout=s" => \$writeout,
                     "dumpout=s"  => \$dumpout,
                     "N=i"        => \$N,
                     "mincount=i" => \$mincount,
                     "topcount=i" => \$topcount,
                     "stem!"      => \$stem,
                     "segment!"   => \$segment,
                     "sort!"      => \$sort,
                     "engine=s"     => \$engine,
                     "verbose!"   => \$verbose,
                     "help!"      => \$help );
$format = "html" if $readfiles and not defined $format;
$format = lc($format);

exit if not $res;

usage() and exit if $help;

abort("Must specify either --readfiles or --loaddump.\n") if ($readfiles eq "" and $loaddump eq "");
abort("Cannot specify both --readfiles and --loaddump.\n") if ($readfiles and $loaddump);
abort("--format must be either 'text' or 'html' (without the apostrophes).\n")
  if ($readfiles and $format ne "text" and $format ne "html");
abort("Specifying --readfiles requires --N.\n") if ($readfiles and not defined $N);
abort("Cannot specify --segment with N = 1, since sentence boundaries is irrelevant for unigrams.\n")
  if ($segment and $N == 1);
abort("Cannot specify both --loaddump and --format.\n") if ($loaddump and $format);
abort("Cannot specify both --loaddump and --N.\n") if ($loaddump and $N);
abort("Cannot specify both --loaddump and --stem.\n") if ($loaddump and $stem);
abort("Cannot specify both --loaddump and --segment.\n") if ($loaddump and $segment);
abort("Must specify either --writeout or --dumpout, or both.\n") if ($writeout eq "" and $dumpout eq "");
abort("--N must be at least 1.\n") if (defined $N and $N < 1);
abort("If specified, --mincount must be at least 1.\n") if (defined $mincount and $mincount < 1);
abort("If specified, --topcount must be at least 1.\n") if (defined $topcount and $topcount < 1);


if($engine eq "Clairlib"){
    my $r_ngramdict = {};
    if ($readfiles) {
        print "Reading file(s) $readfiles ...\n" if ($verbose);
        my $r_cluster = Clair::Cluster->new;
        $r_cluster->load_documents($readfiles,
                                   type => $format,
                                   filename_id => 1);
        print scalar keys %{$r_cluster->documents()}, " document(s) read.\n" if ($verbose);

        extract_ngrams(cluster   => $r_cluster,
                       N         => $N,
                       ngramdict => $r_ngramdict,
                       format    => $format,
                       stem      => $stem,
                       segment   => $segment,
                       verbose   => $verbose );
    } elsif ($loaddump) {
        print "Loading n-gram dictionary dump from $loaddump ...\n" if ($verbose);
        ($N, $r_ngramdict) = load_ngramdict(infile => $loaddump);
        print "$N-gram dictionary loaded.\n";
    }

    if (defined $mincount or defined $topcount) {
        if ($verbose) {
            print "Removing $N-grams ", (defined $topcount ? "not ranking among the top $topcount" : ""),
                                        (defined $topcount and defined $mincount ? " or " : ""),
                                        (defined $mincount ? "with count < $mincount" : ""),
                                        " ...\n";
        }
        enforce_count_thresholds(N => $N,
                                 ngramdict => $r_ngramdict,
                                 mincount  => $mincount,
                                 topcount  => $topcount );
    }

    if ($writeout) {
        print "Writing ", ($sort ? "sorted" : "unsorted"), " $N-gram counts to $writeout ...\n" if ($verbose);
        write_ngram_counts(N         => $N,
                           ngramdict => $r_ngramdict,
                           outfile   => $writeout,
                           sort      => $sort );
    }
    if ($dumpout) {
        print "Serializing $N-gram dictionary to $dumpout ...\n" if ($verbose);
        dump_ngramdict(N         => $N,
                       ngramdict => $r_ngramdict,
                       outfile   => $dumpout );
    }
}elsif($engine eq "CMU_LM"){

    print "Starting to process n-grams, filetype is \"$format\"\n" if($verbose);
    # First, we get all source files into one tempfile
    print "Consolidating source files...\n" if($verbose);
    my $input_file = "tmp_0000";
    `cat $readfiles > $input_file`;

    #print "Getting sentences...\n" if($verbose);
    my $doc = new Clair::Document(file => "$input_file", type => "$format");

    if($format eq "html"){
        $doc->strip_html();
    }
    my $temp_filename = $input_file . "\_formatted-sentences";
    if(!$segment){
           my $text;
           if($stem){
               $doc->stem();
               $text = $doc->get_stem();
           }else{
               $text = $doc->get_text();
           }


           # Print it out in the format we want into a temporary file
           # print "Formatting sentences...\n" if($verbose);

           open(OUTPUT, ">" . "$temp_filename") or die "Can't open $temp_filename\n";
           print OUTPUT $text;
           close OUTPUT;
    }else{
           if($stem){
               $doc->stem();
               $doc = new Clair::Document(string => $doc->get_stem, type =>"text");
           }

           my @sentences = $doc->get_sentences;

           # Print it out in the format we want into a temporary file
           print "Formatting sentences...\n" if($verbose);
           open(OUTPUT, ">" . "$temp_filename") or die "Can't open $temp_filename\n";
           #print OUTPUT "<START> ";
           my $temp_string = "";
           for(my $j = 0; $j < scalar(@sentences); $j++){
               $temp_string = $sentences[$j];
               $temp_string =~ s/\s+/ /g;
               unless ($j == scalar(@sentences) - 1){ print OUTPUT "$temp_string <s>\n"; }
               else { print OUTPUT "$temp_string\n"; }
           }
           close OUTPUT;
    }
    # CMU-LM wants its input in UNIX format
    `dos2unix $temp_filename`;
    `chmod 0664 $temp_filename`;

    print "Calling text2wngram...\n\n" if($verbose);

    # Use CMU-LM to generate bigrams
    my $ngrams_file = $writeout;
    `cat $temp_filename | text2wngram -n $N -temp /tmp > $ngrams_file`;

    `rm $temp_filename`;
    `rm $input_file`;
    $doc = undef;

    if($sort){
          print "Reading n-grams list to an array...\n" if($verbose);
          open (INPUT, "$ngrams_file");
          my @ngrams = <INPUT>;
          close INPUT;
          chomp(@ngrams);
          my %ngrams_hash=();
          foreach my $ngram(@ngrams){
               my @parts = split (/\s+/,$ngram);
               my $words = "";
               for(my $i=0;$i<scalar(@parts)-1;$i++){
                   $words.=$parts[$i]." ";
               }
               if((not defined $mincount or $mincount <= $parts[scalar(@parts)-1]) and
                   (not defined $topcount or $topcount >= $parts[scalar(@parts)-1])){
                        $ngrams_hash{$words}=$parts[scalar(@parts)-1];
               }
          }
          open OUT,">$writeout" or die "Can't open file";

          foreach my $ngram2 (sort{$ngrams_hash{$b} <=> $ngrams_hash{$a}} keys %ngrams_hash){
                  print OUT $ngram2," ", $ngrams_hash{$ngram2},"\n";
          }
    }

}else{
      print STDERR "Invalid engine, $engine. Valid engines are Clairlib and CMU_LM\n";
}
print "Done.\n" if ($verbose);


sub usage {
    print "Usage: $0 [-r fileexpr | -l dumpfile] [-f filefmt] [-w outfile] [-d outfile] -N len [-min J] [-engin Clairlib|CMU_LM] [-top K] [-stem] [-segment] [-sort] [-v]\n";
    print "Extract n-grams counts from text or html documents, or from a previous dump.\n";
    print "Ignores low-count n-grams as specified.\n";
    print "\n";
    print "Arguments:\n";
    print "\n";
    print "  --readfiles fileexpr\n";
    print "       Input file expression, eg. \"docs/*.txt\". Bigrams will be extracted\n";
    print "       from by reading all files matching this expression.\n";
    print "       NOTE: To guarantee wildcard expressions match file names as expected,\n";
    print "             fileexpr should be enclosed in quotes.\n";
    print "  --format filefmt\n";
    print "       Input file format: either 'html' or 'text'. Default is 'html'.\n";
    print "  --loaddump infile\n";
    print "       Loads previously extracted n-gram dictionary from dump file.\n";
    print "  --writeout outfile\n";
    print "       File where n-gram dictionary is to be written. Must be specified\n";
    print "       if --dumpfile is not specified.\n";
    print "  --dumpout outfile\n";
    print "       File where n-gram dictionary hash is to be dumped for later reloading.\n";
    print "       Must be specified if --writeout is not specified.\n";
    print "  --N ngram_len\n";
    print "       Length of n-grams to be extracted. Must be at least 1.\n";
    print "  --mincount J\n";
    print "       If specified, ignores all n-grams having less than J occurrences;\n";
    print "       must be at least 1. Default is 1.\n";
    print "  --topcount J\n";
    print "       If specified, ignores all n-grams not among the top J in number of\n";
    print "       occurrences; must be at least 1. Defaults to the total number of.\n";
    print "       n-grams.\n";
    print "  --stem\n";
    print "       If set, uses stemmed terms. Default is unstemmed.\n";
    print "  --segment\n";
    print "       If set, segments sentences using the sentence segmenter defined in\n";
    print "       Clair::Config. A term occurring at sentence beginning occurs in a\n";
    print "       bigram (\".\", term); a term occurring at sentence end occurs in a\n";
    print "       bigram (term, \".\"). Default is unsegmented, in which case bigrams\n";
    print "       are composed only of terms.\n";
    print "  --sort\n";
    print "       If set, together with --writeout, sorts n-gram counts output in\n";
    print "       descending order by count. Default is unsorted.\n";
    print "  --engine Clairlib|CMU_LM\n";
    print "       The engine used to extract the N-grams\n";
    print "  --verbose\n";
    print "       If set, displays status during processing. Default is not verbose.\n";
    print "\n";
    print "example: $0 -r \"docs/*.txt\" -f text -w doc.2gram -d doc.2gram.dump -N 2 -top 10 -threshold 100 -stem -segment -sort -v\n";

    exit;
}


sub abort{
    print $_[0] and exit;
}
