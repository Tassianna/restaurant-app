#!/bin/bash

# In this step we install jq:
# jq is a lightweight and powerful command-line JSON processor 
# that is required to parse the JSON output from Terraform.
# What we do is to check if the jq is installed and if not
# installing it depending on the OS. We only added mac and linux os.

# Step 0: Check if jq is installed, and install if not
echo "Checking if jq is installed..."

if ! command -v jq &> /dev/null
then
    echo "jq not found, attempting to install..."

    # Detect the operating system and install jq accordingly
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # For Ubuntu/Debian-based systems
        echo "Detected Ubuntu/Debian-based Linux. Installing jq..."
        sudo apt-get update && sudo apt-get install -y jq

    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # For macOS
        echo "Detected macOS. Installing jq via Homebrew..."
        if ! command -v brew &> /dev/null
        then
            echo "Homebrew not found. Please install Homebrew first from https://brew.sh/"
            exit 1
        fi
        brew install jq

    else
        echo "Unsupported OS. Please install jq manually."
        exit 1
    fi
fi

# Step 1: Run Terraform apply to deploy resources and generate outputs
echo "Initializing Terraform..."
cd ./terraform || exit 1  # Ensure script stops if directory change fails
terraform init || exit 1  # Exit if init fails

echo "Validating Terraform configuration..."
terraform validate || exit 1  # Exit if validation fails

echo "Generating Terraform plan..."
terraform plan || exit 1  # Exit if planning fails

echo "Applying Terraform plan..."
terraform apply -auto-approve || exit 1  # Exit if apply fails


pwd
# Step 2:  Extract Terraform outputs
frontend_ip=$(terraform output -json frontend_ip | jq -r)
items_service_ip=$(terraform output -json items_service_ip | jq -r)
auth_service_ip=$(terraform output -json auth_service_ip | jq -r)
discounts_service_ip=$(terraform output -json discounts_service_ip | jq -r)
haproxy_ip=$(terraform output -json haproxy_ip | jq -r)
maintenance_ip=$(terraform output -json maintenance_ip | jq -r)


#Step 3: Generate Ansible inventory
cat > ../ansible/hosts <<EOF
[frontend]
frontend ansible_host=$frontend_ip port=3000 ansible_user=ubuntu ansible_ssh_private_key_file=/ubuntu/home/london_key.pem

[backend]
items ansible_host=$items_service_ip port=3003 ansible_user=ubuntu ansible_ssh_private_key_file=/ubuntu/home/london_key.pem
auth ansible_host=$auth_service_ip port=3001 ansible_user=ubuntu ansible_ssh_private_key_file=/ubuntu/home/london_key.pem
discounts ansible_host=$discounts_service_ip port=3002 ansible_user=ubuntu ansible_ssh_private_key_file=/ubuntu/home/london_key.pem

[haproxy]
haproxy ansible_host=$haproxy_ip ansible_user=ubuntu ansible_ssh_private_key_file=/ubuntu/home/london_key.pem
EOF

echo "Ansible inventory file created: hosts"

# Step 4: Generate Ansible inventory for maintenance
# TODO: instead of /Users/tassianna/Desktop/london_key.pem we can add a variable!
cat > ../ansible_maintenance/hosts <<EOF
[maintenance]
maintenance ansible_host=$maintenance_ip ansible_user=ubuntu ansible_ssh_private_key_file=/Users/tassianna/Desktop/london_key.pem
EOF

echo "Ansible_maintenance inventory file created: hosts"

# Step 5: Run ansible_maintenance playbook

# go back to restaurant-app folder
cd ..
cd ansible_maintenance
ansible-playbook -i hosts main.yml

