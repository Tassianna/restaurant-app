# ---------------------------- ansible playbooks explanation -----------------------------
restaurant-app
├── ansible
│   ├── main.yml               # Playbook to be executed on the maintenance instance
│   ├── hosts                  # Inventory for the maintenance instance
│   └── roles ...              # Other Ansible roles
└── ansible_maintenance
    ├── main.yml               # Playbook to run from your machine
    └── hosts                  # Inventory for the maintenance instance



# ----------------------- explanation of dynamic-inventory-script --------------------------

1. Installing jq, a JSON processor, if it is not already installed (supports Ubuntu/Debian and macOS).
2. Deploying infrastructure using Terraform by running terraform init, valide, plan and apply.
3. Extracting Terraform outputs (specifically IP addresses) for the deployed infrastructure.
4. Dynamically generating an Ansible inventory file (hosts) based on the IP addresses returned by Terraform. This inventory is used to configure remote machines with Ansible.
5. 
6. 



# -------docker compose--------

docker-compose build 

docker-compose up  

------frontend available------

http://localhost

# ------backend-services available------

http://localhost:3001/api/auth  

http://localhost:3002/api/discounts

http://localhost:3003/api/items 

# -------- Terraform -------------
run;
restaurant/terraform> terraform init
restaurant/terraform> terraform plan
restaurant/terraform> terraform apply

