variable "key_name" {
  type = string
}

######### CLI Input variables

variable "private_security_group_name" {
  type = string
}

variable "private_subnet_id" {
  type = string
}



######### Scaling groups & policies

variable "scaling_groups" {
  type = map(object({
    loadbalancer = string
    template     = string
  }))
}

variable "launch_templates" {
  type = map(object({
    name = string
    ami_name = string
  }))
}

# images
variable "images" {
  type = map(object({
    name = string
    source_instance_id = string # string will refer to instance ids
  })) 
}

