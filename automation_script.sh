#!/bin/bash

# Load the .env file
export $(grep -v '^#' .env | xargs)

# In this step we install jq:
# jq is a lightweight and powerful command-line JSON processor 
# that is required to parse the JSON output from Terraform.
# What we do is to check if the jq is installed and if not
# installing it depending on the OS. We only added mac and linux os.

echo "#"
echo "#"
echo "#"
echo "# Step 0: Check if jq is installed, and install if not"
echo "#"
echo "#"
echo "#" 
echo "# Checking if jq is installed..."

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

echo "#"
echo "#"
echo "#"
echo "# Step 1: Run Terraform apply to deploy resources and generate outputs"
echo "#"
echo "#"
echo "#" 
echo "# Initializing Terraform..."
cd ./terraform || exit 1  # Ensure script stops if directory change fails
terraform init || exit 1  # Exit if init fails

echo "Validating Terraform configuration..."
terraform validate || exit 1  # Exit if validation fails

echo "Generating Terraform plan..."
terraform plan || exit 1  # Exit if planning fails

echo "Applying Terraform plan..."
terraform apply -auto-approve || exit 1  # Exit if apply fails

echo "#"
echo "#"
echo "#"
echo "# Step 2:  Extract Terraform outputs to inject into new hosts file after cloning repository"
echo "#"
echo "#"
echo "#" 
pwd
frontend_ip=$(terraform output -json frontend_ip | jq -r)
items_service_ip=$(terraform output -json items_service_ip | jq -r)
auth_service_ip=$(terraform output -json auth_service_ip | jq -r)
discounts_service_ip=$(terraform output -json discounts_service_ip | jq -r)
haproxy_ip=$(terraform output -json haproxy_ip | jq -r)
maintenance_ip=$(terraform output -json maintenance_ip | jq -r)

auth_service_id=$(terraform output -json auth_service_id | jq -r)
items_service_id=$(terraform output -json items_service_id | jq -r)
discounts_service_id=$(terraform output -json discounts_service_id | jq -r)

auth_elb_dns=$(terraform output -json auth_elb_dns | jq -r)
discounts_elb_dns=$(terraform output -json discounts_elb_dns | jq -r)
items_elb_dns=$(terraform output -json items_elb_dns | jq -r)

auth_elb_id=$(terraform output -json auth_elb_id | jq -r)
discounts_elb_id=$(terraform output -json discounts_elb_id | jq -r)
items_elb_id=$(terraform output -json items_elb_id | jq -r)

private_subnet_id=$(terraform output -json private_subnet_id | jq -r)
private_security_group_id=$(terraform output -json private_security_group_id | jq -r)

echo "#"
echo "#"
echo "#"
echo "# Step 3: Generate Ansible inventory for Maintenance"
echo "#"
echo "#"
echo "#" 

cat > ../ansible_maintenance/hosts <<EOF
[maintenance]
maintenance ansible_host=$maintenance_ip ansible_user=ubuntu ansible_ssh_private_key_file=$LOCAL_KEY
EOF

echo "# Ansible_maintenance inventory file created: hosts"

echo "#"
echo "#"
echo "#"
echo "# Step 4: Run ansible_maintenance playbook"
echo "#"
echo "#"
echo "#" 
sleep 30  
# go back to restaurant-app folder
cd ..
cd ansible_maintenance
pwd
ansible-playbook -i hosts main.yml --extra-vars "local_key=$LOCAL_KEY frontend=$frontend_ip items=$items_service_ip auth=$auth_service_ip discounts=$discounts_service_ip haproxy=$haproxy_ip auth_elb=$auth_elb_dns discounts_elb=$discounts_elb_dns items_elb=$items_elb_dns"

echo "#"
echo "#"
echo "#"
echo "# Step 5: Run ansible playbook from maintenance ec2 instance"
echo "#"
echo "#"
echo "#" 

ssh -i $LOCAL_KEY ubuntu@$maintenance_ip /bin/bash  << EOF
cd /home/ubuntu/restaurant-app
pwd
cat ./ansible/hosts
cd ansible
ansible-playbook -i hosts main.yml 
exit
EOF

echo "#"
echo "#"
echo "#"
echo "# Step 6: Run Terraform apply in scaling terraform to deploy images, autoscaling groups, policies, alarms and logs"
echo "#"
echo "#"
echo "#" 
echo "# Initializing Second Terraform..."


cd ..
cd ./scaling-terraform || exit 1  # Ensure script stops if directory change fails
terraform init \
  -var="private_security_group_id=$private_security_group_id" \
  -var="private_subnet_id=$private_subnet_id" \
  -var="scaling_groups={\"items\":{\"loadbalancer\":\"$items_elb_id\", \"template\":\"items_ami_template\"},\"discounts\":{\"loadbalancer\":\"$discounts_elb_id\", \"template\":\"discounts_ami_template\"}, \"auth\":{\"loadbalancer\":\"$auth_elb_id\", \"template\":\"auth_ami_template\"}}" \
  -var="images={\"items\":{\"name\":\"items_ami\",\"source_instance_id\":\"$items_service_id\"}, \"auth\":{\"name\":\"auth_ami\", \"source_instance_id\":\"$auth_service_id\"}, \"discounts\":{\"name\":\"discounts_ami\", \"source_instance_id\":\"$discounts_service_id\"}}" \
  || exit 1  # Exit if init fails

echo "Validating Terraform configuration..."
terraform validate || exit 1  # Exit if validation fails

echo "Generating Terraform plan..."
terraform plan \
  -var="private_security_group_id=$private_security_group_id" \
  -var="private_subnet_id=$private_subnet_id" \
  -var="scaling_groups={\"items\":{\"loadbalancer\":\"$items_elb_id\", \"template\":\"items_ami_template\"},\"discounts\":{\"loadbalancer\":\"$discounts_elb_id\", \"template\":\"discounts_ami_template\"}, \"auth\":{\"loadbalancer\":\"$auth_elb_id\", \"template\":\"auth_ami_template\"}}" \
  -var="images={\"items\":{\"name\":\"items_ami\",\"source_instance_id\":\"$items_service_id\"}, \"auth\":{\"name\":\"auth_ami\", \"source_instance_id\":\"$auth_service_id\"}, \"discounts\":{\"name\":\"discounts_ami\", \"source_instance_id\":\"$discounts_service_id\"}}" \
  || exit 1  # Exit if planning fails

echo "Applying Terraform plan..."
terraform apply -auto-approve \
  -var="private_security_group_id=$private_security_group_id" \
  -var="private_subnet_id=$private_subnet_id" \
  -var="scaling_groups={\"items\":{\"loadbalancer\":\"$items_elb_id\", \"template\":\"items_ami_template\"},\"discounts\":{\"loadbalancer\":\"$discounts_elb_id\", \"template\":\"discounts_ami_template\"}, \"auth\":{\"loadbalancer\":\"$auth_elb_id\", \"template\":\"auth_ami_template\"}}" \
  -var="images={\"items\":{\"name\":\"items_ami\",\"source_instance_id\":\"$items_service_id\"}, \"auth\":{\"name\":\"auth_ami\", \"source_instance_id\":\"$auth_service_id\"}, \"discounts\":{\"name\":\"discounts_ami\", \"source_instance_id\":\"$discounts_service_id\"}}" \
  || exit 1 # Exit if apply fails


cd ..
cd terraform
terraform destroy aws_instance.items_service  -auto-approve
terraform destroy aws_instance.auth_service  -auto-approve
terraform destroy aws_instance.discounts_service  -auto-approve
