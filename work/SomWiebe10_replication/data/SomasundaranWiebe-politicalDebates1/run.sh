for topic in "abortion" "guns" "god" "gayRights" "healthcare" "creation"
do
    grep "^$topic" aaa >  $topic"_topics.txt"
    grep "originalTopic" $topic"_topics.txt" | cut -d: -f2,3 >a
    grep "originalStance" $topic"_topics.txt" | cut -d: -f2,3 >b
    grep "#stance" $topic"_topics.txt" | cut -d: -f2,3 >c 
    paste a b c|sort |uniq >"topics/$topic.txt"
done
