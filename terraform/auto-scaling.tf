resource "aws_autoscaling_group" "autoscaling_group" {
  name             = "backend_scaling_group"
  min_size         = 1
  max_size         = 5
  desired_capacity = 2
  vpc_zone_identifier = [ aws_subnet.subnet["private_subnet"].id ] # Subnets your ASG can deploy instances into

    launch_template {
        id      = aws_launch_template.launch_template["backend_launch_template"].id
        version = "$Latest"
    }

  tag {
    key                 = "Name"
    value               = "Auto-scaled backend"
    propagate_at_launch = true
  }
}

