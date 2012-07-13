#!/usr/bin/perl -w
use strict;

my @doclist = `cat doclist.xbankSubset doclist.ulaSubset doclist.ula-luSubset doclist.opqaSubset doclist.mpqaOriginalSubset doclist.attitudeSubset`;

chomp (@doclist);
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
    foreach my $line (@lines) {
        next if ($line =~ m/^#/);
        my @columns = split /\t/, $line;
        my ($start, $end) = split /,/, $columns[1];
        next if ($start == $end);
        my $ann_attr = $columns[3];
        my @properties =();
        @properties = split /\s+/, $columns[4] if ($#columns >= 4);
        if ($ann_attr eq "GATE_direct-subjective" or $ann_attr eq "GATE_expressive-subjectivity" or $ann_attr eq "GATE_attitude") {
            my $intensity = '-';
            my $insubstantial = 0;
            my $polarity = "-";
            my $attitude_type = "-";
            foreach my $prop (@properties) {
                next if $prop eq '';
                my $key = '';
                my $value = '';
                ($key, $value) = split "=", $prop;
                $value =~ s/"//g;
                if ($key eq "intensity") {
                    $intensity = $value;
                }elsif ($key eq "insubstantial") {
                    $insubstantial = 1;
                }elsif ($key eq "polarity") {
                    $polarity = $value;
                }elsif ($key eq "attitude_type") {
                    $attitude_type = $value;
                }
            }

            if ( ($ann_attr eq "GATE_direct-subjective" and $intensity ne "low" and $intensity ne "neutral" and $insubstantial == 0) or ($ann_attr eq "GATE_expressive-subjectivity" and $intensity ne "low") or ($ann_attr eq "GATE_attitude") ){
                my $string = substr($entire_string, $start-1, $end-$start+1);
                print "$ann_attr\t$string\t$intensity\t$polarity\t$attitude_type\n";
            }
        }
    }
}
                    


    

