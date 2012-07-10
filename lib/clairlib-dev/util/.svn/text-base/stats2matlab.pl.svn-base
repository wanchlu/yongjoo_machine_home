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

my $res = GetOptions("input=s" => \$infile, "output=s" => \$outfile);

if (!$res or ($infile eq "") or ($outfile eq "")) {
  usage();
  exit;
}

my ($vol, $dir, $prefix) = File::Spec->splitpath($outfile);
$prefix =~ s/\.m//;

if ($dir ne "") {
  unless (-d $dir) {
    mkdir $dir or die "Couldn't create $dir: $!";
  }
}

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

foreach my $col (keys %headers) {
        print OUTFILE $headers{$col}, " = [\n";
        print OUTFILE join("\n", @{$data[$col]});
        print OUTFILE "];\n";
}
print OUTFILE "\n";

foreach my $col (keys %headers) {
  my $header = $headers{$col};
  if ($header ne "threshold") {
    my $text = $header;
    $text =~ s/_/\\_/g;
    print OUTFILE "plot(threshold, $header);\n";
    print OUTFILE "title(['$text vs. threshold ($prefix)']);\n";
    print OUTFILE "h = get(gca, 'title');\n";
    print OUTFILE "set(h, 'FontSize', 16);\n";
    print OUTFILE "xlabel('threshold');\n";
    print OUTFILE "h = get(gca, 'xlabel');\n";
    print OUTFILE "set(h, 'FontSize', 16);\n";
    print OUTFILE "ylabel('$text');\n";
    print OUTFILE "h = get(gca, 'ylabel');\n";
    print OUTFILE "set(h, 'FontSize', 16);\n";
    print OUTFILE "print('-deps', '$prefix-$header.eps');\n";
    print OUTFILE "print('-djpeg90', '-r50', '$prefix-$header.jpg');\n";
    print OUTFILE "\n\n";

    print OUTFILE "loglog(threshold, $header);\n";
    print OUTFILE "title(['$text vs. threshold ($prefix)']);\n";
    print OUTFILE "h = get(gca, 'title');\n";
    print OUTFILE "set(h, 'FontSize', 16);\n";
    print OUTFILE "xlabel('threshold');\n";
    print OUTFILE "h = get(gca, 'xlabel');\n";
    print OUTFILE "set(h, 'FontSize', 16);\n";
    print OUTFILE "ylabel('$text');\n";
    print OUTFILE "h = get(gca, 'ylabel');\n";
    print OUTFILE "set(h, 'FontSize', 16);\n";
    print OUTFILE "print('-deps', '$prefix-$header-loglog.eps');\n";
    print OUTFILE "print('-djpeg90', '-r50', '$prefix-$header-loglog.jpg');\n";
    print OUTFILE "\n";
  }
}

close OUTFILE;


sub usage {
}
