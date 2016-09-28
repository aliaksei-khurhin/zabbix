#!/bin/bash

ip=$(hostname -I | awk '{print $2}') # $2 is special for vagrant VM on virtualbox, another providers have only one IP by default
# getting aythentication token to variable
token=$(curl -i -X POST -H 'Content-Type: application/json-rpc' -d @1.json http://192.168.33.10/api_jsonrpc.php | sed -n 's/.*result":"\(.*\)",.*/\1/p')

# changing the necessary values in json-file
sed -i.bak "s/ip_replace/$ip/g" ./3.json
sed -i "s/token_replace/$token/g" ./3.json

# adding the host
curl -i -k -X POST -H 'Content-Type: application/json-rpc' -d @3.json http://192.168.33.10/api_jsonrpc.php

# restoring the original file to rich re-entrancy of the script
mv -f 3.json.bak 3.json
