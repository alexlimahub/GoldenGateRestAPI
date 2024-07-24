curl -K /Users/alexlima/Documents/LABS/access.cfg \
-X POST https://<ip or hostname>/services/v2/commands/execute \
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
