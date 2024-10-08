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



