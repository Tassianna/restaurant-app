
resource "aws_security_group" "security_group" {
  for_each = var.security_groups

  name        = each.key
  description = each.value.desc
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = [
        ingress.value.cidr_blocks == "all" ? "0.0.0.0/0" : ingress.value.cidr_blocks == "public" ? aws_subnet.subnet["public_subnet"].cidr_block: aws_subnet.subnet["private_subnet"].cidr_block
      ]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
