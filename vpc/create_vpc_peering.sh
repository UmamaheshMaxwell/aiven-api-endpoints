#!/bin/bash

# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Get AIVEN_API_URL **************************
AIVEN_API_URL=$(get_aiven_api_url)

# ************************** Create VPC within a Project **************************
create_vpc() {
    # Define request method and URL
    local METHOD="POST"
    local PROJECT="$1"        # First parameter: Project name
    local CLOUD_NAME="$2"     # Second parameter: Cloud name
    local NETWORK_CIDR="$3"   # Third parameter: Network CIDR

    # Define the API URL
    local URL="$AIVEN_API_URL/project/$PROJECT/vpcs"

    # Construct the JSON payload using the cat <<EOF format
    local JSON_DATA=$(cat <<EOF
{
    "cloud_name": "$CLOUD_NAME",
    "network_cidr": "$NETWORK_CIDR",
    "peering_connections": []
}
EOF
    )

    # Debugging: Print the payload to check for issues
    echo "Payload: $JSON_DATA"

    # Call the make_api_request function to create the VPC
    response=$(make_api_request "$METHOD" "$URL" "$JSON_DATA")

    # Return the full response for the created VPC
    echo "$response"
    return 0 # Return 0 for success
}

# Example usage:
# create_vpc "main-sequence-hub" "timescale-google-europe-west1" "10.0.0.0/24"
