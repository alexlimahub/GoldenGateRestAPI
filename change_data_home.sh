curl -L -X PATCH 'https://<URL>/services/v2/deployments/<deployment_name>' \
-H 'Content-Type: application/json' \
-H 'Authorization: Basic ......' \
-d '{"oggDataHome":"/u02/Deployment/var/lib/data/Boston"}'
