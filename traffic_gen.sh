#!/bin/bash
while true; do
# for Linux
#USERID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
#PWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
# for MacOS
USERID=`head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c 8`
PWD=`head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c 8`

echo $USERID
echo $PWD
ustring="$USERID:$PWD"

curl  'https://elk.bienlab.com/app/home' \
 --user "$ustring" \
 -H 'Connection: keep-alive' \
 -H 'Pragma: no-cache' \
 -H 'Cache-Control: no-cache' \
 -H 'Upgrade-Insecure-Requests: 1' \
 -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
 -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
 -H 'Sec-Fetch-Site: none' \
 -H 'Sec-Fetch-Mode: navigate' \
 -H 'Sec-Fetch-User: ?1' \
 -H 'Sec-Fetch-Dest: document' \
 -H 'Accept-Language: en-US,en;q=0.9,vi;q=0.8' \
 -H 'Cookie: _imp_di_pc_=AT6M3F8AAAAAchQrBaF6AO%2FY4JOhtuGf; _imp_apg_r_=%7B%22diA%22%3A%22AT6M3F8AAAAAchQrBaF6AO%2FY4JOhtuGf%22%2C%22diB%22%3A%22AbQWDHOomTvU6%2F7sKpw1vyIwcLzCqpsk%22%7D'
done
