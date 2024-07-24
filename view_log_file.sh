curl -L 'https://<hostname>:<port>/services/v2/messages' \
-H 'Authorization: Basic <encoded username:password>' |\
| jq '.response'
