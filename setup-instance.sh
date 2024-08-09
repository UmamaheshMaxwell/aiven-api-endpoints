# Source the first script to access its functions
source read_env.sh  
source account/get_account.sh
source billing/get_billing_group.sh
source project/create_project.sh
source service/create_service.sh

# ************************** Get AIVEN_API_TOKEN **************************
# get AIVEN_API_TOKEN
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
PROJECT_NAME="devops-with-kube"
BASE_PORT=15000
BILLING_GROUP_ID=$billing_group_id
TAGS='{"env": "dev", "db": "timescale"}'

# Call the function with the named variables
create_project "$ACCOUNT_ID" "$CLOUD_PROVIDER" "$PROJECT_NAME" "$BASE_PORT" "$BILLING_GROUP_ID" "$TAGS" 

# ************************** Create Project Service **************************
# Define the input values
PROJECT_NAME="devops-with-kube"
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
