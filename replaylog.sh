#!/bin/bash
input=$1
while IFS= read -r line
do
msg=$line
echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  127.0.0.1 5140
echo $msg
done < "$input"

