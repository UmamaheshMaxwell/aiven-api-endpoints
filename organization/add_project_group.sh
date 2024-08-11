#!/bin/bash

# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Get AIVEN_API_URL **************************
AIVEN_API_URL=$(get_aiven_api_url)

# ************************** Add User Group to Project **************************
add_user_group_to_project() {
    # Define request method and URL
    local METHOD="PUT"  # Updated method to PUT
    local ORG_ID="$1"   # First parameter: Organization ID
    local PROJECT_NAME="$2"  # Second parameter: Project name
    local GROUP_ID="$3"      # Third parameter: Group ID
    local ROLE="$4"          # Fourth parameter: Role in the project

    # Define the API URL
    local URL="$AIVEN_API_URL/organization/$ORG_ID/projects/$PROJECT_NAME/access/groups/$GROUP_ID"

    # Construct the JSON payload using the cat <<EOF format
    local JSON_DATA=$(cat <<EOF
{
    "role": "$ROLE"
}
EOF
    )
    # Debugging: Print the payload to check for issues
    echo "Payload: $JSON_DATA"

    # Call the make_api_request function to add the group to the project
    response=$(make_api_request "$METHOD" "$URL" "$JSON_DATA")

    # Check if the request was unsuccessful based on the error structure
    if echo "$response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "Failed to add group to project: $(echo "$response" | jq -r '.errors[0].message')" >&2
        return 1 # Return 1 for failure
    fi

    # Return the full response for the added group
    echo "$response"
    return 0 # Return 0 for success
}

