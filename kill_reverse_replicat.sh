#-- KILL REPLICAT
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{"status": "killed"}' \
-X PATCH https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/replicats/RDEMOR|  python -m json.tool 
