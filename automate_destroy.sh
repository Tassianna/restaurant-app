#!/bin/bash
cd ./scaling-terraform
terraform destroy -var="private_security_group_id=sg-02e3c5aef4364612f" -var="private_subnet_id=subnet-0ac1bf52c87a64210"
cd ..
cd ./terraform
terraform destroy --auto-approve
