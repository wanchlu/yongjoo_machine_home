#!/usr/bin/perl 
use strict;

my @doclist = `cat doclist.xbankSubset doclist.ulaSubset doclist.ula-luSubset doclist.opqaSubset doclist.mpqaOriginalSubset `;

chomp (@doclist);
open OUT, ">data/attitude.txt";
foreach my $doc (@doclist) {
    my $textfile = "docs/$doc";
    my $annfile = "man_anns/$doc/gateman.mpqa.lre.2.0";
    open IN, "$textfile" or die;
    local $/=undef;
    my $entire_string = <IN>;
#    print "processing $doc...\n";
#    print length($entire_string)."\n";
    #   print substr($entire_string, length($entire_string)-4, length($entire_string)-1);
    #print $entire_string."\n";
    close IN;
    open IN, "$annfile" or die;
    local $/="\n";
    my @lines = <IN>;
    chomp (@lines);
    my %annotated = {}; # record which word is added by $start
    foreach my $line (@lines) {
        next if ($line =~ m/^#/);
        my @columns = split /\t/, $line;
        my ($start, $end) = split /,/, $columns[1];
        next if ($start == $end);
        my $ann_attr = $columns[3];
        my @properties =();
        @properties = split /\s+/, $columns[4] if ($#columns >= 4);

        if ( $ann_attr eq "GATE_attitude") {
            next if exists $annotated{$start};
            $annotated{$start} = 1;
            my $intensity = '-';
            my $insubstantial = 0;
            my $polarity = "-";
            my $attitude_type = "-";
            foreach my $prop (@properties) {
                next if not defined ($prop);
                my $key = '';
                my $value = '';
                ($key, $value) = split "=", $prop;
                $value =~ s/"//g;
                next if not defined($value);
                if ($key eq "intensity") {
                    $intensity = $value;
                }elsif ($key eq "insubstantial") {
                    $insubstantial = 1;
                }elsif ($key eq "polarity") {
                    $polarity = $value;
                }elsif ($key eq "attitude-type") {
                    $attitude_type = $value;
                }
            }

#            if ( ($ann_attr eq "GATE_direct-subjective" and $intensity ne "low" and $intensity ne "neutral" and $insubstantial == 0) or ($ann_attr eq "GATE_expressive-subjectivity" and $intensity ne "low") or ($ann_attr eq "GATE_attitude") ){
            my $string = substr($entire_string, $start, $end-$start);
            $string =~ s/\s+/ /g;
            
            print OUT "$ann_attr\t$string\t$intensity\t$polarity\t$attitude_type\n";
        }
    }
}


close OUT;



