#!/bin/bash

source read_env.sh  
source account/get_account.sh
source billing/get_billing_group.sh
source project/create_project.sh
source service/create_service.sh
source service/check_service_status.sh
source database/create_database.sh
source organization/create_group.sh
source organization/add_project_group.sh
 

# ************************** Get AIVEN_API_TOKEN **************************
# Get AIVEN_API_TOKEN
AIVEN_API_TOKEN=$(get_mst_api_token)
#echo "The captured AIVEN_API_TOKEN is: $AIVEN_API_TOKEN"

# ************************** Get Account ID **************************
# Call get_account function and capture the full JSON response
account_response=$(get_account)
# Extract account_id using jq
account_id=$(echo "$account_response" | jq -r '.accounts[0].account_id')
# Now you can use the account_id variable
echo "The captured account_id is: $account_id"

# ************************** Get Billing Group ID **************************
# Call the function and store the full response in a variable
billing_group_response=$(get_billing_group)
# Extract the billing_group_id from the full response
billing_group_id=$(echo "$billing_group_response" | jq -r '.billing_groups[0].billing_group_id')
# Now you can use the billing_group_id variable
echo "The captured billing_group_id is: $billing_group_id"

# ************************** Create Project **************************
# Define the input values
ACCOUNT_ID=$account_id
CLOUD_PROVIDER="google-europe-west1"
PROJECT_NAME="main-sequence"
BASE_PORT=15000
BILLING_GROUP_ID=$billing_group_id
TAGS='{"env": "dev", "db": "timescale"}'

# Call the function with the named variables
create_project "$ACCOUNT_ID" "$CLOUD_PROVIDER" "$PROJECT_NAME" "$BASE_PORT" "$BILLING_GROUP_ID" "$TAGS" 

# ************************** Create Service within a Project **************************
# Define the input values
PROJECT_NAME="main-sequence"
CLOUD_PROVIDER="timescale-google-europe-west1"
COPY_TAGS=true
MAINTENANCE_DOW="monday"
MAINTENANCE_TIME="10:00:00"
PLAN="timescale-dev-only"
SERVICE_NAME="ts-orm-service"
SERVICE_TYPE="pg"
TAGS='{"env": "dev", "db": "timescale"}'
TERMINATION_PROTECTION=false # should be set to true, for real deployment

# Call the function with the named variables
create_project_service "$PROJECT_NAME" "$CLOUD_PROVIDER" "$COPY_TAGS" "$MAINTENANCE_DOW" "$MAINTENANCE_TIME" "$PLAN" "$SERVICE_NAME" "$SERVICE_TYPE" "$TAGS" "$TERMINATION_PROTECTION"

# ************************** Wait for Service to be Ready **************************
echo "Waiting for the service to be up and running..."
while true; do
    service_status=$(check_service_status "$PROJECT_NAME" "$SERVICE_NAME")
    if [[ "$service_status" == "RUNNING" ]]; then
        echo "Service is running. Proceeding with database creation..."
        break
    else
        echo "Service is not yet running. Retrying in 30 seconds..."
        sleep 30
    fi
done

# ************************** Create Database within a Service **************************
# Define the input values
PROJECT_NAME="main-sequence"
SERVICE_NAME="ts-orm-service"
DATABASE_NAME="TimescaleDB"
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"

# Call the function with the named variables
create_database "$PROJECT_NAME" "$SERVICE_NAME" "$DATABASE_NAME" "$LC_COLLATE" "$LC_CTYPE"


# ************************** Create User Group and Extract ID **************************
# Define the input values
ORGANIZATION_ID="org4d0fade9534"
DESCRIPTION="User group for the Development Team with access to project resources and tools"
USER_GROUP_NAME="main-sequence-dev"

# Call the function and store the complete response
response=$(create_user_group "$ORGANIZATION_ID" "$DESCRIPTION" "$USER_GROUP_NAME")
GROUP_ID=$(echo "$response" | jq -r '.user_group_id')
echo "$GROUP_ID"


# ************************** Add User Group to Project with Role **************************
# Define the input values
ORG_ID="org4d0fade9534"  # Replace with the actual organization ID
PROJECT_NAME="main-sequence"
GROUP_ID="$GROUP_ID"
ROLE="developer"  # Available roles: admin, operator, developer, read_only

# Call the function with the named variables
add_user_group_to_project "$ORG_ID" "$PROJECT_NAME" "$GROUP_ID" "$ROLE"