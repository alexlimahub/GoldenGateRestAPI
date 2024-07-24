#-- LAG of all processes
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Accept: application/json" \
-X POST https://<IP or hostname>/services/v2/commands/execute \
-d '{
    "name":"report",
    "reportType":"lag",
    "thresholds":[
        {
            "type":"info",
            "units":"seconds",
            "value":0
        },
        {
            "type":"critical",
            "units":"seconds",
            "value":5
        }
    ]
}' |  jq '.response'
#}' | python -m json.tool 
