resource "aws_cloudwatch_metric_alarm" "alarms_out" {
    for_each = aws_autoscaling_policy.scaling_policy_out

    alarm_name          = "${each.value.name}_alarm"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = "1"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "300"
    statistic           = "Average"
    threshold           = "80"
    alarm_description   = "Triggered when CPU utilization exceeds 80% for ${each.value.name} services."
    alarm_actions       = [each.value.arn]
    dimensions = {
        AutoScalingGroupName = each.value.autoscaling_group_name   #TODO: change names
    }
}
resource "aws_cloudwatch_metric_alarm" "alarms_in" {
    for_each = aws_autoscaling_policy.scaling_policy_in

    alarm_name          = "${each.value.name}_alarm"
    comparison_operator = "LessThanThreshold"
    evaluation_periods  = "1"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "300"
    statistic           = "Average"
    threshold           = "10"
    alarm_description   = "Triggered when CPU utilization uses less than 10% for ${each.value.name} services."
    alarm_actions       = [each.value.arn]
    dimensions = {
        AutoScalingGroupName = each.value.autoscaling_group_name   #TODO: change names
    }
}

#This is where our application logs will be stored.
resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/aws/application/logs"
  retention_in_days = 7  # You can adjust this as per your needs
}


resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "ErrorFilter"
  log_group_name = aws_cloudwatch_log_group.application_logs.name
  pattern        = "\"ERROR\""

  metric_transformation {
    name      = "ErrorCount"
    namespace = "MyApp"
    value     = "1"
  }
}

# Log-based alarm for errors
resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "Error-Log-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ErrorCount"
  namespace           = "MyApp"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Triggered when more than 1 error is logged."
  alarm_actions       = [aws_sns_topic.notification.arn]
}

resource "aws_sns_topic" "notification" {
  name = "alarm-notifications"
}


