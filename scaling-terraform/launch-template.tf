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
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "start"
    # Wait for Docker service to be fully up
    while ! systemctl is-active --quiet docker; do
        echo "Waiting for Docker to start..."
        sleep 5
    done

    cd /home/ubuntu/restaurant-app
    sudo docker compose up

    echo "Docker containers started."
  EOF
  )
}
