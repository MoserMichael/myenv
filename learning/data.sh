#!/bin/bash 


#### hash in bash ####

declare -A animals

animals=( ["moo"]="cow" ["woof"]="dog")

echo "size of hash ${#animals[@]}"

echo "add another one"
animals["pipi"]="bird"

echo "size of hash ${#animals[@]}"

echo "values: ${animals[@]}"

for f in ${animals[@]}; do
    echo "value: $f"
done

echo "keys:  ${!animals[@]}" 

for f in ${!animals[@]}; do
    echo "key: $f value: ${animals[$f]}"
done


##### array in bash #####
# well, array indexes are not quite continguous, strange...

declare -a arr


arr=('red' 'green' 'blue')


arr[3]='yellow'
arr[5]='gray'

# delete an entry in between
# strange that the array indexes do not remain continguous after deleting an element from in between (more like a hash, somehow)
# i guess that's a feature and not a bug.
unset arr[1]

# access the first value ${arr[0]}
echo "index 0 - ${arr[0]}"
echo "index 1 - ${arr[1]}"
echo "index 2 - ${arr[2]}"

echo "array size: ${#arr[@]}"

for f in ${arr[@]}; do
    echo "array value: $f"
done

for f in ${!arr[@]}; do
    echo "array indexes: $f"
done


