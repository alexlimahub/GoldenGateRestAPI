#-- This example allow you to modify the WebUI session timeout settings
#-- Documentation for this options:
#-- https://docs.oracle.com/en/middleware/goldengate/core/23/oggra/op-services-version-deployments-deployment-services-service-patch.html

#!/bin/bash
 
# Configuration variables
dname='WEST'
timeout=14400  # 4 hours
hn='localhost'
netrc_file="$HOME/.ogg_netrc.sh"
sm_url="https://${hn}:9090/services/v2/deployments/ServiceManager/services/ServiceManager"
as_url="https://${hn}:9090/services/v2/deployments/${dname}/services/adminsrvr"
 
# Function to check if response is valid JSON
check_response() {
    local response="$1"
    local service_name="$2"
     
    if echo "$response" | grep -q "<html>"; then
        echo "Error: Received HTML error page for $service_name"
        echo "$response"
        return 1
    fi
     
    if [ -z "$response" ]; then
        echo "Error: Empty response from $service_name"
        return 1
    fi
     
    if ! echo "$response" | jq empty 2>/dev/null; then
        echo "Error: Invalid JSON response from $service_name"
        echo "Response was: $response"
        return 1
    fi
     
    return 0
}
 
echo "=== Updating Admin Server Timeout Settings ==="
echo "NOTE: This will NOT restart the service automatically"
echo ""
 
# Get current config
as_response=$(curl --netrc-file "$netrc_file" -k -s \
     -H "Content-Type: application/json" -H "Accept: application/json" \
     -X GET "$as_url")
 
if ! check_response "$as_response" "Admin Server"; then
    echo "Failed to get valid Admin Server config"
    exit 1
fi
 
# Build new config - Only update the config section, DO NOT set status
echo "$as_response" | \
  jq --arg timeout "$timeout" \
  '.response.config.authorizationDetails.sessionInactiveSecs = ($timeout | tonumber) |
   .response.config.authorizationDetails.sessionDurationSecs = ($timeout | tonumber) |
   {config: .response.config}' > /tmp/admin_config.json
 
echo "Configuration to apply:"
cat /tmp/admin_config.json | jq
 
# Verify the config file is valid JSON
if ! jq empty /tmp/admin_config.json 2>/dev/null; then
    echo "Generated invalid admin config JSON"
    exit 1
fi
 
# Apply the update
echo ""
echo "Applying Admin Server timeout update (no restart)..."
as_patch_response=$(curl --netrc-file "$netrc_file" -k -s -L -X PATCH "$as_url" \
     -H "Content-Type: application/json" -H "Accept: application/json" \
     -d @/tmp/admin_config.json)
 
echo "$as_patch_response" | jq
 
# Check if service is still responding
echo ""
echo "Verifying Admin Server is still responding..."
sleep 2
test_response=$(curl --netrc-file "$netrc_file" -k -s -o /dev/null -w "%{http_code}" "$as_url")
if [ "$test_response" = "200" ]; then
    echo "✓ Admin Server is still up and responding"
else
    echo "✗ WARNING: Admin Server returned status $test_response"
fi
 
echo ""
echo "=== Updating Service Manager Timeout Settings ==="
 
# Get current config
sm_response=$(curl --netrc-file "$netrc_file" -k -s \
     -H "Content-Type: application/json" -H "Accept: application/json" \
     -X GET "$sm_url")
 
if ! check_response "$sm_response" "Service Manager"; then
    echo "Failed to get valid Service Manager config"
    exit 1
fi
 
# Build new config
echo "$sm_response" | \
  jq --arg timeout "$timeout" \
  '.response.config.authorizationDetails.sessionInactiveSecs = ($timeout | tonumber) |
   .response.config.authorizationDetails.sessionDurationSecs = ($timeout | tonumber) |
   {config: .response.config}' > /tmp/sm_config.json
 
echo "Configuration to apply:"
cat /tmp/sm_config.json | jq
 
# Verify the config file is valid JSON
if ! jq empty /tmp/sm_config.json 2>/dev/null; then
    echo "Generated invalid SM config JSON"
    exit 1
fi
 
# Apply the update
echo ""
echo "Applying Service Manager timeout update (no restart)..."
sm_patch_response=$(curl --netrc-file "$netrc_file" -k -s -L -X PATCH "$sm_url" \
     -H "Content-Type: application/json" -H "Accept: application/json" \
     -d @/tmp/sm_config.json)
 
echo "$sm_patch_response" | jq
 
# Check if service is still responding
echo ""
echo "Verifying Service Manager is still responding..."
sleep 2
test_response=$(curl --netrc-file "$netrc_file" -k -s -o /dev/null -w "%{http_code}" "$sm_url")
if [ "$test_response" = "200" ]; then
    echo "✓ Service Manager is still up and responding"
else
    echo "✗ WARNING: Service Manager returned status $test_response"
fi
 
echo ""
echo "=== Summary ==="
echo "Timeout settings updated successfully!"
echo "The changes may require a service restart to take full effect."
echo ""
echo "To restart services (if needed), use a separate restart script."
