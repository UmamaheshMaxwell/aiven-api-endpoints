#!/bin/bash

# ************************** Source Environment Variables **************************
# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
# Get the AIVEN_API_TOKEN using the function
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Define API URL for Fetching Project Services **************************
# Define the base URL for project services
FETCH_PROJECT_SERVICES_BASE_URL="$AIVEN_API_URL/project"

# ************************** Fetch Project Services Function **************************
get_project_services() {
    local PROJECT_NAME=$1

    # Define the URL for fetching project services
    local FETCH_PROJECT_SERVICES_URL="$FETCH_PROJECT_SERVICES_BASE_URL/$PROJECT_NAME/service"

    # Make the GET request to fetch services within the project
    response=$(make_api_request "GET" "$FETCH_PROJECT_SERVICES_URL")

    # Check if the request was unsuccessful based on the error structure
    if echo "$response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "Failed to fetch services for project $PROJECT_NAME: $(echo "$response" | jq -r '.errors[0].message')"
        return 1 # Return 1 for failure
    fi

    # Return the full response
    echo "$response"
}

# # ************************** Example Usage **************************
# # Example usage to fetch services for a specific project
# services_response=$(get_project_services "main-sequence")
# echo "Services: $services_response"
