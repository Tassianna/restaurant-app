

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
    for_each = vars.alarms
}



