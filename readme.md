Here’s a `README.md` file to help anyone set up, run, and clean up your project using the provided scripts:

```markdown
# Project Setup and Cleanup Guide

This guide provides step-by-step instructions on how to set up, run, and clean up your project using the provided Bash scripts.

## Prerequisites

1. **Environment Variables**: Ensure you have a `.env` file in your project root that contains the necessary environment variables such as `API_URL` and `API_KEY`.
2. **Required Tools**: Make sure `jq` is installed on your system. This tool is used to parse JSON responses.

## Setup Steps

### 1. Configure Environment Variables

Create a `.env` file with the following variables:

```bash
API_URL=<your_api_url>
API_KEY=<your_api_key>
```

### 2. Load Environment Variables

The `read_env.sh` script is used to load environment variables from the `.env` file. This script is automatically sourced in `setup-instance.sh`.

### 3. Define Constants

The `constants.sh` script contains all hardcoded values used throughout the setup process. Review and update this file as necessary before proceeding.

### 4. Run the Setup Script

The `setup-instance.sh` script will perform the following actions:

- Create a project in Aiven.
- Set up services for three environments: Production, Staging, and Development.
- Create databases within each service.
- Create and assign user groups to each environment.
- Set up VPC peering.

To run the setup script, use the following command:

```bash
./setup-instance.sh
```

### 5. Script Details

The `setup-instance.sh` script performs the following steps:

1. **Get AIVEN_API_TOKEN**:
    - Retrieves the Aiven API token using `get_mst_api_token`.

2. **Get BILLING_GROUP_ID**:
    - Echoes the billing group ID from the constants.

3. **Create Project**:
    - Calls `create_project.sh` to create a project in Aiven.

4. **Create Services**:
    - Loops through the environments (Production, Staging, Development) and calls `create_service.sh` to create services within the project.
    - Waits for each service to be up and running before proceeding.

5. **Create Databases**:
    - Calls `create_database.sh` to create a database within each service.

6. **Create User Groups**:
    - Loops through the environments and creates a user group for each environment.
    - Calls `add_project_group.sh` to add the user group to the project with the appropriate role.

7. **Create VPC**:
    - Calls `create_vpc_peering.sh` to set up VPC peering within the project.

### 6. Cleanup

To clean up all the resources created by the setup script, run the `cleanup.sh` script:

```bash
./cleanup.sh
```

This script will delete all the resources including projects, services, databases, and user groups.

## Additional Information

- **Scripts Overview**:
    - `read_env.sh`: Reads environment variables from the `.env` file.
    - `constants.sh`: Contains hardcoded values used throughout the setup process.
    - `create_project.sh`: Creates a project in Aiven.
    - `create_service.sh`: Creates a service within the project.
    - `check_service_status.sh`: Checks the status of a service.
    - `create_database.sh`: Creates a database within the service.
    - `add_project_group.sh`: Adds a user group to the project.
    - `create_group.sh`: Creates a user group.
    - `create_vpc_peering.sh`: Sets up VPC peering within the project.
    - `cleanup.sh`: Cleans up all resources created during the setup.

- **Error Handling**:
    - Each script includes error handling to ensure smooth execution. If any step fails, the script will output an error message and stop execution.

- **Customization**:
    - You can customize the environment configurations and other parameters in the `constants.sh` and `setup-instance.sh` scripts to match your project needs.

## Conclusion

Follow these steps to set up and clean up your project efficiently. If you encounter any issues, review the logs output by each script to troubleshoot.
```

This `README.md` provides clear and detailed instructions for setting up, running, and cleaning up the project using your scripts.