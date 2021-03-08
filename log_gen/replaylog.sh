#!/bin/bash
input=$1
while IFS= read -r line
do
msg=$line
echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  -w 1 -N 127.0.0.1 5140
echo $msg
done < "$input"

