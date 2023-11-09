#-- LAG of all processes
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Accept: application/json" \
-X POST https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/commands/execute \
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
