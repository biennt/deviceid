#!/bin/bash

now=`date`
echo "$now --------------" >> /home/ubuntu/nginx/php/debug.txt

docker exec nplus sh -c "nginx -t" > /tmp/npluscheck.tmp 2>&1
if [ $? -eq 0 ]
then
  docker exec nplus sh -c "nginx -s reload"
  echo "OK: nginx -s reload" >> /home/ubuntu/nginx/php/debug.txt
else
  echo "ERROR: please check the config" >> /home/ubuntu/nginx/php/debug.txt
  cat /tmp/npluscheck.tmp >> /home/ubuntu/nginx/php/debug.txt
fi

