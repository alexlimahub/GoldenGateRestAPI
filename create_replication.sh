#!/bin/bash
#

## Extract the Database and GoldenGate IPs and Passwords fro the Terraform Output
OGG_EAST_PUBLIC_IP="$(terraform output -raw ogg-east-public_ip)"
OGG_EAST_PRIVATE_IP="$(terraform output -raw ogg-east-private_ip)"
OGG_WEST_PUBLIC_IP="$(terraform output -raw ogg-west-public_ip)"
OGG_WEST_PRIVATE_IP="$(terraform output -raw ogg-west-private_ip)"
DB_EAST_PUBLIC_IP="$(terraform output -raw db-east-public_ip)"
DB_EAST_PRIVATE_IP="$(terraform output -raw db-east-private_ip)"
DB_WEST_PUBLIC_IP="$(terraform output -raw db-west-public_ip)"
DB_WEST_PRIVATE_IP="$(terraform output -raw db-west-private_ip)"
GLOBAL_PASS="$(terraform output -raw global_password)"
GLOBAL_USER="$(terraform output -raw global_ogg_user)"

## Setup
conn_propeties=("WEST:$DB_WEST_PUBLIC_IP:$OGG_WEST_PUBLIC_IP" "EAST:$DB_EAST_PRIVATE_IP:$OGG_EAST_PUBLIC_IP")
extract_properties=("WEST:EWEST:ew:$OGG_WEST_PUBLIC_IP" "EAST:EEAST:ee:$OGG_EAST_PUBLIC_IP")   # Name for the Extract (<connection alias>:<Extract_name>:<trail>)
distpath_properties=("WEST:DPWE:ew:$OGG_WEST_PUBLIC_IP:$OGG_EAST_PUBLIC_IP:dw" "EAST:DPEW:ee:$OGG_EAST_PUBLIC_IP:$OGG_WEST_PUBLIC_IP:de")   # Name for the Extract (<connection alias>:<Extract_name>:<trail>)
replicat_properties=("WEST:REAST:$OGG_WEST_PUBLIC_IP:de" "EAST:RWEST:$OGG_EAST_PUBLIC_IP:dw")  # Name for the replicat represents where the data come from (<connection alias>:<Replicat_name>:<trail>)
global_password_encoded=`echo -n "$GLOBAL_USER:$GLOBAL_PASS" | base64`
ogg_port=443

# Construct the Authorization header
AUTH_HEADER="Authorization: Basic ${global_password_encoded}"

# #Create Connection to the all Databases
for region in "${conn_propeties[@]}"
do
    conn_name=`echo $region | awk -F':' '{print $1}'`
    db_ip=`echo $region     | awk -F':' '{print $2}'`
    ogg_ip=`echo $region    | awk -F':' '{print $3}'`
    echo 
    echo "## GoldenGate Database Credentials "
    echo "###############################################################" 
    curl -k -X POST 'https://'$ogg_ip':'$ogg_port'/services/v2/credentials/OracleGoldenGate/'$conn_name'' \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "${AUTH_HEADER}" \
    -d '{"userid":"oggadmin@'$db_ip':1521/freepdb1","password":"'$GLOBAL_PASS'"}' | jq
    echo 
    echo "## Creating GoldenGate User for Distribution Path" 
    echo "###############################################################" 
    curl -k -X POST 'http://'$ogg_ip':9012/services/v2/authorizations/Operator/oggnet' \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "${AUTH_HEADER}" \
    -d '{
            "credential":"'$GLOBAL_PASS'",
            "info":"Distribution Path User"
        }' | jq
    echo
    echo "## Creating GoldenGate Network Alias for Distribution Path" 
    echo "###############################################################" 
    curl -k -X POST 'https://'$ogg_ip':'$ogg_port'/services/v2/credentials/Network/oggnet' \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "${AUTH_HEADER}" \
    -d '{"userid":"oggnet","password":"'$GLOBAL_PASS'"}' | jq
    echo

done

#### Add Schematranda, heartbeat and checkpoint tables to all Databases
for region in "${conn_propeties[@]}"
do
    conn_name=`echo $region | awk -F':' '{print $1}'`
    db_ip=`echo $region     | awk -F':' '{print $2}'`
    ogg_ip=`echo $region    | awk -F':' '{print $3}'`
    echo
    echo "## Adding Schematrandata"
    echo "##########################################################" 
    curl -k -X POST 'https://'$ogg_ip':'$ogg_port'/services/v2/connections/OracleGoldenGate.'$conn_name'/trandata/schema' \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "${AUTH_HEADER}" \
    -d '{"operation":"add","schemaName":"hr","allColumns": true}' | jq
    echo
    echo "## Adding Heartbeat Table"
    echo "##########################################################" 
    curl -k -X POST 'https://'$ogg_ip':'$ogg_port'/services/v2/connections/OracleGoldenGate.'$conn_name'/tables/heartbeat' \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "${AUTH_HEADER}" \
    -d '{"frequency":60}' | jq
    echo
    echo "## Adding Checkpoint Table"
    echo "##########################################################"   
    curl -k -X POST 'https://'$ogg_ip':'$ogg_port'/services/v2/connections/OracleGoldenGate.'$conn_name'/tables/checkpoint' \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "${AUTH_HEADER}" \
    -d '{"operation":"add","name":"oggadmin.checkpoints"}' | jq
    echo
    echo
done

# Add Extracts
for extract in "${extract_properties[@]}"
do
    region_name=`echo $extract  | awk -F':' '{print $1}'`
    extract_name=`echo $extract | awk -F':' '{print $2}'`
    extract_file=`echo $extract | awk -F':' '{print $3}'`
    ogg_ip=`echo $extract       | awk -F':' '{print $4}'`

    echo "Creating extract "$extract_name" on "$region_name" ......"
    echo "##########################################################"
    curl -k -X POST 'https://'$ogg_ip':'$ogg_port'/services/v2/extracts/'$extract_name'' \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "${AUTH_HEADER}" \
    -d '{
    "description":"Create Extract Demo",
    "config":[
        "EXTRACT '$extract_name'",
        "EXTTRAIL '$extract_file'",
        "USERIDALIAS '$region_name' DOMAIN OracleGoldenGate",
        "TRANLOGOPTIONS EXCLUDETAG 00",
        "DDL INCLUDE MAPPED",
        "TABLE HR.*;"
    ],
    "source":"tranlogs",
    "credentials":{
        "alias":"'$region_name'"
    },
    "registration":"default",
    "begin":"now",
    "targets":[
        {
        "name":"'$extract_file'",
        "sizeMB":50
        }
    ],
    "status":"running"
    }' \
    | jq
    echo
    echo  
done

## Add Dist Path

for dp in "${distpath_properties[@]}"
do
    region_name=`echo $dp   | awk -F':' '{print $1}'`
    dp_name=`echo $dp       | awk -F':' '{print $2}'`
    extract_file=`echo $dp  | awk -F':' '{print $3}'`
    ogg_ip=`echo $dp        | awk -F':' '{print $4}'`
    ogg_ip_remote=`echo $dp | awk -F':' '{print $5}'`
    dp_filename=`echo $dp   | awk -F':' '{print $6}'`
    
    echo "Creating Dist Path "$dp_name" on  "$region_name" ......"
    echo "########################################################"
    echo
    curl -k -X POST 'https://'$ogg_ip':'$ogg_port'/services/v2/sources/'$dp_name'' \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "${AUTH_HEADER}" \
    -d '{
        "name":"'$dp_name'",
        "description":"DIST PATH '$dp_name'",
        "source":{
            "uri":"trail://'$ogg_ip'/services/'$region_name'/distsrvr/v2/sources?trail='$extract_file'"
        },
        "target":{
            "uri":"ws://'$ogg_ip_remote':9014/services/v2/targets?trail='$dp_filename'",
            "authenticationMethod":{"domain":"Network","alias":"oggnet"}
        },
        "begin":{
            "sequence":0,
            "offset":0
        },
        "status":"running"
    }' \
    | jq
    echo
    echo  
done   

# Add Replicat
for replicat in "${replicat_properties[@]}"
do
    region_name=`echo $replicat     | awk -F':' '{print $1}'`
    replicat_name=`echo $replicat   | awk -F':' '{print $2}'`
    ogg_ip=`echo $replicat          | awk -F':' '{print $3}'`
    replicat_file=`echo $replicat   | awk -F':' '{print $4}'`
    
    echo "#########################################"
    echo "Creating replicat "$replicat_name" ......"
    echo "#########################################"
    echo
    curl -k -X POST 'https://'$ogg_ip':'$ogg_port'/services/v2/replicats/'$replicat_name'' \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "${AUTH_HEADER}" \
    -d '{
    "description":"Create Replicat",
    "config":[
        "REPLICAT '$replicat_name'",
        "USERIDALIAS '$region_name' DOMAIN OracleGoldenGate",
        "DDL INCLUDE MAPPED",
        "MAP hr.*, TARGET hr.*;"
        ],
        "credentials": {"alias":"'$region_name'"},
        "mode": {"parallel":false,"type":"integrated"},
        "source": {"name": "'$replicat_file'"},
        "checkpoint":{"table":"oggadmin.checkpoints"},
        "status": "running"
    }' \
    | jq
    echo
    echo  
done


echo "#########################################################################"
echo "#########################################################################"

echo