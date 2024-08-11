#!/bin/bash

# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Get AIVEN_API_URL **************************
AIVEN_API_URL=$(get_aiven_api_url)


# ************************** Create User Group **************************
create_user_group() {
    # Define request method and URL
    local METHOD="POST"
    local ORGANIZATION_ID="$1"  # First parameter: Organization ID
    local DESCRIPTION="$2"      # Second parameter: Description
    local USER_GROUP_NAME="$3"  # Third parameter: User group name

    # Define the API URL
    local URL="$AIVEN_API_URL/organization/$ORGANIZATION_ID/user-groups"

    # Construct the JSON payload using the cat <<EOF format
    local JSON_DATA=$(cat <<EOF
{
    "description": "$DESCRIPTION",
    "user_group_name": "$USER_GROUP_NAME"
}
EOF
    )

    # Call the make_api_request function to create the user group
    response=$(make_api_request "$METHOD" "$URL" "$JSON_DATA")

    # Return the complete response
    echo "$response"
    return 0 # Return 0 for success
}


