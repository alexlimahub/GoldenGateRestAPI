#-- Documentation for this options:
#-- https://docs.oracle.com/en/middleware/goldengate/core/23/oggra/op-services-version-deployments-deployment-services-service-patch.html

curl -L -X PATCH 'https://<IP or hostname>/services/v2/deployments/<Deployment>/services/adminsrvr' \
-H 'Content-Type: application/json' \
-H 'Authorization: Basic <encoded username:password>' \
-d '{
  "config": {
    "authorizationDetails": {
        "sessionDurationSecs": 7200,
        "sessionInactiveSecs": 3600,
        "sessionReauthorizationLimit": 12,
        "useMovingExpirationWindow": false,
        "validityDurationSecs": 300
    }
  }
}'