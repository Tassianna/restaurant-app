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
  }))
}

variable "route-associations" {
  type = map(bool)
}
variable "route-tables" {
  type = map(object({
    cidr_block = string
    gateway_id = bool
  }))
}

#########################EC2###########################
variable "instances"{
    type = map (object({
        availability_zone           = string
        vpc_security_group          = bool
        subnet                      = string
        associate_public_ip_address = bool
        instance_type               = string
        user_data                   = string
    }))
}

variable "ami_image" {
  type = string
}
variable "key_name" {
  type = string
}


#################aws_cloudwatch_metric_alarm###############

variable "alarms"{
    type= map (object({
      alarm_name          = string  
      comparison_operator = string  
      evaluation_periods  = string  
      metric_name         = string  
      namespace           = string  
      period              = string  
      statistic           = string  
      threshold           = string  
      alarm_description   = string   
      alarm_actions       = string   
      dimensions          = string
    }))
}

