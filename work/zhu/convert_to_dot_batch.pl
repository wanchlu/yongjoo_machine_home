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
    my $resultfile = $file;
    $resultfile =~ s/sim/out/g;
    my $dotfile = $file;
    $dotfile =~ s/sim/dot/g;
    open OUT, ">$dotfile" or die;
    
    my %nodes = ();
    my $trainsize = read_nodefile ($trainfile, \%nodes);
    my $testsize = read_nodefile ($testfile, \%nodes);
    #print $_."\n" foreach(values %nodes);

    my %correct = ();
    check_prediction ($resultfile, \%nodes, \%correct);

    # setting for correct test examples, and for training examples
    print OUT 'Graph G{ 
    node
    [shape=polygon,style=filled,width=.5,height=.06,color="#BDFCC9",fixedsize=true,fontsize=4,
    fontcolor="#2f4f4f"];
    {node
    [color="#ffffe0", fontcolor="#8b7d6b"]'; 
    foreach (1..$trainsize) {
        print OUT " \"$nodes{$_}\"";
    }
    print OUT "}\n";

    # setting for incorrect test examples
    print OUT '{node [color="#fff0f5", fontcolor="#b22222"]';
    foreach (1..$testsize){
        #print STDERR $trainsize+$_," ", $correct{$trainsize+$_} ,"\n";
        print OUT " \"$nodes{$trainsize+$_}\"" if ($correct{$trainsize+$_} == 0);
    }
    print OUT "}\n";

    print OUT 'edge [color="#B0E2FF"];';
    print OUT "\n\n";

    open IN, "$file" or die;
    while (<IN>) {
        chomp;
        my ($n1, $n2, $weight) = split /\s+/, $_; 
        # print "$n1 -- $n2 \n";
        print OUT "\t\"$nodes{$n1}\" -- \"$nodes{$n2}\"";
        if ($weight eq '4') {
            print OUT " [w=\"$weight\", style=bold, color=\"#000080\", len=0.4]";
        } elsif ($weight eq '3') {
            print OUT " [w=\"$weight\", color=\"#0000cd\" , len=0.6]";
        } elsif ($weight eq '2') {
            print OUT " [w=\"$weight\", color=\"#1e90ff\" , len=0.8]"; #style=dashed]";
        } else {
            print OUT " [w=\"$weight\", color=\"#87cefa\" ]"; #style=dotted]";
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
    open IN, "$file" or die "$file: $!\n";
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

sub check_prediction {
    my $file = shift;
    my $nodes_ref = shift;
    my $correct_ref = shift;
    open IN, "$file" or die;
    while (<IN>) {
        chomp;
        my @tokens = split /\s+/, $_;
        my $id = $tokens[0];
        my $pred = $tokens[1];
        my $real_label = substr (${$nodes_ref}{$id}, 0, 1);
        ${$correct_ref}{$id} = 0;
        if ($real_label eq $pred) {
            ${$correct_ref}{$id} = 1;
            #print STDERR $pred," ",${$nodes_ref}{$id},"\n";
        }
    }
}
