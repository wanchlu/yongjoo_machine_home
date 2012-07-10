#!/usr/bin/perl
#
# script: network_to_plots.pl
# functionality: Generates degree distribution plots, creating a
# functionality: histogram in log-log space, and a cumulative degree
# functionality: distribution histogram in log-log space.
#
# Based on the make_cosine_plots.pl script by Alex
#
use strict;
use warnings;

use File::Spec;
use Getopt::Long;

sub usage;

my $cos_file = "";
my $num_bins = 100;

my $res = GetOptions("input=s" => \$cos_file, "bins:i" => \$num_bins);

if (!$res || ($cos_file eq "")) {
  usage();
  exit;
}

my ($vol, $dir, $hist_prefix) = File::Spec->splitpath($cos_file);
$hist_prefix =~ s/\.graph//;

my $cosines = "$cos_file";

my @link_bin = ();
$link_bin[$num_bins] = 0;

my %cos_hash = ();

my ($key1,  $key2);
open (COS, $cosines) or die "cannot open $cosines\n";

while(<COS>) {
  chomp;
  ($key1, $key2) = split;

  next if (! defined $key1 || ! defined $key2);
  if (($key1 ne $key2) &&
      !(exists $cos_hash{$key2}) &&
      !(exists $cos_hash{$key1})) {

    $cos_hash{$key1} = 1;
  }
  if (exists $cos_hash{$key2}) {
    $cos_hash{$key1}++;
  }
}
close(COS);

foreach my $cos (keys %cos_hash) {
  my $deg = $cos_hash{$cos};
  my $d = get_index($deg);
  $link_bin[$d]++;
}

#print "cosine histogram:\n";

# Commented out  by alex
# Fri Apr 22 23:18:40 EDT 2005
#
# For some reason, matlab decided that today it does not
#  like full paths. So we take them out, and pat matlab
#  on the head.
#
# Just remember that this will produce plots in the
#  current directory now, so CD in to wherever you need
#  to be before piping this stuff into matlab.
#
my $fname = $hist_prefix . "-cosine-hist.m";
my $fname2 = $hist_prefix . "-cosine-cumulative.m";
open(OUT,">$fname") or die ("Cannot write to $fname");
open(OUT2,">$fname2") or die ("Cannot write to $fname2");
print OUT "x = [";
print OUT2 "x = [";
my $cumulative=0;

foreach my $i (0..$#link_bin)
{
   my $out = $link_bin[$i];
   if(not defined $link_bin[$i])
   {
      $out = 0;
   }
   $cumulative += $out;
   my $thres = $i;
   print OUT "$thres $out\n";
   print OUT2 "$thres $cumulative\n";
}

print OUT "];\n";

my $out_filename = "$hist_prefix"."-cosine-hist";
print OUT "loglog(x(:,1), x(:,2));\n";
print OUT "title(['Degree Distribution of $hist_prefix']);\n";
print OUT "xlabel('Degree');\n";
print OUT "ylabel('Number of Nodes');\n";
#print OUT "v = axis;\n";
#print OUT "v(1) = 0; v(2) = 1;\n";
#print OUT "axis(v)\n";
print OUT "print ('-deps', '$out_filename.eps')\n";
print OUT "saveas(gcf, '$out_filename" . ".jpg', 'jpg'); \n";
close OUT;

$out_filename = $hist_prefix . "-cosine-cumulative";
print OUT2 "];\n";
print OUT2 "loglog(x(:,1), x(:,2));\n";
print OUT2 "title(['Degree Distribution of $hist_prefix']);\n";
print OUT2 "xlabel('Degree');\n";
print OUT2 "ylabel('Number of Nodes');\n";
print OUT2 "v = axis;\n";
print OUT2 "v(1) = 0; v(2) = 1\n";
print OUT2 "axis(v)\n";
print OUT2 "print ('-deps', '$hist_prefix-cosine-cumulative.eps')\n";
print OUT2 "saveas(gcf, '$out_filename" . ".jpg', 'jpg'); \n";
close OUT2;


sub get_index {
  my $d = shift;
  my $c = int($d * $num_bins + 0.000001);
#  print "$c $d\n";
  return $c;
}

sub usage {
  print "Usage $0 --input input_file [--bins num_bins]\n\n";
  print "  --input input_file\n";
  print "       Name of the input graph file\n";
  print "  --bins num_bins\n";
  print "       Number of bins\n";
  print "       num_bins is optional, and defaults to 100\n";
  print "\n";
  exit;
}

