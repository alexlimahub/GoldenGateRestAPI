#-- DELETE Trail files
./purge_migration_trails.sh

#-- ADD EXTRACT
curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Accept: application/json" \
-X POST https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/extracts/EDEMO \
-d '{
"description":"Create Extract Demo",
"config":[
"EXTRACT EDEMO",
"EXTTRAIL e1",
"USERIDALIAS cdbdsrc DOMAIN OracleGoldenGate",
"-- Integrated extract parameters",
"TRANLOGOPTIONS EXCLUDETAG 02",
"TRANLOGOPTIONS INTEGRATEDPARAMS (max_sga_size 2048, parallelism 4)",
"LOGALLSUPCOLS",
"UPDATERECORDFORMAT COMPACT",
"GETTRUNCATES",
"DDL INCLUDE MAPPED",
"DDLOPTIONS GETREPLICATES, GETAPPLOPS", 
"TABLE pdbdsrc.HR.*;"
],
"source":{
"tranlogs":"integrated"
},
"credentials":{
"alias":"cdbdsrc"
},
"registration":{
"containers": [ "pdbdsrc" ],
"optimized":false
},
"begin":"now",
"targets":[
{
"name":"e1",
"sizeMB":50
}
],
"status":"running"
}' \
| jq '.response'
