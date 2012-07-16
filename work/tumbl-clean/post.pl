#!/usr/bin/perl -w
while(<>){
	my @tokens = split /\s+/;
	if ($tokens[1]<$tokens[0] and $tokens[2] == 1){
		print "X ".$_;
	}elsif($tokens[1]>$tokens[0] and  $tokens[2] ==0){
		print "X ".$_;
	}else{
		print $_;
	}
}
