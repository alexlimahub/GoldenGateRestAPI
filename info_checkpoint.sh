curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-X GET https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/extracts/EDEMOR/info/checkpoints \
| jq '.response'

curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-X GET https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/replicaast/RDEMOR/info/checkpoints \
| jq '.response'