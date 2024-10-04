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

