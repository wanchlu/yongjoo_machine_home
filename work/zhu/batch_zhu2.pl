#!/usr/bin/perl

use IO::Handle;

autoflush STDOUT 1;
my $trainfile = shift;
my $testfile = shift;
my $testsize = shift;

`shuffle.pl $testfile | head -n$testsize >$testfile.$testsize`;
$testfile = "$testfile.$testsize";

my $MAXIT = 10;
my $time = localtime(time);
$time =~ s/\W+//g;
$time =~ s/2012//g;

#for my $trainsize (5, 10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 300, 350, 400, 450, 500) {
`mkdir $time`;
#for my $trainsize (2, 4, 6, 8, 10, 12, 14, 16, 18, 20) {
for my $trainsize (1..20) {
    print "Size: $trainsize\n";
    my $v1 = 0;
    for (my $iter = 0; $iter < $MAXIT; $iter++) {
        my $tag = "$time/$iter";
        `mkdir $tag` unless (-d $tag);

        `./data/convert_to_zhu_format.pl $trainfile $trainsize $testfile`;
        my $totalsize = $trainsize + $testsize;

        my $f1 = `./zhu -graph $trainfile.$trainsize.sim -trainlabels $trainfile.$trainsize.labels -testlabels $testfile.labels -out zhu.out -classes 2`;

        chomp($f1);

        $f1 =~ m/.*:\s+(.*)$/;
        $v1 += $1;

        print "$f1\n";
        `cp $trainfile.$trainsize.sim $tag/$trainsize.sim`;
        `mv zhu.out $tag/$trainsize.out`;
        `echo "$f1" > $tag/$trainsize.acc`;
        `cp $trainfile.$trainsize.shuffle $tag/$trainsize.train`;
        `cp $testfile $tag/test`;
    }

    print "\n averages: ";
    print $v1 / $MAXIT, "\n";

    print "\n";
    #sleep (1);
}

`rm -fr ./data/zhu/subset/*shuffle ./data/zhu/subset/*labels ./data/zhu/subset/*sim ./data/zhu/subset/*devtt\.*`;
