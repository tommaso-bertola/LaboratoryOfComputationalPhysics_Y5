#!/bin/bash

dir="students"
if [[ ! -e ~/$dir ]]; then
	mkdir ~/$dir
elif [[ ! -d ~/$dir ]]; then
	echo "$dir alrerady exists but not a directory"
fi

download_link=https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv
download_name="students.csv"

if [[ ! -e ~/$dir/'students.csv' ]]; then
	wget $download_link -O $download_name
	echo 'File $download_name not already in $dir, now copying to $dir/$download_name'
	cp $download_name ~/$dir/$download_name
fi

cd ~/$dir
grep "P[o,O]D" $download_name > pod.csv
grep "Phys*" $download_name >phy.csv

cnt=0
cont_letter=""

for i in {A..Z}; do
	counts=$(grep "Family name" -v ~/$dir/$download_name | cut -d"," -f1| sort| grep "^$i" -c)
	echo "$i -> $counts"
	if [[ $counts -gt $cnt ]]; then
		cnt=$counts
		count_letter=$i
	fi
done 

echo "Most common letter: $count_letter with $cnt occurences"
