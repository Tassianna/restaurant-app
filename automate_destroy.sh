#!/bin/bash
cd ./scaling-terraform
terraform destroy -var="private_security_group_id=sg-0ff3677c8614843c7" -var="private_subnet_id=subnet-02540f85aebec193e"
cd ..
cd ./terraform
terraform destroy --auto-approve
