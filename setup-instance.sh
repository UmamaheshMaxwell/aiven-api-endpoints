#!/bin/bash

source read_env.sh
source constants.sh
source project/create_project.sh
source service/create_service.sh
source service/check_service_status.sh
source database/create_database.sh
source project/add_project_group.sh
source organization/create_group.sh
source vpc/create_vpc_peering.sh

 

# ************************** Get AIVEN_API_TOKEN **************************
AIVEN_API_TOKEN=$(get_mst_api_token)
#echo "The captured AIVEN_API_TOKEN is: $AIVEN_API_TOKEN"

# ************************** Get BILLING_GROUP_ID **************************
# Now you can access the BILLING_GROUP_ID constant
echo "The Billing Group ID is: $BILLING_GROUP_ID"

# # ************************** Create Project **************************

create_project "$ACCOUNT_ID" "$CLOUD_PROVIDER" "$PROJECT_NAME" "$BASE_PORT" "$BILLING_GROUP_ID" "$TAGS" 
echo "Project $PROJECT_NAME created"

# ************************** Create Service within a Project **************************

# ************************** Environment Configurations **************************
declare -A environments=(
  ["Production"]="ts-orm-production"
  ["Staging"]="ts-orm-staging"
  ["Development"]="ts-orm-development"
)

# ************************** Loop Through Environments **************************
for ENV in "${!environments[@]}"; do
    SERVICE_NAME="${environments[$ENV]}"
    TAGS="{\"env\": \"${ENV,,}\", \"db\": \"timescale\"}" # env in lowercase

    echo "************************** Creating Service for $ENV **************************"
    
    # Call the function to create the service
    create_project_service "$PROJECT_NAME" "$CLOUD_PROVIDER" "$COPY_TAGS" "$MAINTENANCE_DOW" "$MAINTENANCE_TIME" "$PLAN" "$SERVICE_NAME" "$SERVICE_TYPE" "$TAGS" "$TERMINATION_PROTECTION"

    # ************************** Wait for Service to be Ready **************************
    echo "Waiting for the $ENV service to be up and running..."
    while true; do
        service_status=$(check_service_status "$PROJECT_NAME" "$SERVICE_NAME")
        if [[ "$service_status" == "RUNNING" ]]; then
            echo "$ENV service is running. Proceeding with database creation..."
            break
        else
            echo "$ENV service is not yet running. Retrying in 30 seconds..."
            sleep 30
        fi
    done

    # ************************** Create Database within the Service **************************
    echo "************************** Creating Database in $ENV **************************"
    
    # Call the function to create the database
    create_database "$PROJECT_NAME" "$SERVICE_NAME" "$DATABASE_NAME" "$LC_COLLATE" "$LC_CTYPE"
done

# ************************** Create User Groups         *****************************
# ************************** Environment Configurations *****************************
declare -A environments=(
  ["Production"]="main-sequence-prod"
  ["Staging"]="main-sequence-stg"
  ["Development"]="main-sequence-dev"
)

# ************************** Loop Through Environments **************************
for ENV in "${!environments[@]}"; do
    USER_GROUP_NAME="${environments[$ENV]}"
    DESCRIPTION="User group for the ${ENV} Team with access to project resources and tools"

    echo "************************** Creating User Group for $ENV **************************"
    
    # Call the function to create the user group and store the complete response
    response=$(create_user_group "$ORGANIZATION_ID" "$DESCRIPTION" "$USER_GROUP_NAME")
    echo "$response"
    
    # Extract the User Group ID from the response
    GROUP_ID=$(echo "$response" | jq -r '.user_group_id')
    echo "Extracted Group ID: $GROUP_ID"

    # ************************** Add User Group to Project with Role **************************
    echo "************************** Adding User Group to Project for $ENV **************************"

    # Call the function to add the user group to the project
    add_user_group_to_project "$ORGANIZATION_ID" "$PROJECT_NAME" "$GROUP_ID" "$ROLE"
done

# ************************** Create VPC within a Project **************************
vpc=$(create_vpc "$PROJECT_NAME" "$CLOUD_NAME" "$NETWORK_CIDR")
echo "$vpc"
