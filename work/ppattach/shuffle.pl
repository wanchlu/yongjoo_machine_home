#!/usr/bin/perl -w

use strict;

my @array;

while (<>) {
    chomp;
    push @array, $_;
}

&fisher_yates_shuffle( \@array );

for (@array) {
    print "$_\n";
}

sub fisher_yates_shuffle {
    my $array = shift;
    my $i;
    for ($i = @$array; --$i; ) {
        my $j = int rand ($i+1);
        next if $i == $j;
        @$array[$i,$j] = @$array[$j,$i];
    }
}

