#!/usr/bin/perl -w

use Getopt::Long;
my $dir = '';
my $trainsize = 0;
my $testsize = 0;

GetOptions ("name=s" =>\$dir, "trainsize=i" =>\$trainsize, "testsize=i" =>\$testsize);
die "argument error\n" if $dir eq '' or $trainsize == 0 or $testsize == 0;
#die "$dir exists!\n" if (-d $dir);
`mkdir -p $dir`;

`./data/convert_to_tumbl_detailed_format.pl ./data/A.train $trainsize ./data/A.devtt $testsize`;
`mv feature_names.txt $dir/feature_names.txt`;
`cut -f1,2 -d" " ./data/A.train.shuffle >$dir/labeled_instances.$trainsize`;
`cut -f1,2 -d" " ./data/A.devtt.shuffle >$dir/unlabeled_instances.$testsize`;
`mv ./data/A.train.edges $dir/labeled.edges`;
`mv ./data/A.devtt.edges $dir/unlabeled.edges`;


print `./tumbl_detailed-output -featurenames $dir/feature_names.txt  -fromedges $dir/unlabeled.edges -toedges $dir/labeled.edges  -testlabels $dir/unlabeled_instances.$testsize -trainlabels $dir/labeled_instances.$trainsize  -out $dir/out.txt -d 0.9`;
`paste $dir/out.txt $dir/unlabeled_instances.$testsize | ./post.pl >$dir/out.long`;
`rm -fr $dir/detailed_output` if (-d "$dir/detailed_output");
`mv -fi detailed_output $dir`;

