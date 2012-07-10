# script: test_parse.t
# functionality: Parses an input file and then runs chunklink on it, confirming
# functionality: the result 

use strict;
use warnings;
use Test::More;
use FindBin;
use Clair::Config;

if ( not defined $CHARNIAK_PATH or not -e $CHARNIAK_PATH or
     not defined $CHARNIAK_DATA_PATH or not -e $CHARNIAK_DATA_PATH or
     not defined $CHUNKLINK_PATH or not -e $CHUNKLINK_PATH ) {

    plan(skip_all => 
        "Charniak variables not defined in Clair::Config or don't exist");

} else {
    plan(tests => 5);
}

use_ok('Clair::Utils::Parse');
use_ok('Clair::Util');

my $file_gen_dir = "$FindBin::Bin/produced/parse";
my $file_exp_dir = "$FindBin::Bin/expected/parse";
my $file_input_dir = "$FindBin::Bin/input/parse";

# Preparing file for parsing
Clair::Utils::Parse::prepare_for_parse("$file_input_dir/test.txt", "$file_gen_dir/parse.txt");
ok(compare_proper_files("parse.txt"), "prepare for parse" );

my $parseout = Clair::Utils::Parse::parse("$file_input_dir/parse.txt", 
    output_file => "$file_gen_dir/parse_out.txt", options => '-l300 -P');
ok(compare_proper_files("parse_out.txt"), "parse" );

my $chunkout = Clair::Utils::Parse::chunklink("$file_input_dir/WSJ_0021.MRG", output_file => "$file_gen_dir/chunk_out.txt");
ok(compare_proper_files("chunk_out.txt"), "chunklink");

# Compares two files named filename
# from the t/docs/expected directory and
# from the t/docs/produced directory
sub compare_proper_files {
	my $filename = shift;
	return Clair::Util::compare_files("$file_exp_dir/$filename", "$file_gen_dir/$filename");
}

