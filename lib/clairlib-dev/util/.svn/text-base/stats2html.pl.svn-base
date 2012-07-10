#!/usr/bin/perl
# Generate a matlab script file from a space delimited spreadsheet

use strict;
use warnings;
use Getopt::Long;
use File::Spec;

sub usage;

my $delim = "[ \t]+";
my $infile = "";
my $outfile = "";
my $start = 0.0;
my $end = 1.0;
my $inc = 0.01;

my $res = GetOptions("input=s" => \$infile, "output=s" => \$outfile,
                     "start=f" => \$start, "step=f" => \$inc,
                     "end=f" => \$end);

if (!$res or ($infile eq "") or ($outfile eq "")) {
  usage();
  exit;
}

my ($vol, $dir, $prefix) = File::Spec->splitpath($outfile);
$prefix =~ s/\.html//;

my $line;
my $cnt = 0;
my %headers = ();
my @data = ();

open(OUTFILE, "> $outfile") or die "Couldn't open: $!\n";
open(INFILE, $infile) or die "Couldn't open: $!\n";

while (<INFILE>) {
        chomp;
        my @cols = split(/ /, $_);
        for(my $i = 0; $i < scalar(@cols); $i++) {
                if ($cnt == 0) {
                        $headers{$i} = $cols[$i];
                } else {
                        $data[$i][$cnt - 1] = $cols[$i];
                }
        }
        $cnt++;
}
close INFILE;

print OUTFILE "<HTML>\n";
print OUTFILE "<HEAD><TITLE>$prefix</TITLE></HEAD>\n";
print OUTFILE "<BODY>\n";

foreach my $col (keys %headers) {
  my $header = $headers{$col};
  if ($header ne "threshold") {
    print OUTFILE "<table class=\"image\">\n";
    print OUTFILE "  <tr>\n";
    print OUTFILE "    <td><a href=\"../plots/$prefix-$header.jpg\">";
    print OUTFILE "<img src=\"../plots/$prefix-$header.jpg\">";
    print OUTFILE "</a></td>\n";
    print OUTFILE "\n";
    print OUTFILE "    <td><a href=\"../plots/$prefix-synth-$header.jpg\">";
    print OUTFILE "<img src=\"../plots/$prefix-synth-$header.jpg\">";
    print OUTFILE "</a></td>\n";
    print OUTFILE "\n";
    print OUTFILE "  </tr>\n";
    print OUTFILE "  <tr>\n";
    print OUTFILE "    <td>$header vs. threshold</td>\n";
    print OUTFILE "    <td>synthetic $header vs. threshold</td>\n";
    print OUTFILE "  </tr>\n";
    print OUTFILE "</table>\n";
  }
  open(HOUT, ">> $header.html") or die "Couldn't open: $!\n";

  print HOUT "<table class=\"image\">\n";
  print HOUT "  <tr>\n";
  print HOUT "    <td>\n";
  print HOUT "    <a href=\"../plots/$prefix-$header.jpg\">";
  print HOUT "<img src=\"../plots/$prefix-$header.jpg\">";
  print HOUT "</a>\n";
  print HOUT "    </td>\n";
  print HOUT "  </tr>\n";
  print HOUT "</table>\n";

  close HOUT;
}


print OUTFILE "</BODY>\n";
print OUTFILE "</HTML>\n";

close OUTFILE;

open(OUTFILE, "> index.html") or die "Couldn't open: $!\n";
print OUTFILE "<html>\n";
print OUTFILE "<h1>Plots for $prefix</h1>\n";

print OUTFILE "<h2>Cosine plots</h2>\n";

print OUTFILE "<table>\n";
print OUTFILE "  <tr>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/$prefix-cosine-cumulative-loglog.jpg\">";
print OUTFILE "<img src=\"../plots/thumbnail/$prefix-cosine-cumulative-loglog.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/$prefix-synth-cosine-cumulative-loglog.jpg\">";
print OUTFILE "<img src=\"../plots/thumbnail/$prefix-synth-cosine-cumulative-loglog.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "  </tr>\n";
print OUTFILE "  <tr><td>Cumulative cosine distribution loglog</td>\n";
print OUTFILE "  <td>Synthetic cumulative cosine distribution loglog</td></tr>\n";

print OUTFILE "  <tr>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/$prefix-cosine-cumulative.jpg\">\n";
print OUTFILE "<img src=\"../plots/thumbnail/$prefix-cosine-cumulative.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/$prefix-synth-cosine-cumulative.jpg\">\n";
print OUTFILE "<img src=\"../plots/thumbnail/$prefix-synth-cosine-cumulative.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "  </tr>\n";
print OUTFILE "  <tr><td>Cumulative cosine distribution</td>\n";
print OUTFILE "  <td>Synthetic cumulative cosine distribution</td></tr>\n";

print OUTFILE "  <tr>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/$prefix-cosine-hist-loglog.jpg\">\n";
print OUTFILE "<img src=\"../plots/thumbnail/$prefix-cosine-hist-loglog.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/$prefix-synth-cosine-hist-loglog.jpg\">\n";
print OUTFILE "<img src=\"../plots/thumbnail/$prefix-synth-cosine-hist-loglog.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "  </tr>\n";
print OUTFILE "  <tr><td>cosine distribution (loglog)</td>\n";
print OUTFILE "  <td>Synthetic cosine distribution (loglog)</td></tr>\n";


print OUTFILE "  <tr>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/$prefix-cosine-hist.jpg\">\n";
print OUTFILE "<img src=\"../plots/thumbnail/$prefix-cosine-hist.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/$prefix-synth-cosine-hist.jpg\">\n";
print OUTFILE "<img src=\"../plots/thumbnail/$prefix-synth-cosine-hist.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "  </tr>\n";
print OUTFILE "  <tr><td>Cosine distribution</td>\n";
print OUTFILE "  <td>Synthetic cosine distribution</td></tr>\n";

print OUTFILE "  <tr>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/" . $prefix . "_0_0.01_1.jpg\"/>\n";
print OUTFILE "<img src=\"../plots/thumbnail/" . $prefix. "_0_0.01_1.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "    <td>\n";
print OUTFILE "<a href=\"../plots/" . $prefix . "-synth_0_0.01_1.jpg\"/>\n";
print OUTFILE "<img src=\"../plots/thumbnail/" . $prefix. "-synth_0_0.01_1.jpg\" width=\"400\"/></a>\n";
print OUTFILE "    </td>\n";
print OUTFILE "  </tr>\n";
print OUTFILE "  <tr><td>Cosine histogram</td>\n";
print OUTFILE "  <td>Synthetic cosine histogram</td></tr>\n";
print OUTFILE "</table>\n";



print OUTFILE "<h2>Network Plots</h2>\n";

print OUTFILE "<a href=\"$prefix.html\">Network plots</a>\n";
print OUTFILE "</html>\n";
close OUTFILE;


sub usage {
}
