#!/usr/local/bin/perl

# script: test_statistics.pl
# functionality: Tests linear regression and T test code 

use strict;
use warnings;

use Clair::Network;
use Clair::Statistics::Distributions::TDist;

my %hist = (1, 2, 2, 4, 3, 6, 4, 9, 5, 11, 6, 12, 7, 14, 8, 16, 9, 18,
            10, 20, 11, 22
           );
my %bee = (   101.6 => 37,
              240.4 => 39.7,
              180.9 => 40.5,
              390.2 => 42.6,
              360.3 => 42.0,
              120.8 => 39.1,
              180.5 => 40.2,
              330.7 => 37.8,
              395.4 => 43.1,
              194.1 => 40.2,
              135.2 => 38.8,
              210.0 => 41.9,
              240.6 => 39.0,
              145.7 => 39.0,
              168.3 => 38.1,
              192.8 => 40.2,
              305.2 => 43.1,
              378.0 => 39.9,
              165.9 => 39.6,
              303.1 => 40.8
            );



my $net = Clair::Network->new();

my ($coef, $r) = $net->linear_regression(\%bee);

my $n = scalar keys %bee;
my $r_squared = $r**2;

my $df = $n - 2;
my $sr = sqrt((1 - $r_squared) / $df);
my $t = $r / $sr;
my $tdist = Clair::Statistics::Distributions::TDist->new();
my $t_prob = $tdist->get_prob($df, $t) * 2;

print "t_prob: $t_prob\n";

if ($t_prob < 0.05) {
  print "Likely power law relationship (p < 0.05)\n";
}

