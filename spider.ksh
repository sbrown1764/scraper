#!/bin/ksh


id=$1
url=$2
keywordList=words.txt
> match-words.txt

# Grab home page links
curl -q $2 > curl.out
cat curl.out | grep -o -E 'href="([^"#]+)"' | cut -d'"' -f2 | sort | uniq > current.urls

wordsCount=`awk 'END {print NR}' words.txt`
c=1
while [[ c -le wordsCount ]]
do 
 i=`head -$c words.txt|tail -1`
	if grep -i "$i" curl.out > /dev/null
	then
		echo $1,$2,$i >> match-words.txt
	fi
  #$c=$((c++))
let c=$((c+1))
#echo $c,$i
done

currentCount=`awk 'END {print NR}' current.urls`

echo $1,$2,$currentCount


### Check each second level link for matches ###
for j in `cat current.urls  |grep http`
do
	curl $j > curl.out

	c=1
	while [[ c -le wordsCount ]]
	do
	 i=`head -$c words.txt|tail -1`
        if grep -i "$i" curl.out > /dev/null
        then
                echo $1,$j,$i >> match-words.txt
        fi
	let c=$((c+1))
	done
done

cat match-words.txt| sort |uniq

## Put these into a word cloud?
