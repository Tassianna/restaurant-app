output "haproxy_ip" {
    value = aws_instance.instance["haproxy_1"].public_ip
}
output "maintenance_ip" {
    value = aws_instance.instance["maintenance"].public_ip
}
output "auth_service_ip" {
    value = aws_instance.instance["auth_service"].private_ip
}
output "discounts_service_ip" {
    value = aws_instance.instance["discounts_service"].private_ip
}
output "items_service_ip" {
    value = aws_instance.instance["items_service"].private_ip
}
output "frontend_ip" {
    value = aws_instance.instance["client"].public_ip
}

#######backend services ids########
output "auth_service_id" {
    value = aws_instance.instance["auth_service"].id
}
output "discounts_service_id" {
    value = aws_instance.instance["discounts_service"].id
}
output "items_service_id" {
    value = aws_instance.instance["items_service"].id
}

# ELB do not have static IP adresses we cannot reliably 
# use an IP address to access an ELB
# However, the DNS name will always resolve to the current 
# set of IP addresses that are routing traffic through the ELB.
output "auth_elb_dns" {
  value = aws_elb.elb["auth-elb"].dns_name
}
output "items_elb_dns" {
  value = aws_elb.elb["items-elb"].dns_name
}
output "discounts_elb_dns" {
  value = aws_elb.elb["discounts-elb"].dns_name
}

#######ids of ELBs#######
output "discounts_elb_id" {
  value = aws_elb.elb["discounts-elb"].id
}
output "auth_elb_id" {
  value = aws_elb.elb["auth-elb"].id
}
output "items_elb_id" {
  value = aws_elb.elb["items-elb"].id
}

output "private_subnet_id" {
  value = aws_subnet.subnet["private_subnet"].id
}

output "private_security_group_id" {
  value = aws_security_group.security_group["private-security-group"].id
}