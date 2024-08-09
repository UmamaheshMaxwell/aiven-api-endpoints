#!/bin/bash

# ************************** Source Environment Variables **************************
# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
# Get the AIVEN_API_TOKEN using the function
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Define API URL for Creating Project Service **************************
# Define the base URL for project services
CREATE_PROJECT_SERVICE_BASE_URL="$AIVEN_API_URL/project"

# ************************** Create Project Service Function **************************
create_project_service() {
    local PROJECT_NAME=$1
    local CLOUD=$2
    local COPY_TAGS=$3
    local MAINTENANCE_DOW=$4
    local MAINTENANCE_TIME=$5
    local PLAN=$6
    local SERVICE_NAME=${7}
    local SERVICE_TYPE=${8}
    local TAGS=${9}
    local TERMINATION_PROTECTION=${10}

    # JSON data to send in the request
    local JSON_DATA=$(
        cat <<EOF
{
    "cloud": "$CLOUD",
    "copy_tags": $COPY_TAGS,
    "maintenance": {
        "dow": "$MAINTENANCE_DOW",
        "time": "$MAINTENANCE_TIME"
    },
    "plan": "$PLAN",
    "service_name": "$SERVICE_NAME",
    "service_type": "$SERVICE_TYPE",
    "tags": $TAGS,
    "termination_protection": $TERMINATION_PROTECTION,
    "user_config": {
        "variant": "timescale"
    }
}
EOF
    )

    # Define the URL for creating the project service
    local CREATE_PROJECT_SERVICE_URL="$CREATE_PROJECT_SERVICE_BASE_URL/$PROJECT_NAME/service"

    # Make the POST request to create the service
    response=$(make_api_request "POST" "$CREATE_PROJECT_SERVICE_URL" "$JSON_DATA")

    # Check if the request was unsuccessful based on the error structure
    if echo "$response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "Failed to create service for project $PROJECT_NAME: $(echo "$response" | jq -r '.errors[0].message')"
        return 1 # Return 1 for failure
    fi

    # Return the full response
    echo "$response"
}
