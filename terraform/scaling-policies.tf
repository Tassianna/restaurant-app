resource "aws_autoscaling_policy" "scaling_policy" {
  for_each = var.scaling_policies

  # following are the same 
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300

  # following are the same 1 for adding, -1 for removing
  name               = each.key
  scaling_adjustment = each.value.adjustment_value
}