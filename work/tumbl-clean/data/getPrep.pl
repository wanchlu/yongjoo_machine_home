#!/usr/bin/perl

$| = 1;

$input = shift;

@data = split /\n+/, `cat $input`;
foreach $line (@data) {
    ($f1, $f2, $f3, $f4, $f5) = split /\s+/, $line;
    print 
	$f1, " ",
	"$f2\_$f3\_$f4\_$f5", " ",
	"$f2\_$f3\_$f4", " ",
	"$f2\_$f4\_$f5", " ",
	"$f3\_$f4\_$f5", " ",
	"$f2\_$f3\_$f5", " ",
	"$f2\_$f4", " ",
	"$f3\_$f4", " ",
	"$f4\_$f5", " ",
	"$f2\_$f3", " ",
	"$f2\_$f5", " ",
	"$f3\_$f5", " ",
	"$f4", " ",
#	"$f4\n";
	"$f2", " ",
	"$f3", " ",
	"$f5\n";
}
