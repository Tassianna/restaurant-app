resource "aws_autoscaling_group" "autoscaling_group" {
  for_each = var.scaling_groups

  name = "${each.key}_sg"

  min_size            = 1
  max_size            = 5
  desired_capacity    = 1
  vpc_zone_identifier = [var.private_subnet_id] # Subnets your ASG can deploy instances into
  # load_balancers      = [each.value.loadbalancer]

  launch_template {
    id = each.key == "items" ? aws_launch_template.launch_template["items"].id : each.key == "auth" ? aws_launch_template.launch_template["auth"].id : aws_launch_template.launch_template["discounts"].id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Auto-scaled ${each.key}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "example" {
  for_each = var.scaling_groups

  autoscaling_group_name = "${each.key}_sg"
  elb                    = each.value.loadbalancer
}

