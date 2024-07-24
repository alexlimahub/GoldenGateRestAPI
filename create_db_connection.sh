curl -L 'https://<ip or hostname>/services/v2/credentials/OracleGoldenGate/<Connection Name>' \
-H 'Authorization: Basic <encoded username:password>' \
-H 'Content-Type: text/plain' \
--data-raw '{
    "userid":"<username>@<DB hostname>:<port>/<service_name>",
    "password":"Welcome##123"
}'