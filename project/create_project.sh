#!/bin/bash

# ************************** Source Environment Variables **************************
# Source the first script to access its functions
source read_env.sh  
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
# Get the AIVEN_API_TOKEN using the function
AIVEN_API_TOKEN=$(get_mst_api_token)
#echo "The captured AIVEN_API_TOKEN is: $AIVEN_API_TOKEN"

# ************************** Define API URL for Project Creation **************************
PROJECT_AIVEN_API_URL="$AIVEN_API_URL/project"

# ************************** Create Project Function **************************
# Function to create a project using a POST request
create_project() {
    local ACCOUNT_ID=$1
    local CLOUD_PROVIDER=$2
    local PROJECT_NAME=$3
    local BASE_PORT=$4
    local BILLING_GROUP_ID=$5
    local TAGS=$6

    # ** JSON Data for Project Creation **
    # JSON data to send in the request
    local JSON_DATA=$(cat <<EOF
{
    "account_id": "$ACCOUNT_ID",
    "cloud": "$CLOUD_PROVIDER",
    "project": "$PROJECT_NAME",
    "base_port": $BASE_PORT,
    "billing_group_id": "$BILLING_GROUP_ID",
    "tags": $TAGS
}
EOF
)

    # Define request method and URL
    local METHOD="POST"
    local URL="$PROJECT_AIVEN_API_URL"

    # ** Make POST Request to Create Project **
    # Call the make_api_request function to create the project
    response=$(make_api_request "$METHOD" "$URL" "$JSON_DATA")

    # Check if the request was unsuccessful based on the error structure
    if echo "$response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "Failed to create project: $(echo "$response" | jq -r '.errors[0].message')"
        return 1 # Return 1 for failure
    fi

    echo "$response"
}

# ************************** Example Call **************************
# create_project "account_id" "google-europe-west1" "my-project" 15000 "billing_group_id" '{"env": "dev", "db": "timescale"}'
