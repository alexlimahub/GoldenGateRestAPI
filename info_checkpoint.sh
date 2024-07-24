curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-X GET https://<IP or hostname>/services/v2/extracts/<Extract Name>/info/checkpoints \
| jq '.response'

curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-X GET https://<IP or hostname>/services/v2/replicaast/<Replicat Name>/info/checkpoints \
| jq '.response'
