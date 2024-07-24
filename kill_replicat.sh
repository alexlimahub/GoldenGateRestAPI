#-- KILL REPLICAT
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{"status": "killed"}' \
-X PATCH https://<Ip or hostname>/services/v2/replicats/<replicat name>|  python -m json.tool 
