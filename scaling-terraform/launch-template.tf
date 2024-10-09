resource "aws_launch_template" "launch_template" {
  for_each = aws_ami_from_instance.instance_ami

  name = "${each.value.name}_template"

  vpc_security_group_ids = [var.private_security_group_id]

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }
  instance_type = "t2.micro"
  image_id      = each.value.id # <-- this needs to be snapshot image 
  key_name      = var.key_name
  
  # Base64 encode the user_data script
  #still doesnt run docker compose up..
  user_data = base64encode("./restaurant-app/template-startup/startup.sh")
}
