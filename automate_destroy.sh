#!/bin/bash
cd ./scaling-terraform
terraform destroy -var="private_security_group_id=sg-0e48bd21890d87039" -var="private_subnet_id=subnet-0304b8ffc17063fbe"
cd ..
cd ./terraform
terraform destroy --auto-approve
