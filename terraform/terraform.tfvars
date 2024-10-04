
cidr_block = "10.0.0.0/16"
vpc_name = "Tassi & Graces Project VPC"

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
    desc = "security group for public subnet"
    ingress = {
      allow_http_traffic = {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = true
      }

      allow_ssh_traffic = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = true
      }

      allow_https_traffic = {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = true
      }
    }
  }

  private-security-group = {
    desc = "security group for public subnet"
    ingress = {
      allow_ssh_traffic = {
        cidr_blocks = false
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22
      }
    }
  }
}

route-tables = {
  public_route_table = {
    cidr_block = "0.0.0.0/0"
    gateway_id = true
  }
  private_route_table = {
    cidr_block = "0.0.0.0/0"
    gateway_id = false
  }
}

route-associations = {
  public-association = true
  private-association = false
}