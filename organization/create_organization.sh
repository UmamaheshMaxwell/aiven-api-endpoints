#!/bin/bash

# Source the first script to access its functions
source read_env.sh
source constants.sh
source api.sh
source billing/get_billing_group.sh

# ************************** Get AIVEN_API_TOKEN **************************
AIVEN_API_TOKEN=$(get_mst_api_token)

# ************************** Get AIVEN_API_URL **************************
AIVEN_API_URL=$(get_aiven_api_url)


# ************************** Create Organization **************************
create_organization() {
    # Define request method and URL
    local METHOD="POST"
    local URL="$AIVEN_API_URL/organizations"

    # Define the JSON payload
    local ORGANIZATION_NAME="$1"  # First parameter: Organization name
    local BILLING_GROUP_ID="$2"   # Second parameter: Primary billing group ID
    local TIER="$3"               # Third parameter: Tier level

    # Construct the JSON payload using the cat <<EOF format
    local JSON_DATA=$(cat <<EOF
{
    "organization_name": "$ORGANIZATION_NAME",
    "primary_billing_group_id": "$BILLING_GROUP_ID",
    "tier": "$TIER"
}
EOF
    )

    # Call the make_api_request function to create the organization
    response=$(make_api_request "$METHOD" "$URL" "$JSON_DATA")

    # Return the complete response
    echo "$response"
    return 0 # Return 0 for success
}

# # ************************** Create Organization ***************************
# organization=$(create_organization "$ORGANIZATION_NAME" "$BILLING_GROUP_ID" "$TIER")
# # Print the organization_id to verify
# echo "Organization: $organization"
# # Extract the organization_id using jq
# organization_id=$(echo "$organization" | jq -r '.organization_id')
# # Print the organization_id to verify
# echo "Organization ID: $organization_id"