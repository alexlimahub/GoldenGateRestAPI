#-- ADD REPLICAT
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Accept: application/json" \
-X POST https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/replicats/RDEMOR \
-d '{
"description":"Create Reverse Replicat Demo",
"config":[
"REPLICAT RDEMOR",
"USERIDALIAS pdbdsrc DOMAIN OracleGoldenGate",
"DBOPTIONS SETTAG 02",
"GETTRUNCATES",
"DDL INCLUDE MAPPED",
"MAP pdbdtrg.hr.*, TARGET hr.*;"
],
"credentials": {"alias": "pdbdsrc"},
"mode": {"parallel": false,"type": "integrated"},
"registration": "none",
"source": {"name": "r1"}, 
"status": "running"
}' \
| python -m json.tool 
