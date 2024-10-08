
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
      allow_tcp_frontend_traffic = {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = false
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
      allow_http_traffic = {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = false
      }
      allow_tcp_auth_traffic = {
        from_port   = 3001
        to_port     = 3001
        protocol    = "tcp"
        cidr_blocks = false
      }
      allow_tcp_discounts_traffic = {
        from_port   = 3002
        to_port     = 3002
        protocol    = "tcp"
        cidr_blocks = false
      }
      allow_tcp_items_traffic = {
        from_port   = 3003
        to_port     = 3003
        protocol    = "tcp"
        cidr_blocks = false
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

#################################EC2#####################################

instances = {

    maintenance = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        subnet                      = "public_subnet"
        associate_public_ip_address = true
        instance_type               = "t2.micro"
        user_data                   = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install ansible -y
        EOF
    }

    client = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        subnet                      = "public_subnet"
        associate_public_ip_address = true
        instance_type               = "t2.large"
        user_data                   = ""
    }

    auth_service = {
        availability_zone           = "eu-west-2b"
        vpc_security_group          = false
        subnet                      = "private_subnet"
        associate_public_ip_address = false
        instance_type               = "t2.micro"
        user_data                   = ""
    }

    discounts_service = {
        availability_zone           = "eu-west-2b"
        vpc_security_group          = false
        subnet                      = "private_subnet"
        instance_type               = "t2.micro"
        associate_public_ip_address = false
        user_data                   = ""
    }

    items_service = {
        availability_zone           = "eu-west-2b"
        vpc_security_group          = false
        instance_type               = "t2.micro"
        subnet                      = "private_subnet"
        associate_public_ip_address = false
        user_data                   = ""
    }

    haproxy_1 = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        instance_type               = "t2.micro"
        subnet                      = "public_subnet"
        associate_public_ip_address = true
        user_data                   = ""
    }
    
    haproxy_2 = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        instance_type               = "t2.micro"
        subnet                      = "public_subnet"
        associate_public_ip_address = true
        user_data                   = ""
    }
    
    lb = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        instance_type               = "t2.micro"
        subnet                      = "public_subnet"
        associate_public_ip_address = true
        user_data                   = ""
    }
}

ami_image     = "ami-01ec84b284795cbc7"
#instance_type = "t2.micro"
key_name      = "london_key"



#####################alarms#########################

alarms={
  auth_alarm_scale_down= {
      alarm_name          = "auth-low-cpu"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = "1"
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = "300"
      statistic           = "Average"
      threshold           = "10"
      alarm_description   = "Triggered when CPU utilization uses less than 10% for auth service."
      alarm_actions       = "auth_down"
      dimensions          = "auth_scaling_group"
  }

  items_alarm_scale_down= {
      alarm_name          = "items-low-cpu"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = "1"
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = "300"
      statistic           = "Average"
      threshold           = "10"
      alarm_description   = "Triggered when CPU utilization uses less than 10% for items service."
      alarm_actions       = "items_down"
      dimensions          = "items_scaling_group"
  }

  discounts_alarm_scale_down= {
      alarm_name          = "discounts-low-cpu"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = "1"
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = "300"
      statistic           = "Average"
      threshold           = "10"
      alarm_description   = "Triggered when CPU utilization uses less than 10% for discounts service."
      alarm_actions       = "discounts_down"
      dimensions          = "discounts_scaling_group"
  }

  auth_alarm_scale_up= {
      alarm_name          = "auth-high-cpu"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "1"
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = "300"
      statistic           = "Average"
      threshold           = "80"
      alarm_description   = "Triggered when CPU utilization exceeds 80% for auth services."
      alarm_actions       = "auth_up"
      dimensions          = "auth_scaling_group"
  }

  items_alarm_scale_up= {
      alarm_name          = "items-high-cpu"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "1"
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = "300"
      statistic           = "Average"
      threshold           = "80"
      alarm_description   = "Triggered when CPU utilization exceeds 80% for items service."
      alarm_actions       = "items_up"
      dimensions          = "items_scaling_group"
  }

  discounts_alarm_scale_up= {
      alarm_name          = "discounts-high-cpu"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "1"
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = "300"
      statistic           = "Average"
      threshold           = "80"
      alarm_description   = "Triggered when CPU utilization exceeds 80% for discounts service."
      alarm_actions       = "discounts_down"
      dimensions          = "discounts_scaling_group"
  }
}