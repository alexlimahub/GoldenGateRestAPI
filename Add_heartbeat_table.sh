curl -L -X POST 'https://<URL>/services/v2/connections/<Domain>.<Connection_name>/tables/heartbeat' \
-H 'Authorization: Basic .....' \
-H 'Content-Type: text/plain' \
-d '{"frequency":60}'
