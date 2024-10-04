subnets = {
  public_subnet = {

    cidr_block = "10.0.1.0/24"

    map_public_ip_on_launch = true

    availability_zone = "eu-west-2a"

  }

  private_subnet = {

    cidr_block = "10.0.2.0/24"

    map_public_ip_on_launch = false

    availability_zone = "eu-west-2b"
  }
}

security_groups = {
  public-security-group = {
    desc   = "security group for public subnet"
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
    desc   = "security group for public subnet"
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

route-tables = {
  public_route_table = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  private_route_table = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ngw.id
  }
}

route-associations = {
  public-association = {
    subnet_id      = aws_subnet.subnet["public_subnet"].id
    route_table_id = aws_route_table.route_table["public_route_table"].id
  }
  private-association = {
    subnet_id      = aws_subnet.subnet["private_subnet"].id
    route_table_id = aws_route_table.route_table["private_route_table"].id
  }
}



###################################EC2#####################################

instances = {

    frontend = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        subnet                      = "public_subnet"
        associate_public_ip_address = true
    }

    auth_service = {
        availability_zone           = "eu-west-2b"
        vpc_security_group          = false
        subnet                      = "private_subnet"
        associate_public_ip_address = false
    }

    discounts_service = {
        availability_zone           = "eu-west-2b"
        vpc_security_group          = false
        subnet                      = "private_subnet"
        associate_public_ip_address = false
    }

    items_service = {
        availability_zone           = "eu-west-2b"
        vpc_security_group          = false
        subnet                      = "private_subnet"
        associate_public_ip_address = false
    }

    haproxy_1 = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        subnet                      = "public_subnet"
        associate_public_ip_address = true
    }
    
    haproxy_2 = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        subnet                      = "public_subnet"
        associate_public_ip_address = true
    }
    
    lb = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        subnet                      = "public_subnet"
        associate_public_ip_address = true
    }
}

ami_image     = "ami-01ec84b284795cbc7"
instance_type = "t2.micro"
key_name      = "london_key"
