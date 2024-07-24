#-- DELETE EXTRACT
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-X DELETE https://<IP or hostname>/services/v2/extracts/<Extract Name> \
--data-raw '' \
|  python -m json.tool 
