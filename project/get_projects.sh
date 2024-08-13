#!/bin/bash

# ************************** Source Environment Variables **************************
# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN ***********************************
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Define API URL for Projects ****************************
PROJECTS_AIVEN_API_URL="$AIVEN_API_URL/project"

# ************************** List All Projects Function *****************************
list_projects() {
    # Define request method and URL
    local METHOD="GET"
    local URL="$PROJECTS_AIVEN_API_URL"

    # Call the make_api_request function to list all projects
    response=$(make_api_request "$METHOD" "$URL")

    # Extract project names from the response
    PROJECT_NAMES=$(echo "$response" | jq -r '.projects')

    # Return the project names to the caller
    echo "$PROJECT_NAMES"  # Output the project names
}

# ************************** Capture and Print Project Names **************************
# Call the function and capture the project names
# PROJECT_NAMES=$(list_projects)

# Print the project names
# echo "Project Names: $PROJECT_NAMES"
