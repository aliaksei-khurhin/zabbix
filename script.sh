#!/bin/bash
curl -sL -w "%{http_code} \\n" "onliner.by" -o /dev/null
