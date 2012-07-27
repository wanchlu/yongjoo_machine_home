#!/usr/bin/perl -w
use strict;
my $s = 0;
my %hash;
while (1) {
    $hash{localtime(time).rand(3000000)} = $s;
    $s ++;
}
