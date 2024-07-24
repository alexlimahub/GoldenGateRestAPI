curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-X GET https://<IP or hostname>/services/v2/replicats/<Replicat Name>/info/status |\
| jq '.response'
