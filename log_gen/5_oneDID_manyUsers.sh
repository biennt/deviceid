#!/bin/bash

authcodearray[0]='1'
authcodearray[1]='2'
authcodearray[2]='3'
uriarray[0]='/index.html'
uriarray[1]='/logo.png'
uriarray[2]='/styles.css'
uriarray[3]='/main.js'
uriarray[4]='/loginform'
uriarray[5]='/login.do'
uriarray[6]='/download'
uriarray[7]='/userhome.html'
uriarray[8]='/userhome.css'
uriarray[9]='/userhome.js'
virtualname='ebook'
clientip='172.31.9.60'
fqdn='ebook.seemedemo.com'
method='GET' # default
ua='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0'
diA='AaZHN2BBBBBBjAY3fLSqDLPwzInc2Ogn'
diB='AS5q4jNm2lKg4SXCyJRF0AQ8vTwCq6aI'

while true
do
  echo "----------"
  epochtime=`date +%s%N | cut -b1-13`
  RANUSERID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
  ranuriindx=$(($RANDOM % 9))
  uri=${uriarray[$ranuriindx]}
  if [ "$ranuriindx" != "5" ]; then
    authcode=0
    method='POST'
  else
    ranauindx=$(($RANDOM % 3))
    authcode=${authcodearray[$ranauindx]}
  fi

  msg="<190>#$epochtime#$RANUSERID#$virtualname#$clientip#12345#$clientip#192.168.100.10:8083#$fqdn#$method#$uri#200#na#0#$diA#$diB#$ua#$authcode#na#"
  echo $msg
  echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  -w 1 -N 127.0.0.1 5140
  sleep 1
done

