#!/bin/bash

# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Get AIVEN_API_URL **************************
AIVEN_API_URL=$(get_aiven_api_url)

# ************************** Define API URL for Account **************************
ACCOUNT_AIVEN_API_URL="$AIVEN_API_URL/account"

# ************************** Get Account Details **************************
get_account() {
    # Define request method and URL
    local METHOD="GET"
    local URL="$ACCOUNT_AIVEN_API_URL"

    # Call the make_api_request function to fetch account details
    response=$(make_api_request "$METHOD" "$URL")

    # Check if the request was unsuccessful based on the error structure
    if echo "$response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "Failed to fetch account details: $(echo "$response" | jq -r '.errors[0].message')" >&2
        return 1 # Return 1 for failure
    fi

    # Simply return the full account details JSON
    echo "$response"
    return 0 # Return 0 for success
}

# ************************** Example Call **************************
# Fetch and display account details
#echo "Fetching account details..."
#get_account
