# General names of the files to handle
data_orig="data.csv"
data_copy="data.txt"

# First copy to remove metadata and spaces
cp $data_orig $data_copy
sed '/^#/d' $data_copy -i
sed 's/ //g' $data_copy -i

# Useful variables 
even_nums=0
strange_nums=0
strange_nums1=0
comp=$( echo 'scale=2;sqrt(3)*100/2' | bc)

# First loop on the file
n_lines=$(sed -n '$=' $data_copy)
for i in $(seq $n_lines); do
    for j in {1..6}; do
        a="$(sed -n "${i}p" < $data_copy | cut -d"," -f$j)"

        # Check on the parity of the numbers
        if [[ $(($a%2)) -eq 0 ]]; then
            let even_nums+=1
        fi
    done

    x="$(sed -n "${i}p" < $data_copy | cut -d"," -f1)"
    y="$(sed -n "${i}p" < $data_copy | cut -d"," -f2)"
    z="$(sed -n "${i}p" < $data_copy | cut -d"," -f3)"
    x1="$(sed -n "${i}p" < $data_copy | cut -d"," -f4)"
    y1="$(sed -n "${i}p" < $data_copy | cut -d"," -f5)"
    z1="$(sed -n "${i}p" < $data_copy | cut -d"," -f5)"
    s=$( echo "scale=2;sqrt($x*$x+$y*$y+$z*$z)" | bc )
    s1=$( echo "scale=2;sqrt($x1*$x1+$y1*$y1+$z1*$z1)" | bc )

    # Check on which group they belong to
    if (( $(echo "$s > $comp" |bc -l) )); then
        let strange_nums+=1
    fi

    if (( $(echo "$s1 > $comp" |bc -l) )); then
        let strange_nums1+=1
    fi


done

# Output results
echo "There are $even_nums even numbers"
echo "$strange_nums numbers are bigger than $comp in the XYZ group; in total there are $n_lines triples"
echo "$strange_nums1 numbers are bigger than $comp in the X'Y'Z' group; in total there are $n_lines triples"


if [ -z $1 ]
then
    echo "User input parameter is needed. Abort"
    exit
fi

# Create copies and print the results of the division
for i in $(seq $1); do
    touch $i.txt
    for j in $(seq $n_lines); do
        for k in {1..6}; do
            a="$(sed -n "${j}p" < $data_copy | cut -d"," -f$k)"
            b=$( echo "scale=2;$a/$i" |bc)
            echo -n $b, >>$i.txt
        done
        echo "">>$i.txt
    done

done