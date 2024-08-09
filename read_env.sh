#!/bin/bash

# ************************** Source Environment Variables **************************
if [ -f .env ]; then
    source .env
else
    echo ".env file not found"
    exit 1
fi

# ************************** Get MST_API_TOKEN Function **************************
get_mst_api_token() {
    if [ -n "$AIVEN_API_TOKEN" ]; then
        echo "$AIVEN_API_TOKEN" # Output the token
        return 0 # Return 0 for success
    else
        echo "AIVEN_API_TOKEN is not set in the .env file."
        return 1 # Return 1 for error
    fi
}

# ************************** Get AIVEN_API_URL Function **************************
get_aiven_api_url() {
    if [ -n "$AIVEN_API_URL" ]; then
        echo "$AIVEN_API_URL" # Output the URL
        return 0 # Return 0 for success
    else
        echo "AIVEN_API_URL is not set in the .env file."
        return 1 # Return 1 for error
    fi
}
