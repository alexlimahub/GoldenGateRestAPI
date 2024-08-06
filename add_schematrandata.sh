curl -L -X POST 'https://<URL>/services/v2/connections/<Domain>.<Connection_name>/trandata/schema' \
-H 'Authorization: Basic ......' \
-H 'Content-Type: text/plain' \
-d '{
    "operation":"add",
    "schemaName":"<schema_name>",
    "allColumns": true
}'
