#!/bin/bash
# Set the base directory for docker services
DOCKER_SERVICES_DIR="/home/max/home-one-setup/docker_services"

# Function to update the machine
update_machine() {
    echo "Updating system packages..."
    sudo apt update && sudo apt upgrade -y

    # Check if a reboot is required
    if [ -f /var/run/reboot-required ]; then
        echo "A reboot is required."
        echo "Stopping all Docker containers before rebooting..."
        
        stop_docker_containers
        
	echo "Rebooting now..."
	sleep 30  # Wait for 30 seconds to give the user time to cancel
	sudo reboot
    else
        echo "No reboot is necessary. System is up-to-date."
    fi
}

# Function to stop all Docker containers
stop_docker_containers() {
    echo "Stopping all running Docker containers..."
    for compose_file in $(find "$DOCKER_SERVICES_DIR" -name "docker-compose.yaml"); do
        compose_dir=$(dirname "$compose_file")
        echo "Stopping containers in $compose_dir..."
        (cd "$compose_dir" && docker compose down)
    done
}

# Function to start all Docker containers
start_docker_containers() {
    echo "Starting all Docker containers..."
    for compose_file in $(find "$DOCKER_SERVICES_DIR" -name "docker-compose.yaml"); do
        compose_dir=$(dirname "$compose_file")
        echo "Starting containers in $compose_dir..."
        (cd "$compose_dir" && docker compose up -d)
    done
}

# Function to stop all Docker containers and power down
turn_off() {
    stop_docker_containers
    echo "Powering down in 30 seconds..."
    sleep 30
    sudo poweroff
}

# Main script logic
case "$1" in
    update)
        update_machine
        ;;
    up)
        start_docker_containers
        ;;
    down)
	stop_docker_containers
	;;
    off)
	turn_off
	;;
    *)
        echo "Usage: $0 {update|up|down}"
        echo "  update: Updates the system and stops containers if reboot is required."
        echo "  up: Starts all Docker containers."
        echo "  down: Stops all Docker containers."
        echo "  off: Stops all Docker containers and powers down the Server."
        exit 1
        ;;
esac
