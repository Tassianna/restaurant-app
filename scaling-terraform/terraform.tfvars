

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
