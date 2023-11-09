#-- ADD EXTRACT
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Accept: application/json" \
-X POST https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/extracts/EDEMOR \
-d '{
"description":"Create Extract Demo",
"config":[
"EXTRACT EDEMOR",
"EXTTRAIL r1",
"USERIDALIAS cdbdtrg DOMAIN OracleGoldenGate",
"-- Integrated extract parameters",
"TRANLOGOPTIONS EXCLUDETAG 01",
"TRANLOGOPTIONS INTEGRATEDPARAMS (max_sga_size 2048, parallelism 4)",
"LOGALLSUPCOLS",
"UPDATERECORDFORMAT COMPACT",
"GETTRUNCATES",
"DDL INCLUDE MAPPED",
"DDLOPTIONS GETREPLICATES, GETAPPLOPS", 
"TABLE pdbdtrg.HR.*;"
],
"source":{
"tranlogs":"integrated"
},
"credentials":{
"alias":"cdbdtrg"
},
"registration":{
"containers": [ "pdbdtrg" ],
"optimized":false
},
"begin":"now",
"targets":[
{
"name":"r1",
"sizeMB":50
}
],
"status":"running"
}' \
| python -m json.tool 
