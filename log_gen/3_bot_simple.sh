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


while true
do
  echo "----------"
  RANUSERID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
  SESSID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 18 | head -n 1)
  RANDI=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
  diA="AaZHN2BBBBBBjAY3fLSqDLPw$RANDI"
  diB="AS5q4jNm2lKg4SXCyJRF0AQ8$RANDI"
  echo $RANDI
  echo $diA
  echo $diB


# login process
 epochtime=`date +%s%N | cut -b1-13`
  uri=${uriarray[5]}
  msg="<190>#$epochtime#$RANUSERID#$virtualname#$clientip#12345#$clientip#192.168.100.10:8083#$fqdn#POST#$uri#302#na#0#$diA#$diB#$ua#1#$SESSID#"
  echo $msg
  echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  -w 1 -N 127.0.0.1 5140

## post login
  epochtime=`date +%s%N | cut -b1-13`

## just doing what it needs
  epochtime=`date +%s%N | cut -b1-13`
  uri=${uriarray[6]}
  msg="<190>#$epochtime#$RANUSERID#$virtualname#$clientip#12345#$clientip#192.168.100.10:8083#$fqdn#GET#$uri#200#na#0#$diA#$diB#$ua#0#$SESSID#"
  echo $msg
  echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  -w 1 -N 127.0.0.1 5140

#sleep 1
done

