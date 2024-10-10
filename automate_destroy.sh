#!/bin/bash
cd ./scaling-terraform
terraform destroy -var="private_security_group_id=sg-0ef4909f84a1181eb" -var="private_subnet_id=subnet-02a97bb86b4765e85"
cd ..
cd ./terraform
terraform destroy --auto-approve
