#!/usr/bin/perl

# This script asks the user for the path to the clairlib/tests/ directory
# that contains the directories t/, test/, and util/, that is used to store
# the test files served by the webserver.  Currently this is known to be
# /data2/html/clairlib/tests/, but for the sake of testing and possible future
# changes, it is asked for.

# This script deletes all the files in the clairlib/tests/{t,test,util}/
# directories, and moves and renames the .t and .pl files in ../{t,test,util}/
# there.  All files end up with names such as filename.t.txt or filename.txt,
# as files that have .pl in their names can't be linked to as text files
# successfully.

use strict;
use warnings;

print "\nPlease read move_tests_to_website.README before executing this script.\n". 
"If you have not yet read that, enter anything but 'y' to exit.\n".
"[n]:";
my $input = <STDIN>;
chomp $input;
unless ($input eq "y") {
  exit;
}

print "\nProvide the path to the clairlib/tests/ directory being served by our webserver:\n".
"[/data2/html/clairlib/tests/]:";
$input = <STDIN>;
chomp $input;
if ($input eq "") {
  $input = "/data2/html/clairlib/tests/";
}
my $destination = $input;

# Remove any existing files from the destination:
`rm ${destination}/t/*.txt`;
`rm ${destination}/test/*.txt`;
`rm ${destination}/util/*.txt`;


my $glob = "test_*.t";
while (<../t/$glob>) {
  my $filepath = $_;
  
  # Remove the "../t/" from the filepath to get just the name.
  s/..\/t\///;
  my $filename = $_;

  `cp $filepath ${destination}/t/`;
  `mv ${destination}/t/$filename ${destination}/t/${filename}.txt`;
}
print "Moved ../t/test_*.t files.\n";

$glob = "*.pl";
while (<../test/$glob>) {
  my $filepath = $_;
  
  # Remove the "../test/" from the filepath to get just the name.
  s/..\/test\///;
  my $filename = $_;

  # Remove the ".pl" from the filename for renaming.
  s/\.pl//;
  my $basefilename = $_;

  `cp $filepath ${destination}/test/`;
  `mv ${destination}/test/$filename ${destination}/test/${basefilename}.txt`;
}
print "Moved ../test/*.pl files.\n";

while (<../util/$glob>) {
  my $filepath = $_;
  
  # Remove the "../util/" from the filepath to get just the name.
  s/..\/util\///;
  my $filename = $_;

  # Remove the ".pl" from the filename for renaming.
  s/\.pl//;
  my $basefilename = $_;

  `cp $filepath ${destination}/util/`;
  `mv ${destination}/util/$filename ${destination}/util/${basefilename}.txt`;
}
print "Moved ../util/*.pl files.\n";
