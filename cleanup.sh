# Define a function for the Aiven client command
avn() {
    python -m aiven.client "$@"
}

# Organization ID
ORG_ID="org4d0fade9534"

# Project name
PROJECT="main-sequence-hub"

# ************************** Services *****************************
avn service terminate ts-orm-development --project  main-sequence-hub --force
avn service terminate ts-orm-staging     --project  main-sequence-hub --force
avn service terminate ts-orm-production  --project  main-sequence-hub --force


# ************************** GROUPS ********************************
# Save the command output to a file
avn organization group list --organization-id "$ORG_ID" > groups.txt

# Extract USER_GROUP_ID values, skip header and unwanted lines, and store them in a variable
GROUP_IDS=$(awk '$2 !~ /^=/ && $2 !~ /USER_GROUP_ID/ {print $2}' groups.txt)

# Loop through each group ID and delete the group
for GROUP_ID in $GROUP_IDS; do
    echo "Deleting group with ID: $GROUP_ID"
    avn organization group delete "$GROUP_ID" --organization-id "$ORG_ID" --force
    
    # Check if the delete command was successful
    if [ $? -eq 0 ]; then
        echo "Successfully deleted group with ID: $GROUP_ID"
    else
        echo "Failed to delete group with ID: $GROUP_ID" >&2
    fi
done


# ************************** PROJECT *******************************
avn project delete main-sequence-hub