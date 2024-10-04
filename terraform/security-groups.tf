
resource "aws_security_group" "security_group" {
    for_each = var.security_groups

    name = each.key
    description = each.value.desc
    vpc_id = aws_vpc.vpc.id

    dynamic "ingress" {
        for_each = each.value.ingress

        content {
          from_port = ingress.value.from_port
          to_port = ingress.value.to_port
          protocol = ingress.value.protocol
          cidr_blocks = [ingress.value.cidr_blocks == true ? "0.0.0.0:/0" : aws_subnet.subnet["public_subnet"].cidr_block ]
        }
    }

    dynamic "egress" {
        for_each = each.value.egress

        content {
          from_port = egress.value.from_port
          to_port = egress.value.to_port
          protocol = egress.value.protocol
          cidr_blocks = ["0.0.0.0/0"]
        }
    }


}
