#!/usr/bin/perl _w
use strict;

my %db_1_v_n1_p_n2;
my %db_v_n1_p_n2;
my %db_1_v_n1_p;
my %db_v_n1_p;
my %db_1_v_p_n2;
my %db_v_p_n2;
my %db_1_n1_p_n2;
my %db_n1_p_n2;
my %db_1_v_p;
my %db_v_p;
my %db_1_n1_p;
my %db_n1_p;
my %db_1_p_n2;
my %db_p_n2;
my %db_1_p;
my %db_p;


my $trainfile = shift;
open IN, "$trainfile" or die "$!\n";
while(<IN>){
	chomp;
	my ($n_attach, $v, $n1, $p, $n2) = split /\s+/, $_;
#	warn "warning: $v\n" unless ($v =~ s/x02_//g);
#	warn "warning: $n1\n" unless ($n1 =~ s/x01_//g);
#	warn "warning: $p\n" unless ($p =~ s/x0_//g);
#	warn "warning: $n2\n" unless ($n2 =~ s/x11_//g);
#warn "$v $n1 $p $n2\n";# if ($v.$n1.$p.$n2 =~ /\s+/);	
	$db_1_v_n1_p_n2{"$v $n1 $p $n2"} = 0 if not exists $db_1_v_n1_p_n2{"$v $n1 $p $n2"};
	$db_1_v_n1_p{"$v $n1 $p"} = 0 if not exists $db_1_v_n1_p{"$v $n1 $p"};
	$db_1_v_p_n2{"$v $p $n2"} = 0 if not exists $db_1_v_p_n2{"$v $p $n2"};
	$db_1_n1_p_n2{"$n1 $p $n2"} = 0 if not exists $db_1_n1_p_n2{"$n1 $p $n2"};
	$db_1_v_p{"$v $p"} = 0 if not exists $db_1_v_p{"$v $p"};
	$db_1_n1_p{"$n1 $p"} = 0 if not exists $db_1_n1_p{"$n1 $p"};
	$db_1_p_n2{"$p $n2"} = 0 if not exists $db_1_p_n2{"$p $n2"};
	$db_1_p{"$p"} = 0 if not exists $db_1_p{"$p"};

	$db_v_n1_p_n2{"$v $n1 $p $n2"} = 0 if not exists $db_v_n1_p_n2{"$v $n1 $p $n2"};
	$db_v_n1_p{"$v $n1 $p"} = 0 if not exists $db_v_n1_p{"$v $n1 $p"};
	$db_v_p_n2{"$v $p $n2"} = 0 if not exists $db_v_p_n2{"$v $p $n2"};
	$db_n1_p_n2{"$n1 $p $n2"} = 0 if not exists $db_n1_p_n2{"$n1 $p $n2"};
	$db_v_p{"$v $p"} = 0 if not exists $db_v_p{"$v $p"};
	$db_n1_p{"$n1 $p"} = 0 if not exists $db_n1_p{"$n1 $p"};
	$db_p_n2{"$p $n2"} = 0 if not exists $db_p_n2{"$p $n2"};
	$db_p{"$p"} = 0 if not exists $db_p{"$p"};

	if ($n_attach == 1)
	{
		$db_1_v_n1_p_n2{"$v $n1 $p $n2"} ++;
		$db_1_v_n1_p{"$v $n1 $p"} ++;
		$db_1_v_p_n2{"$v $p $n2"} ++;
		$db_1_n1_p_n2{"$n1 $p $n2"} ++;
		$db_1_v_p{"$v $p"} ++;
		$db_1_n1_p{"$n1 $p"} ++;
		$db_1_p_n2{"$p $n2"} ++;
		$db_1_p{"$p"} ++;
	
	}
if ($n_attach != 1 and $n_attach != 0) {warn "warning:777\n";}
	
	$db_v_n1_p_n2{"$v $n1 $p $n2"} ++;
	$db_v_n1_p{"$v $n1 $p"} ++;
	$db_v_p_n2{"$v $p $n2"} ++;
	$db_n1_p_n2{"$n1 $p $n2"} ++;
	$db_v_p{"$v $p"} ++;
	$db_n1_p{"$n1 $p"} ++;
	$db_p_n2{"$p $n2"} ++;
	$db_p{"$p"} ++;

}

my $testfile= shift;

open IN, "$testfile" or die "$!\n";
while(<IN>){
	chomp;
	my ($n_attach, $v, $n1, $p, $n2) = split /\s+/, $_;
	my $str = join " ", ($v, $n1, $p, $n2);
	#warn "warning: $v\n" unless ($v =~ s/x02_//g);
	#warn "warning: $n1\n" unless ($n1 =~ s/x01_//g);
	#warn "warning: $p\n" unless ($p =~ s/x0_//g);
	#warn "warning: $n2\n" unless ($n2 =~ s/x11_//g);
	
	my $p_hat;
	my $f_1_v_n1_p_n2;
	my $f_1_v_n1_p;
	my $f_1_v_p_n2;
	my $f_1_n1_p_n2;
	my $f_1_v_p;
	my $f_1_n1_p;
	my $f_1_p_n2;
	my $f_1_p;
	
	my $f_v_n1_p_n2;
	my $f_v_n1_p;
	my $f_v_p_n2;
	my $f_n1_p_n2;
	my $f_v_p;
	my $f_n1_p;
	my $f_p_n2;
	my $f_p;
	
	$f_1_v_n1_p_n2 = $db_1_v_n1_p_n2{"$v $n1 $p $n2"} if exists $db_1_v_n1_p_n2{"$v $n1 $p $n2"};
	$f_1_v_n1_p = $db_1_v_n1_p{"$v $n1 $p"} if exists $db_1_v_n1_p{"$v $n1 $p"};
	$f_1_v_p_n2 = $db_1_v_p_n2{"$v $p $n2"} if exists $db_1_v_p_n2{"$v $p $n2"};
	$f_1_n1_p_n2 = $db_1_n1_p_n2{"$n1 $p $n2"} if exists $db_1_n1_p_n2{"$n1 $p $n2"};
	$f_1_v_p = $db_1_v_p{"$v $p"} if exists $db_1_v_p{"$v $p"};
	$f_1_n1_p = $db_1_n1_p{"$n1 $p"} if exists $db_1_n1_p{"$n1 $p"};
	$f_1_p_n2 = $db_1_p_n2{"$p $n2"} if exists $db_1_p_n2{"$p $n2"};
	$f_1_p = $db_1_p{"$p"} if exists $db_1_p{"$p"};
		
	$f_1_v_n1_p_n2 = 0 if not exists $db_1_v_n1_p_n2{"$v $n1 $p $n2"};
	$f_1_v_n1_p = 0 if not exists $db_1_v_n1_p{"$v $n1 $p"};
	$f_1_v_p_n2 = 0 if not exists $db_1_v_p_n2{"$v $p $n2"};
	$f_1_n1_p_n2 = 0 if not exists $db_1_n1_p_n2{"$n1 $p $n2"};
	$f_1_v_p = 0 if not exists $db_1_v_p{"$v $p"};
	$f_1_n1_p = 0 if not exists $db_1_n1_p{"$n1 $p"};
	$f_1_p_n2 = 0 if not exists $db_1_p_n2{"$p $n2"};
	$f_1_p = 0 if not exists $db_1_p{"$p"};
	
	$f_v_n1_p_n2 = $db_v_n1_p_n2{"$v $n1 $p $n2"} if exists $db_v_n1_p_n2{"$v $n1 $p $n2"};
	$f_v_n1_p = $db_v_n1_p{"$v $n1 $p"} if exists $db_v_n1_p{"$v $n1 $p"};
	$f_v_p_n2 = $db_v_p_n2{"$v $p $n2"} if exists $db_v_p_n2{"$v $p $n2"};
	$f_n1_p_n2 = $db_n1_p_n2{"$n1 $p $n2"} if exists $db_n1_p_n2{"$n1 $p $n2"};
	$f_v_p = $db_v_p{"$v $p"} if exists $db_v_p{"$v $p"};
	$f_n1_p = $db_n1_p{"$n1 $p"} if exists $db_n1_p{"$n1 $p"};
	$f_p_n2 = $db_p_n2{"$p $n2"} if exists $db_p_n2{"$p $n2"};
	$f_p = $db_p{"$p"} if exists $db_p{"$p"};

	$f_v_n1_p_n2 = 0 if not exists $db_v_n1_p_n2{"$v $n1 $p $n2"};
	$f_v_n1_p = 0 if not exists $db_v_n1_p{"$v $n1 $p"};
	$f_v_p_n2 = 0 if not exists $db_v_p_n2{"$v $p $n2"};
	$f_n1_p_n2 = 0 if not exists $db_n1_p_n2{"$n1 $p $n2"};
	$f_v_p = 0 if not exists $db_v_p{"$v $p"};
	$f_n1_p = 0 if not exists $db_n1_p{"$n1 $p"};
	$f_p_n2 = 0 if not exists $db_p_n2{"$p $n2"};
	$f_p = 0 if not exists $db_p{"$p"};

	if ($f_v_n1_p_n2 > 0 and  ($f_1_v_n1_p_n2/$f_v_n1_p_n2) != 0.5){
#	if ($f_v_n1_p_n2 > 0){
		$p_hat = $f_1_v_n1_p_n2/$f_v_n1_p_n2;
#print "Q\t";
	}
	elsif ( ($f_v_n1_p + $f_v_p_n2 + $f_n1_p_n2)> 0 and ($f_1_v_n1_p + $f_1_v_p_n2 + $f_1_n1_p_n2)/($f_v_n1_p + $f_v_p_n2 + $f_n1_p_n2) != 0.5){
	#elsif ( ($f_v_n1_p + $f_v_p_n2 + $f_n1_p_n2)> 0 and ($f_v_n1_p_n2 == 0)){
#print "T\t";
		$p_hat = ($f_1_v_n1_p + $f_1_v_p_n2 + $f_1_n1_p_n2 )/($f_v_n1_p + $f_v_p_n2 + $f_n1_p_n2);
	}
	elsif ($f_v_p + $f_n1_p +$f_p_n2 > 0){
#print "D\t";
		$p_hat = ($f_1_v_p + $f_1_n1_p +$f_1_p_n2)/($f_v_p + $f_n1_p +$f_p_n2);
	}
	elsif ($f_p > 0){
#print "S\t";
		$p_hat = $f_1_p/$f_p;
	}
	else{
		$p_hat = 1;
#print "F\t";
	}
	my $pred = ($p_hat >= 0.5)? 1:0;
#	print "$pred $str\n";
	print "$pred $str\n";
}

dbmclose %db_v_n1_p_n2;
dbmclose %db_v_n1_p;
dbmclose %db_v_p_n2;
dbmclose %db_n1_p_n2;
dbmclose %db_v_p;
dbmclose %db_n1_p;
dbmclose %db_p_n2;
dbmclose %db_p;

dbmclose %db_1_v_n1_p_n2;
dbmclose %db_1_v_n1_p;
dbmclose %db_1_v_p_n2;
dbmclose %db_1_n1_p_n2;
dbmclose %db_1_v_p;
dbmclose %db_1_n1_p;
dbmclose %db_1_p_n2;
dbmclose %db_1_p;
