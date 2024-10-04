resource "aws_instance" "instance" {
  ami                         = var.ami_image
  instance_type               = var.instance_type
  key_name                    = var.key_name
  availability_zone           = each.value.availability_zone
  vpc_security_group_ids      = [each.value.vpc_security_group == true ? aws_security_group.public_security_group.id : aws_security_group.private_security_group.id]
  subnet_id                   = aws_subnet.subnet[each.value.subnet].id
  associate_public_ip_address = each.value.associate_public_ip_address

  tags = {
    Name = each.key
  }
  for_each = var.instances
}