#!/usr/bin/perl -w
use strict;

my $dir = shift;

my @simfiles = `ls $dir/*/*sim`;
chomp(@simfiles);

foreach my $file (@simfiles) {
    my $trainfile = $file;
    $trainfile =~ s/sim/train/g;
    my $testfile = $file;
    $testfile =~ s#\/\d+\.sim$#\/test#g;
    my $dotfile = $file;
    $dotfile =~ s/sim/dott/g;
    open OUT, ">$dotfile" or die;
    
    my %nodes = ();
    my $trainsize = read_nodefile ($trainfile, \%nodes);
    my $testsize = read_nodefile ($testfile, \%nodes);
    #print $_."\n" foreach(values %nodes);

    print OUT 'Graph G{ 
    node
    [shape=polygon,style=filled,width=.5,height=.06,color="#f0fff0",fixedsize=true,fontsize=4,
    fontcolor="#2f4f4f"];
    {node
    [color="#fff0f5", fontcolor="#b22222"]'; 
    foreach (1..$trainsize) {
        print OUT " \"$nodes{$_}\"";
    }
    print OUT "}\n";
    print OUT 'edge [color="#1e90ff"];';
    print OUT "\n\n";

    open IN, "$file" or die;
    while (<IN>) {
        chomp;
        my ($n1, $n2, $weight) = split /\s+/, $_; 
        # print "$n1 -- $n2 \n";
        print OUT "\t\"$nodes{$n1}\" -- \"$nodes{$n2}\"";
        if (int($weight) ne 1) {
            my $len = sprintf '%.3f', 1/int($weight);
            $len =~ s/0+$//g;
            print OUT " [w=\"$weight\", len=$len]";
        }
        print OUT ";\n";

    }
    print OUT "}";
    close OUT;

}

sub read_nodefile {
    my $count = 0;
    my $file = shift;
    my $nodes_ref = shift;
    my @keys = keys %{$nodes_ref};
    my $idx = $#keys + 1;
    open IN, "$file" or die;
    my @lines = <IN>;
    chomp(@lines);
    foreach my $line(@lines) {
        $line =~ s/\s+x(02|01|0|11)_/_/g;
        $idx ++;
        ${$nodes_ref}{$idx} = $line;
        $count ++;
    }
    return $count;
}
