#!/bin/bash
cd ./scaling-terraform
terraform destroy -var="private_security_group_id=sg-0dc5678dadc2b69eb" -var="private_subnet_id=subnet-0870a6817ee794ecb"
cd ..
cd ./terraform
terraform destroy --auto-approve
