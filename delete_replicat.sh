#!/bin/bash

. ./shared_code.sh

# call read_bidir_oci function
read_bidir_oci

#-- DELETE REPLICAT
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-X DELETE ${ogghost}/services/v2/replicats/${oggrep1} |  python -m json.tool 
