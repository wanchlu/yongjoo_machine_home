perl "tt.pl" $1 $2 >"out"
cut -d " " -f1 $2 > "$2.label"
let CORRECT=`paste "$2.label" out |grep -P "1\t1|0\t0" |wc -l`
let TOTAL=`cat $2 | wc -l`
echo "scale=4; $CORRECT/$TOTAL" |bc
