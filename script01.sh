#!/bin/bash

# Variables
dir="students"
download_link=https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv
download_name="students.csv"
pod_file="pod.csv"
phys_file="phy.csv"

# Create directory if not existent
if [[ ! -e ~/$dir ]]; then
	mkdir ~/$dir
	echo "~/$dir created"
elif [[ ! -d ~/$dir ]]; then
	echo "$dir alrerady exists but not a directory"
fi

# Download the file from dropbox
if [[ ! -e ~/$dir/'students.csv' ]]; then
	wget $download_link -O $download_name
	echo "File $download_name not already in $dir, now copying from $(pwd) to $dir/$download_name"
	cp $download_name ~/$dir/$download_name
else
	echo "File $download_name already downloaded"
fi

# Create two different files, separating Physics and Physics of Data students
(cd ~/$dir
grep "P[o,O]D" $download_name > $pod_file
grep "Phys*" $download_name > $phys_file

# Count most frequent letters in PoD file
cnt=0
cont_letter=""

echo "Counting letters in $pod_file"
for i in {A..Z}; do
	counts=$(grep "Family name" -v ~/$dir/$pod_file | cut -d"," -f1| sort | grep "^$i" -c)
	echo "$i -> $counts"
	if [[ $counts -gt $cnt ]]; then
		cnt=$counts
		count_letter=$i
	fi
done 
echo "Most common letter: $count_letter with $cnt occurences"


# Count most frequent letters in Phy file
cnt=0
cont_letter=""

echo "Counting letters in $phys_file"

for i in {A..Z}; do
	counts=$(grep "Family name" -v ~/$dir/$phys_file | cut -d"," -f1| sort | grep "^$i" -c)
	echo "$i -> $counts"
	if [[ $counts -gt $cnt ]]; then
		cnt=$counts
		count_letter=$i
	fi
done 
echo "Most common letter: $count_letter with $cnt occurences"


# Separate students in groups modulo 18 based on their entry number
lines=$(sed -n "$=" $download_name)
for i in $(seq $lines); do
	sed "${i}q;d" $download_name >> $(($i%18)).txt
done

)

# Final clean up of downloaded file
rm $download_name