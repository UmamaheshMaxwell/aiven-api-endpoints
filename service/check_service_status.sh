#!/bin/bash

source service/get_service.sh

# Define the project and service names
PROJECT_NAME="main-sequence"  # Set this to your actual project name
SERVICE_NAME="ts-orm-service"  # Set this to your actual service name

# Function to check the status of a specific service within a project
check_service_status() {
    local PROJECT_NAME=$1      # First parameter: Project name
    local SERVICE_NAME=$2      # Second parameter: Service name

    # Fetch the services for the given project
    services_response=$(get_project_services "$PROJECT_NAME")

    # Check if the request was unsuccessful based on the error structure
    if echo "$services_response" | jq -e '.errors | length > 0' >/dev/null; then
        echo "Failed to fetch services for project $PROJECT_NAME: $(echo "$services_response" | jq -r '.errors[0].message')" >&2
        return 1 # Return 1 for failure
    fi

    # Extract and return the service state
    service_state=$(echo "$services_response" | jq -r --arg SERVICE_NAME "$SERVICE_NAME" '.services[] | select(.service_name == $SERVICE_NAME) | .state')
    echo "$service_state"
}

