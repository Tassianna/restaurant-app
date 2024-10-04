# definition of variables to be used in resources and modules

variable "cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnets" {
  type = map(object({
    cidr_block = string

    map_public_ip_on_launch = bool

    availability_zone = string
  }))
}

variable "security_groups" {
  type = map(object({
    desc = string
    ingress = map(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = bool
    }))
    egress = map(object({
      from_port = number
      to_port   = number
      protocol  = string
    }))
  }))
}

variable "route-associations" {
  type = map(object({
    subnet_id      = string
    route_table_id = string
  }))
}
variable "route-tables" {
  type = map(object({
    cidr_block = string
    gateway_id = string
  }))
}