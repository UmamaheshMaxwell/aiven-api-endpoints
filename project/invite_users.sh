#!/bin/bash

# ************************** Source Environment Variables **************************
# Source the first script to access its functions
source read_env.sh  
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
# Get the AIVEN_API_TOKEN using the function
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Define API URL for Project Invite **************************
PROJECT_INVITE_API_URL="$AIVEN_API_URL/project/{project}/invite"

# ************************** Invite Member to Project Function **************************
# Function to invite a member to a project using a POST request
invite_project_member() {
    local PROJECT_NAME=$1
    local MEMBER_TYPE=$2
    local USER_EMAIL=$3

    # ** JSON Data for Project Member Invitation **
    local JSON_DATA=$(cat <<EOF
{
    "member_type": "$MEMBER_TYPE",
    "user_email": "$USER_EMAIL"
}
EOF
)

    # Define request method and URL
    local METHOD="POST"
    local URL="${PROJECT_INVITE_API_URL/\{project\}/$PROJECT_NAME}"

    # ** Make POST Request to Invite Member **
    # Call the make_api_request function to send the invite
    response=$(make_api_request "$METHOD" "$URL" "$JSON_DATA")

    # Output the response
    echo "$response"
}

# ************************** Invite Member to Project **************************
# Define the input values
PROJECT_NAME="main-sequence"
MEMBER_TYPE="developer"  # Available types: admin, operator, developer, read_only
USER_EMAIL="maheshmeka16@gmail.com"

# Call the function with the named variables
invite_project_member "$PROJECT_NAME" "$MEMBER_TYPE" "$USER_EMAIL"