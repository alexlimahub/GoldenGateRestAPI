#-- Thic will check the Services PORTS

curl -k  -L 'https://<URL>/services/v2/installation/services' \
-H 'Authorization: Basic <encoded username:password>' | jq '.response' | egrep 'port|serviceName' | uniq
