#!/bin/bash
cd ./scaling-terraform
terraform destroy -var="private_security_group_id=sg-03b8ff2ef99c86b88" -var="private_subnet_id=subnet-0ca735d3873fec11c"
cd ..
cd ./terraform
terraform destroy --auto-approve
