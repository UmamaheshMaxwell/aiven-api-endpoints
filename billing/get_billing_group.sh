#!/bin/bash

# Source the first script to access its functions
source read_env.sh
source api.sh

# ************************** Get AIVEN_API_TOKEN **************************
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Get AIVEN_API_URL **************************
AIVEN_API_URL=$(get_aiven_api_url)

# ************************** Define API URL for Billing Groups **************************
BILLING_GROUP_AIVEN_API_URL="$AIVEN_API_URL/billing-group"

# ************************** Get Billing Group Details **************************
get_billing_group() {
    # Define request method and URL
    local METHOD="GET"
    local URL="$BILLING_GROUP_AIVEN_API_URL"

    # Call the make_api_request function to fetch billing groups
    response=$(make_api_request "$METHOD" "$URL")

    # Check if the request was unsuccessful based on the error structure
    if echo "$response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "Failed to fetch billing groups: $(echo "$response" | jq -r '.errors[0].message')"
        return 1 # Return 1 for failure
    fi

    # Print the response if successful
    echo "$response"
    return 0 # Return 0 for success
}

# ************************** Example Call **************************
# Fetch and display billing group details
#echo "Fetching billing group details..."
#get_billing_group

