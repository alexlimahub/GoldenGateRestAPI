#-- DELETE EXTRACT
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-X DELETE https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/extracts/EDEMO \
--data-raw '' \
|  python -m json.tool 
