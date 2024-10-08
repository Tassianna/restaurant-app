resource "aws_autoscaling_policy" "scaling_policy_out" {
  for_each = aws_autoscaling_group.autoscaling_group

  # following are the same 
  autoscaling_group_name = each.value.name
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300

  # following are the same 1 for adding, -1 for removing
  name               = "${each.key}_out_policy"
  scaling_adjustment = 1
}

resource "aws_autoscaling_policy" "scaling_policy_in" {
  for_each = aws_autoscaling_group.autoscaling_group

  # following are the same 
  autoscaling_group_name = each.value.name
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300

  # following are the same 1 for adding, -1 for removing
  name               = "${each.key}_in_policy"
  scaling_adjustment = -1
}