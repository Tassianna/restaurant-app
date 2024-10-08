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