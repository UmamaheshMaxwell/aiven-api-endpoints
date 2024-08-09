#!/bin/bash

# ************************** Source Environment Variables **************************
# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
# Get the AIVEN_API_TOKEN using the function
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Define API URL for Fetching Databases **************************
# Define the base URL for fetching databases within a service
FETCH_DATABASES_BASE_URL="$AIVEN_API_URL/project"

# ************************** Fetch Databases Function **************************
get_databases() {
    local PROJECT_NAME=$1
    local SERVICE_NAME=$2

    # Define the URL for fetching databases within the specified project and service
    local FETCH_DATABASES_URL="$FETCH_DATABASES_BASE_URL/$PROJECT_NAME/service/$SERVICE_NAME/db"

    # Make the GET request to fetch databases within the service
    response=$(make_api_request "GET" "$FETCH_DATABASES_URL")

    # Check if the request was unsuccessful based on the error structure
    if echo "$response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "Failed to fetch databases for project $PROJECT_NAME and service $SERVICE_NAME: $(echo "$response" | jq -r '.errors[0].message')"
        return 1 # Return 1 for failure
    fi

    # Return the full response
    echo "$response"
}

# ************************** Example Usage **************************
# Declare parameters
PROJECT_NAME="main-sequence"
SERVICE_NAME="ts-orm-service"

# Call the function with the named variables
databases_response=$(get_databases "$PROJECT_NAME" "$SERVICE_NAME")
echo "Databases: $databases_response"
