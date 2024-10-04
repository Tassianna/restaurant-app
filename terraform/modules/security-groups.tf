
resource "aws_security_group" "security_group" {
    for_each = var.security_groups

    name = each.key
    description = each.value.desc
    vpc_id = aws_vpc.vpc.id

    dynamic "ingress" {
        for_each = each.value.ingress

        content {
          description = ingress.key
          from_port = ingress.value.from_port
          to_port = ingress.value.to_port
          protocol = ingress.value.protocol
          cidr_blocks = ingress.value.cidr_blocks
        }
    }

    dynamic "egress" {
        for_each = each.value.egress

        content {
          description = egress.key
          from_port = egress.value.from_port
          to_port = egress.value.to_port
          protocol = egress.value.protocol
          cidr_blocks = egress.value.cidr_blocks
        }
    }


}


/**
    # security groups
    security_groups = {
      public-security-group = {
        desc = "security group for public subnet"
        vpc_id = aws_vpc.vpc.id
        ingress = {
            allow_http_traffic = {
                from_port   = 80
                to_port     = 80
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }

            allow_ssh_traffic = {
                from_port   = 22
                to_port     = 22
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }

            allow_https_traffic = {
                from_port   = 443
                to_port     = 443
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }
        }

        egress = {
            cidr_blocks = ["0.0.0.0/0"]
            from_port   = 0
            protocol    = "-1"
            to_port     = 0
        }
      }

      private-security-group = {
        desc = "security group for public subnet"
        vpc_id = aws_vpc.vpc.id
        ingress = {
            allow_ssh_traffic = {
                cidr_blocks = [aws_subnet.subnet["public_subnet"].cidr_block]
                from_port   = 22
                protocol    = "tcp"
                to_port     = 22
            }
        }

        egress = {
            cidr_blocks = ["0.0.0.0/0"]
            from_port   = 0
            protocol    = "-1"
            to_port     = 0
        }
      }
    }

*/
