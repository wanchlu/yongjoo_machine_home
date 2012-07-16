#!/usr/bin/perl -w
use strict;
my @list = `ls /home/wanchen/work/SomWiebe10_replication/posts_sents/abortion/*`;
chomp (@list);
my $long = join " ", @list;
print `./lexparser.sh $long `; 
