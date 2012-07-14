#!/usr/bin/perl -w 
use strict;
#use Clair::Document;
use Lingua::EN::Sentence qw( get_sentences add_acronyms );
add_acronyms('et al');
add_acronyms('eq', 'vs');

local $/ = undef;
my $input_file = <>;

my $sents = get_sentences($input_file);
foreach (@{$sents}) {
    print "$_\n";
}
