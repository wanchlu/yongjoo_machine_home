#!/usr/local/bin/perl

# script: test_parse.pl
# functionality: Parses an input file and then runs chunklink on it 

use strict;
use warnings;
use FindBin;
use Clair::Utils::Parse;

my $basedir = $FindBin::Bin;
my $input_dir = "$basedir/input/parse";
my $gen_dir = "$basedir/produced/parse";

# Preparing file for parsing
Clair::Utils::Parse::prepare_for_parse("$input_dir/test.txt", "$gen_dir/parse.txt");

print "PARSING\n";

my $parseout = Clair::Utils::Parse::parse("$gen_dir/parse.txt", output_file => "$gen_dir/parse_out.txt", options => '-l300');

my $chunkin = Clair::Utils::Parse::forcl("$gen_dir/parse_out.txt", output_file => "$gen_dir/WSJ_0000.MRG");

print "Now doing chunklink.\n";

my $chunkout = Clair::Utils::Parse::chunklink("$gen_dir/WSJ_0000.MRG", output_file => "$gen_dir/chunk_out.txt", options => '-sph');

