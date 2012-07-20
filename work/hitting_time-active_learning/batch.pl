#!/usr/bin/perl -w
use strict;
use IO::Handle;
STDERR->autoflush(1);
STDOUT->autoflush(1);

my $seed_size = 2;
my $test_size = 550;
my $al_size = 50;
my $seed_size_for_normal = $seed_size + $al_size;
my $test_size_for_normal = $test_size - $al_size;

my $iterations = 5;
my $rounds = 20;
my $tag = localtime(time);
$tag =~ s/\W+//g;
foreach my $it (1..$iterations) {
#    print "\n============ Iteration $it =============\n";

#    print "\nActive learning $seed_size + $al_size \n";
    `./1_split_to_seed_and_test.pl ./data/ppattach3.train $seed_size $test_size ./data/A_seeds.txt ./data/A_test.txt`;
    `./2_convert_to_java_input_format.pl ./data/A_seeds.txt ./data/A_test.txt`;
    `java -cp ./HTAL/bin wanchen.HTAL ./data/java_input1.txt ./data/java_input2.txt ./data/java_input3.txt $al_size 1 >> output/$tag-al_$seed_size-$al_size.it$it `;

    #print "\n\n";

    my $s1 = 0;
    foreach my $round (1..$rounds) {
#        print "Normal learing with training size ", $seed_size_for_normal, ", round ", $round, "\n";
        `cat ./data/A_seeds.txt > ./data/B_seeds.txt`;
        `shuffle.pl <./data/A_test.txt > ./data/B_temp`;
        `head -n$al_size ./data/B_temp >> ./data/B_seeds.txt`;
        `head -n -$al_size ./data/B_temp | head -n$test_size_for_normal > ./data/B_test.txt`;
        `./2_convert_to_java_input_format.pl ./data/B_seeds.txt ./data/B_test.txt`;
        my $f1 = `java -cp ./HTAL/bin wanchen.HTAL ./data/java_input1.txt ./data/java_input2.txt ./data/java_input3.txt 0 0`;
        chomp ($f1);
        `echo $f1 >output/$tag-rand_$seed_size_for_normal`;
        $f1 =~ s/.*Accuracy:\s*//g;
        $s1 += $f1;
        if ($round == 0 and $it == 0) {
            `cp ./data/B_seeds.txt ./data/B_test.txt -t "/home/wanchen/work/tumbl-clean/data"`;
            `echo $f1 > /home/wanchen/work/tumbl-clean/hitting_time_$seed_size_for_normal-$test_size_for_normal.txt >> output/$tag-rand_$seed_size_for_normal.it$it`;
        }
    }

    #print " Average of normal learning accuracy : ", $s1/$rounds, "\n";
    my $avg = $s1/$rounds;
    `echo "Average: $avg" >> output/$tag-rand_$seed_size_for_normal.it$it`;

}

