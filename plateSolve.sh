#!/bin/bash

echo "Target RA, hh mm ss (eg. 13 40 32)"
read RA
echo "Target Dec, ° ' '' (eg -5 12 34)"
read Dec

ra1=$(echo $RA | cut -f1 -d' ')
ra2=$(echo $RA | cut -f2 -d' ')
ra3=$(echo $RA | cut -f3 -d' ')
targetRA=`echo "scale=4; $ra1*15+$ra2*15/60+$ra3*15/3600" | bc`

dec1=$(echo $Dec | cut -f1 -d' ')
dec2=$(echo $Dec | cut -f2 -d' ')
dec3=$(echo $Dec | cut -f3 -d' ')

if (($dec1 < 0 )) 
then
targetDec=`echo "scale=4; $dec1-$dec2/60-dec3/3600" | bc`
else
targetDec=`echo "scale=4; $dec1+$dec2/60+dec3/3600" | bc`
fi

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
echo "$targetRA $RA" | awk '{print "RA difference:" $1-$2 degrees}'
echo "$Dec $targetDec" | awk '{print "Dec difference:" $1-$2 degrees}'

rm -r solve
