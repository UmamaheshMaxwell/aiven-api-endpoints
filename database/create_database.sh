#!/bin/bash

# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Get AIVEN_API_URL **************************
AIVEN_API_URL=$(get_aiven_api_url)

# ************************** Create Database within a Service **************************
create_database() {
    # Define request method and URL
    local METHOD="POST"
    local PROJECT="$1"        # First parameter: Project name
    local SERVICE_NAME="$2"    # Second parameter: Service name
    local DATABASE="$3"        # Third parameter: Database name
    local LC_COLLATE="$4"      # Fourth parameter: Locale for collation
    local LC_CTYPE="$5"        # Fifth parameter: Locale for character classification

    # Define the API URL
    local URL="$AIVEN_API_URL/project/$PROJECT/service/$SERVICE_NAME/db"

    # Construct the JSON payload using the cat <<EOF format
    local JSON_DATA=$(cat <<EOF
{
    "database": "$DATABASE",
    "lc_collate": "$LC_COLLATE",
    "lc_ctype": "$LC_CTYPE"
}
EOF
    )

    # Debugging: Print the payload to check for issues
    echo "Payload: $JSON_DATA"

    # Call the make_api_request function to create the database
    response=$(make_api_request "$METHOD" "$URL" "$JSON_DATA")

    # Check if the request was unsuccessful based on the error structure
    if echo "$response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "Failed to create database: $(echo "$response" | jq -r '.errors[0].message')" >&2
        return 1 # Return 1 for failure
    fi

    # Return the full response for the created database
    echo "$response"
    return 0 # Return 0 for success
}

