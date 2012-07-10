#! /bin/bash

cd /data0/projects/clairlib-dev/test/
testfiles=`ls *.pl`
cd /data0/projects/clairlib-dev/t/
tfiles=`ls *.t`
cd /data0/projects/clairlib-dev/util/
utilfiles=`ls *.pl`

rm /data0/projects/clairlib-dev/tutorial/core_test_filelist.txt
rm /data0/projects/clairlib-dev/tutorial/core_t_filelist.txt
rm /data0/projects/clairlib-dev/tutorial/core_util_filelist.txt

for i in $testfiles
do
echo $i >> /data0/projects/clairlib-dev/tutorial/core_test_filelist.txt

done

for i in $tfiles
do
echo $i >> /data0/projects/clairlib-dev/tutorial/core_t_filelist.txt
done

for i in $utilfiles
do
echo $i >> /data0/projects/clairlib-dev/tutorial/core_util_filelist.txt
done
