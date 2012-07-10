#!/usr/bin/perl

$type = shift;
print "$type\n";

my $date = `date -I`;
chomp $date;

# Create the new perldoc
print "Creating new perldoc documentation.\n";
# my $pl = '$PERLLIB';
# $PERLLIB="$PERLLIB:/data0/projects/pdoc-1.1";
$ENV{PERLLIB}=$ENV{$PERLLIB} . ":/data0/projects/pdoc-live";
`perl /data0/projects/pdoc-live/scripts/perlmod2www.pl -source /data0/projects/clairlib/$date/lib -target /clair/html/$type/pdoc -wroot http://belobog.si.umich.edu/clair/$type/pdoc`;
print "Done creating new perldoc documentation.\n";

