#!/bin/bash

now=`date`
echo "$now --------------" >> /php/php/debug.txt

sudo nginx -t > /tmp/npluscheck.tmp 2>&1
if [ $? -eq 0 ]
then
  sudo nginx -s reload
  echo "OK: nginx -s reload" >> /php/php/debug.txt
else
  echo "ERROR: please check the config" >> /php/php/debug.txt
  cat /tmp/npluscheck.tmp >> /php/php/debug.txt
fi

