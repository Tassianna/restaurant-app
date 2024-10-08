resource "aws_ami_from_instance" "instance_ami" {
  for_each = var.images

  source_instance_id = each.value.source_instance_id
  name               = each.value.name
  description        = "An AMI of my custom running instance"

  tags = {
    Name = "My Custom ${each.key} AMI"
  }
}