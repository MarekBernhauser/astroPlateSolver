#!/bin/bash

echo "Target RA"
read targetRA
echo "Target Dec"
read targetDec

mkdir solve
solve-field --no-plots --scale-units degwidth --scale-low 1 --scale-high 2 --downsample 2 -D solve "$1" > solve/out.txt 
echo "solution found"
line=$(grep "RA,Dec =" solve/out.txt)

i=0

while [[ ${line:$i:1} != '(' ]]
do
	((i++))
done
((i++))

RA=${line:$i:7}

while [[ ${line:$i:1} != ',' ]]
do
        ((i++))
done
((i++))

Dec=${line:$i:7}

echo "current RA is" $RA
echo "current dec is" $Dec
echo ""
echo "$targetRA $RA" | awk '{print "RA difference:" $1-$2}'
echo "$Dec $targetDec" | awk '{print "Dec difference:" $1-$2}'

rm -r solve
