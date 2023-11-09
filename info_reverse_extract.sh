#-- INFO EXTRACT

if [ "$#" -eq 0 ]; then
    echo "You must enter the OGG GROUP NAME command line arguments"
    exit
else
export GROUP_NAME=$1

curl -s -K /Users/alexlima/Documents/LABS/access.cfg \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-X GET https://j4w5mi5njtqa.deployment.goldengate.us-ashburn-1.oci.oraclecloud.com/services/v2/extracts/${GROUP_NAME}/info/status \
| jq '.response'
fi
