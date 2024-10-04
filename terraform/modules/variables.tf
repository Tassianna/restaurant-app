# definition of variables to be used in resources and modules

variable "cidr_block" {
    type = string
}

variable "vpc_name"{
    type = string
}

variable "subnets"{
    type = map(object({
    cidr_block = string

    map_public_ip_on_launch = bool

    availability_zone = string
  }))
}

###################this is how the subnets should look like:#########################
###subnets = {
#  public_subnet = {

#    cidr_block = "10.0.1.0/24"

#    map_public_ip_on_launch = true

#    availability_zone = "eu-west-2a"

#  }

#  private_subnet = {

#    cidr_block = "10.0.2.0/24"

#    map_public_ip_on_launch = false

#    availability_zone = "eu-west-2b"
#  }
#}

variable "security_groups" {
    type = map(object({
        desc = string
        vpc_id = string
        ingress = map(object({
            description = string
            from_port = number
            to_port = number
            protocol = string
            cidr_blocks = list(string)
        }))
        egress = map(object({
            description = string
            from_port = number
            to_port = number
            protocol = string
            cidr_blocks = list(string)
        }))
    }))
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