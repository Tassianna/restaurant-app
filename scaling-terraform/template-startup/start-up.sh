#!/bin/bash


exec > /var/log/user-data.log 2>&1  # Log output to a file

if [ ! -f /var/lib/cloud/instance/boot-finished ]; then
    echo "User data script started."

    # Wait for Docker service to be fully up
    while ! systemctl is-active --quiet docker; do
        echo "Waiting for Docker to start..."
        sleep 5
    done
    
    cd ./restaurant-app
    sudo docker compose up
    
    echo "Docker containers started."
fi
