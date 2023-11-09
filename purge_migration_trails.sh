curl -K /Users/alexlima/Documents/LABS/access.cfg \
-X POST https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/commands/execute \
-H 'Content-Type: application/json' \
-d \
'{
    "name": "purge",
    "purgeType": "trails",
    "trails": [
        {
            "name": "e1"
        }
    ],
    "useCheckpoints": false,
    "keep": [
        {
            "type": "min",
            "units": "files",
            "value": 0
        }
    ]
}' |  python -m json.tool
