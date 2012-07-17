#!/usr/bin/perl -w

use Getopt::Long;
my $dir = shift;

$dir =~ s/\..*//g;

#die "$dir exists!\n" if (-d $dir);
`mkdir -p $dir`;

`./data/convert_to_tumbl_detailed_format.pl ./data/B_seeds.txt 99999 ./data/B_test.txt 99999`;
`mv feature_names.txt $dir/feature_names.txt`;
`cut -f1,2 -d" " ./data/B_seeds.txt.shuffle >$dir/labeled_instances`;
`cut -f1,2 -d" " ./data/B_test.txt.shuffle >$dir/unlabeled_instances`;
`mv ./data/B_seeds.txt.edges $dir/labeled.edges`;
`mv ./data/B_test.txt.edges $dir/unlabeled.edges`;


print `./tumbl_detailed-output -featurenames $dir/feature_names.txt  -fromedges $dir/unlabeled.edges -toedges $dir/labeled.edges  -testlabels $dir/unlabeled_instances -trainlabels $dir/labeled_instances -out $dir/out.txt -d 1.0`;
`paste $dir/out.txt $dir/unlabeled_instances | ./post.pl >$dir/out.long`;
`rm -fr $dir/detailed_output` if (-d "$dir/detailed_output");
`mv -fi detailed_output $dir`;

