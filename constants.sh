# ************************* BILLING GROUP ID *************************
BILLING_GROUP_ID="1c18fa5a-5d03-440c-9f5d-648f38fb6432"

# ************************* ORGANIZATION *****************************
ORGANIZATION_ID="org4d0fade9534"
# ORGANIZATION_NAME="main-sequence"
# TIER="business"

# ************************* ACCOUNT *****************************
ACCOUNT_ID="a4d0fadcd2fe"

# ************************* PROJECT *****************************
CLOUD_PROVIDER="timescale-google-europe-west1"
PROJECT_NAME="main-sequence-hub"
BASE_PORT=15000
TAGS='{"env": "multi", "purpose": "all-environments"}'

# ************************* SERVICE **************************
CLOUD_PROVIDER="timescale-google-europe-west1"
COPY_TAGS=true
MAINTENANCE_DOW="monday"
MAINTENANCE_TIME="10:00:00"
PLAN="timescale-dev-only"
SERVICE_TYPE="pg"
DATABASE_NAME="timeseries"
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
TERMINATION_PROTECTION=false # should be set to true, for real deployment

# ***************************** GROUP ********************************
ROLE="developer"  # Available roles: admin, operator, developer, read_only

# ***************************** VPC ***********************************
CLOUD_NAME="timescale-google-europe-west1"
NETWORK_CIDR="10.0.0.0/24"