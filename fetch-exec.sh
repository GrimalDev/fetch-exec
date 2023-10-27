#!/bin/bash

response=$(curl -X GET \
  -H 'Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5' \
  -H 'Accept: application/json' \
  -H 'Cache-Control: max-age=0' \
  -H 'Accept-Language: en-us,en;q=0.5' \
  -H 'Accept-Encoding: gzip, deflate, br' \
  -H 'Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7' \
  -H 'Connection: keep-alive' \
  -H 'Keep-Alive: 300' \
  -H 'Referer: https://www.google.com/' \
  -H 'Pragma: ' \
  -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36' \
  --location \
  --compressed \
  --connect-timeout 120 \
  --max-time 30 \
  --max-redirs 10 \
  --insecure \
  --http1.1 \
  --silent \
  --write-out "[[END]]%{http_code}" \
  "$1")

#seperate the response from the http code
fetchResult="${response%\[\[END]]*}"
code="${response##*\[\[END]]}"

#Check if the code is something other than 200 or response empty
if [ "$code" != "200" ] || [ -z "$fetchResult" ]; then
  echo "[{ \"httpCode\": \"$code\" }]"
  exit 1
fi

echo "[{ \"httpCode\": \"$code\" }]"

#Save the response to a file
echo "$fetchResult" > "$2"
