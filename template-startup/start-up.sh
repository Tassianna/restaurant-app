#!/bin/bash

if [ ! -f /var/lib/cloud/instance/boot-finished ]; then
    # Your setup script here
    cd /path/to/restaurant-app
    sudo docker compose up -d
fi