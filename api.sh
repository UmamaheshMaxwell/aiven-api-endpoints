# ************************** General Function to Make API Requests **************************
make_api_request() {
    local METHOD=$1        # Request method: GET or POST
    local URL=$2           # API endpoint URL
    local DATA=$3          # JSON data for POST requests (optional)

    # Set the appropriate curl options based on the request method
    if [ "$METHOD" == "POST" ]; then
        response=$(curl -s --request POST \
            --url "$URL" \
            --header "Authorization: Bearer $AIVEN_API_TOKEN" \
            --header 'Content-Type: application/json' \
            --data "$DATA")
    elif [ "$METHOD" == "GET" ]; then
        response=$(curl -s --request GET \
            --url "$URL" \
            --header "Authorization: Bearer $AIVEN_API_TOKEN")
    else
        echo "Unsupported request method: $METHOD"
        return 1 # Return 1 for error
    fi

    # Check for errors in the response
    if echo "$response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "API request failed: $(echo "$response" | jq -r '.errors[0].message')"
        return 1 # Return 1 for error
    fi

    # Output the response
    echo "$response"
    return 0 # Return 0 for success
}