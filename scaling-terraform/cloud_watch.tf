

resource "aws_cloudwatch_metric_alarm" "alarms" {
    alarm_name          = each.value.alarm_name
    comparison_operator = each.value.comparison_operator
    evaluation_periods  = each.value.evaluation_periods
    metric_name         = each.value.metric_name
    namespace           = each.value.namespace
    period              = each.value.period
    statistic           = each.value.statistic
    threshold           = each.value.threshold
    alarm_description   = each.value.alarm_description
    alarm_actions       = [aws_autoscaling_policy.scale_up.arn]                  #TODO: change name
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.backend_service_asg.name    #TODO: change names
    }
    for_each = var.alarms
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


