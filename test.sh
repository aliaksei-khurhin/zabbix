#!/bin/bash

curl -i -k -X POST -H 'Content-Type: application/json-rpc' -d @3.json http://192.168.33.10/api_jsonrpc.php
