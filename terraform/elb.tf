resource "aws_elb" "elb" {
  name = each.key
  security_groups = [
    aws_security_group.elb_sg[each.value.security_groups].id
  ]
  subnets = [
    aws_subnet.subnet[each.value.subnets].id,
   
  ]
  cross_zone_load_balancing   = each.value.cross_zone_load_balancing

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${each.value.port}${each.value.path}" #http:3001/api/auth
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = each.value.port
    instance_protocol = "http"
  }
  for_each = var.elbs
}


# Creating Security Group for ELB
resource "aws_security_group" "elb_sg" {
  name        = each.key
  description = each.value.desc
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = [aws_subnet.subnet["public_subnet"].cidr_block]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  for_each = var.elb_sg
}

resource "aws_proxy_protocol_policy" "proxy_http" {
  for_each = aws_elb.elb

  load_balancer  = each.value.name
  instance_ports = ["80"]
}