#!/usr/bin/perl
# script: cos_to_cosplots.pl
# functionality: Generates cosine distribution plots, creating a
# functionality: histogram in log-log space, and a cumulative cosine plot
# functionality: histogram in log-log space
#
# Based on the make_cosiine_plots.pl script by Alex
#

use strict;
use warnings;

use File::Spec;
use Getopt::Long;

sub usage;

sub plot {
  my $fh = shift;
  my $data = shift;

  print $fh "plot($data);\n";
}

sub loglog_plot {
  my $fh = shift;
  my $data = shift;

  print $fh "loglog($data);\n";
}

sub set_labels {
  my $fh = shift;
  my $title = shift;
  my $xlabel = shift;
  my $ylabel = shift;

  print $fh "title(['" . $title . "']);\n";
  print $fh "xlabel('" . $xlabel . "');\n";
  print $fh "ylabel('" . $ylabel . "');\n";
}


sub set_font {
  my $fh = shift;

  # Change label font sizes
  print $fh "h = get(gca, 'title');\n";
  print $fh "set(h, 'FontSize', 16);\n";
  print $fh "h = get(gca, 'xlabel');\n";
  print $fh "set(h, 'FontSize', 16);\n";
  print $fh "h = get(gca, 'ylabel');\n";
  print $fh "set(h, 'FontSize', 16);\n";
}

sub save_plot {
  my $fh = shift;
  my $fn = shift;

  print $fh "v = axis;\n";
  print $fh "v(1) = 0; v(2) = 1;\n";
  print $fh "axis(v)\n";
  print $fh "print ('-deps', '$fn.eps')\n";
  print $fh "saveas(gcf, '$fn.jpg', 'jpg'); \n";
}

sub plot_all {
  my $fh = shift;
  my $type = shift;
  my $num = shift;

  my $held = 0;
  for (my $i = 1; $i <= $num; $i++) {
    if ($type eq "loglog") {
      loglog_plot($fh, "x(:,1,$i), x(:,2,$i)");
    } elsif ($type eq "plot") {
      plot($fh, "x(:,1,$i), x(:,2,$i)");
    }
    if (!$held) {
      print $fh "hold all;\n";
      $held = 1;
    }
  }
}

sub write_cosine_hist {
  my $fh = shift;
  my $name = shift;
  my $fn = shift;
  my $type = shift;
  my $num = shift;

  plot_all($fh, $type, $num);
  set_labels($fh, "Number of pairs per cosine in $name",
             "Cosine Value",
             "Number of pairs");
  set_font($fh);
  save_plot($fh, $fn);
}

sub write_cumulative_cosine {
  my $fh = shift;
  my $name = shift;
  my $fn = shift;
  my $type = shift;
  my $num = shift;

  plot_all($fh, $type, $num);
  set_labels($fh, "Number of pairs per cosine in $name",
             "Cosine Threshold Value",
             "Number of pairs w/cosine less than or equal to threshold");
  set_font($fh);
  save_plot($fh, $fn);
}

my @cos_files = ();
my $num_bins = 100;
my $output_name = "";

my $res = GetOptions("input=s" => \@cos_files, "bins:i" => \$num_bins,
                     "output=s" => \$output_name);

if (!$res || (!@cos_files) || ($output_name eq "")) {
  print "please provide both input and output file name\n";
  usage();
  exit;
}

my $fname = $output_name . "-cosine-hist.m";
my $fname2 = $output_name . "-cosine-cumulative.m";
open(OUT,">$fname") or die ("Cannot write to $fname");
open(OUT2,">$fname2") or die ("Cannot write to $fname2");

my $i = 0;
foreach my $cos_file (@cos_files) {
  $i++;
  my $cosines = "$cos_file";

  my @link_bin = ();
  $link_bin[$num_bins] = 0;

  my $link_total = 0;
  my $link_count = 0;
  my %cos_hash = ();

  my ($doc1,  $doc2,  $cos);
  open (COS, $cosines) or die "cannot open $cosines\n";

  while(<COS>) {
    chomp;
    ($doc1, $doc2, $cos) = split;
    my $key1 = "$doc1 $doc2";
    my $key2 = "$doc2 $doc1";

    if (($doc1 ne $doc2) &&
        !(exists $cos_hash{$key2}) &&
        !(exists $cos_hash{$key1})) {

      $cos_hash{$key1} = 1;
      my $c = $cos;
      my $d = get_index($c);
      $link_bin[$d]++;
      $link_total += $cos;
      $link_count++;
    }
  }
  close(COS);

  # print final info
  print "average cosine is " . $link_total/$link_count . "\n" if
    $link_count>0;

  my $cumulative=0;

  print OUT "x(:,:,$i) = [";
  print OUT2 "x(:,:,$i) = [";
  foreach my $i (0..$#link_bin) {
    my $out = $link_bin[$i];
    if(not defined $link_bin[$i]) {
      $out = 0;
    }
    $cumulative+= $out;
    my $thres = $i/100;
    #   print "$thres $out\n";
    print OUT "$thres $out;\n";
    print OUT2 "$thres $cumulative;\n";
  }
  print OUT "];\n";
  print OUT2 "];\n";
}


my $out_filename;

$out_filename = $output_name . "-cosine-hist-loglog";
write_cosine_hist(*OUT, $output_name, $out_filename, "loglog", $i);
print OUT "hold off;\n\n";

$out_filename = $output_name . "-cosine-cumulative-loglog";
write_cumulative_cosine(*OUT2, $output_name, $out_filename, "loglog", $i);
print OUT2 "hold off;\n\n";

$out_filename = $output_name . "-cosine-hist";
write_cosine_hist(*OUT, $output_name,  $out_filename, "plot", $i);

$out_filename = $output_name . "-cosine-cumulative";
write_cumulative_cosine(*OUT2, $output_name, $out_filename, "plot", $i);

close OUT;
close OUT2;


sub get_index {
  my $d = shift;
  my $c = int($d * $num_bins+0.000001);
#  print "$c $d\n";
  return $c;
}

sub usage {
  print "Usage $0 --input input_file [--bins num_bins]\n\n";
  print "  --input input_file\n";
  print "       Name of the input graph file.  Multiple inputs can be\n";
  print "       specified.  Simply add additional --input arguments\n";
  print "  --output outputprefix\n";
  print "       Prefix to append to output files.  Also, title to use for\n";
  print "       graphs\n";
  print "  --bins num_bins\n";
  print "       Number of bis\n";
  print "       num_bins is optional, and defaults to 100\n";
  print "\n";
  exit;
}

