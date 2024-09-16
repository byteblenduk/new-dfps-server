#!/usr/bin/env bash

# Check if the script is run by setup.sh
if [ "$RUN_BY_SETUP" != "true" ]; then
  echo "This script must be run by setup.sh" 1>&2
  exit 1
fi

# Install required packages
apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Set up the Docker repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker Engine
apt update
apt install -y docker-ce

# Verify Docker installation
docker --version

# Install Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep "tag_name" | cut -d '"' -f 4)
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to the Docker Compose binary
chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
docker-compose --version

# Add the user to the docker group
usermod -aG docker "$USERNAME"

echo "Docker and Docker Compose installed. User $USERNAME added to the Docker group."
