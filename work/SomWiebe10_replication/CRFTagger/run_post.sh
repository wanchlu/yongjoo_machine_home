for domain in "abortion" "creation" "god" "healthcare" "guns" "gayRights"
do
    echo $domain
java -mx2G -cp ./crftagger.jar crf.tagger.CRFTagger -modeldir ./model -inputdir "/home/wanchen/work/SomWiebe10_replication/posts_sents/$domain"
done
