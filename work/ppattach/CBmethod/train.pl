#!/usr/bin/perl _w
use strict;

dbmopen(my %db_1_v_n1_p_n2, "db_1_v_n1_p_n2", 0664) or die "Cannot open db: $!";
dbmopen(my %db_v_n1_p_n2, "db_v_n1_p_n2", 0664) or die "Cannot open db: $!";
dbmopen(my %db_1_v_n1_p, "db_1_v_n1_p", 0664) or die "Cannot open db: $!";
dbmopen(my %db_v_n1_p, "db_v_n1_p", 0664) or die "Cannot open db: $!";
dbmopen(my %db_1_v_p_n2, "db_1_v_p_n2", 0664) or die "Cannot open db: $!";
dbmopen(my %db_v_p_n2, "db_v_p_n2", 0664) or die "Cannot open db: $!";
dbmopen(my %db_1_n1_p_n2, "db_1_n1_p_n2", 0664) or die "Cannot open db: $!";
dbmopen(my %db_n1_p_n2, "db_n1_p_n2", 0664) or die "Cannot open db: $!";
dbmopen(my %db_1_v_p, "db_1_v_p", 0664) or die "Cannot open db: $!";
dbmopen(my %db_v_p, "db_v_p", 0664) or die "Cannot open db: $!";
dbmopen(my %db_1_n1_p, "db_1_n1_p", 0664) or die "Cannot open db: $!";
dbmopen(my %db_n1_p, "db_n1_p", 0664) or die "Cannot open db: $!";
dbmopen(my %db_1_p_n2, "db_1_p_n2", 0664) or die "Cannot open db: $!";
dbmopen(my %db_p_n2, "db_p_n2", 0664) or die "Cannot open db: $!";
dbmopen(my %db_1_p, "db_1_p", 0664) or die "Cannot open db: $!";
dbmopen(my %db_p, "db_p", 0664) or die "Cannot open db: $!";


open IN, "ppattach3.train" or die "$!\n";
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
	
	$db_v_n1_p_n2{"$v $n1 $p $n2"} ++;
	$db_v_n1_p{"$v $n1 $p"} ++;
	$db_v_p_n2{"$v $p $n2"} ++;
	$db_n1_p_n2{"$n1 $p $n2"} ++;
	$db_v_p{"$v $p"} ++;
	$db_n1_p{"$n1 $p"} ++;
	$db_p_n2{"$p $n2"} ++;
	$db_p{"$p"} ++;

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
