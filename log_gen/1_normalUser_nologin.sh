#!/bin/bash
#<190>#1614735946364#KGn6ax0i#ebook#172.31.9.60#12345#171.237.138.67#127.0.0.1:8083#ebook.seemedemo.com#POST#/login#200#nocontentype#0#AaZHN2BBBBBBjAY3fLSqDLPwzInc2Ogn#AS5q4jNm2lKg4SXCyJRF0AQ8vTwCq6aI#Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0#0#empty#

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
  RANUSERID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
  RANDI=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
  SESSID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
  diA="AaZHN2BBBBBBjAY3fLSqDLPw$RANDI"
  diB="AS5q4jNm2lKg4SXCyJRF0AQ8$RANDI"

  epochtime=`date +%s%N | cut -b1-13`
  uri=${uriarray[0]}
  msg="<190>#$epochtime#$RANUSERID#$virtualname#$clientip#12345#$clientip#192.168.100.10:8083#$fqdn#GET#$uri#200#na#0#$diA#$diB#$ua#0#$SESSID#"
  echo $msg
  echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  -w 1 -N 127.0.0.1 5140

  epochtime=`date +%s%N | cut -b1-13`
  uri=${uriarray[1]}
  msg="<190>#$epochtime#$RANUSERID#$virtualname#$clientip#12345#$clientip#192.168.100.10:8083#$fqdn#GET#$uri#200#na#0#$diA#$diB#$ua#0#$SESSID#"
  echo $msg
  echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  -w 1 -N 127.0.0.1 5140

  epochtime=`date +%s%N | cut -b1-13`
  uri=${uriarray[2]}
  msg="<190>#$epochtime#$RANUSERID#$virtualname#$clientip#12345#$clientip#192.168.100.10:8083#$fqdn#GET#$uri#200#na#0#$diA#$diB#$ua#0#$SESSID#"
  echo $msg
  echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  -w 1 -N 127.0.0.1 5140 

  epochtime=`date +%s%N | cut -b1-13`
  uri=${uriarray[3]}
  msg="<190>#$epochtime#$RANUSERID#$virtualname#$clientip#12345#$clientip#192.168.100.10:8083#$fqdn#GET#$uri#200#na#0#$diA#$diB#$ua#0#$SESSID#"
  echo $msg
  echo $msg |  sed -e 's/^[ \t]*//' |  nc -v -t  -w 1 -N 127.0.0.1 5140 
sleep 1
done

