#!/bin/bash

echo "start"
# Wait for Docker service to be fully up
while ! systemctl is-active --quiet docker; do
    echo "Waiting for Docker to start..."
    sleep 5
done

cd ~/restaurant-app
sudo docker compose up

echo "Docker containers started."
