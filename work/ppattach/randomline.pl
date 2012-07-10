#!/usr/bin/perl

srand;
rand($.) < 1 && ($line = $_) while <>;  

print "$line";
