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
    value = aws_instance.instance["client"].private_ip
}