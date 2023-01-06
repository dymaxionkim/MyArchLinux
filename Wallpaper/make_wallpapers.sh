#!/bin/sh

echo "Input Directory : $1"
echo "Output Directory : $2"

mkdir -p $2
ls $1 > $2/list.txt

while read name; do
	echo $name
    convert $1/$name -filter Gaussian -blur 0x8 -fill black -colorize 20% $2/$name.png
done < $2/list.txt

exit
