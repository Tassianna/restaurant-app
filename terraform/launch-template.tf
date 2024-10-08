resource "aws_launch_template" "launch_template" {
  name = "backend_launch_template"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }
  
  security_group_names = aws_security_group.security_group["private_security_group"].name

  instance_type = "t2.micro"
  image_id      = var.ami_image
  key_name      = var.key_name
}
