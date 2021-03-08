#!/bin/bash

uNamearray[0]='bien'
uNamearray[1]='edwin'
uNamearray[2]='michaelcheo'
uNamearray[3]='marcel'
uNamearray[4]='andre'
uNamearray[5]='chin'
uNamearray[6]='cloe'
uNamearray[7]='francois'
uNamearray[8]='honghua'
uNamearray[9]='halim'
sizeuName=${#uNamearray[@]}

authcodearray[0]='1'
authcodearray[1]='2'
authcodesize=${#authcodearray[@]}

virtualname='ebook'
clientip='172.31.9.60'
fqdn='ebook.seemedemo.com'
method='GET' # default
ua='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0'
uri='/login.do'

diA='AaZHN2BBBBBBjAY3fLSqDLPwzInc2Ogn'
diB='AS5q4jNm2lKg4SXCyJRF0AQ8vTwCq6aI'

while true
do
  echo "----------"
  uNameIndex=$((RANDOM % $sizeuName))
  RANUSERID=${uNamearray[$uNameIndex]}
  SESSID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 18 | head -n 1)

  # randomize authentication result code
  authcodeindex=$(($RANDOM % $authcodesize))
  authcode=${authcodearray[$authcodeindex]}

  if [ "$authcode" = "2" ]; then
    status_code="200"
  else
    status_code="302"
  fi

# login process
 epochtime=`date +%s%N | cut -b1-13`
  msg="<190>#$epochtime#$RANUSERID#$virtualname#$clientip#12345#$clientip#192.168.100.10:8083#$fqdn#POST#$uri#$status_code#na#0#$diA#$diB#$ua#$authcode#$SESSID#"
  echo $msg
  echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  -w 1 -N 127.0.0.1 5140

sleep 1
done

