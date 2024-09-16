#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root."
  exit
fi

# Prompt for new username
read -p "Enter new username: " username

# Prompt for password securely
read -s -p "Enter password for new user: " password
echo
read -s -p "Confirm password: " password_confirm
echo

# Check if passwords match
if [ "$password" != "$password_confirm" ]; then
  echo "Passwords do not match. Exiting."
  exit 1
fi

# Create new user and set password
useradd -m -s /bin/bash "$username"
echo "$username:$password" | chpasswd

# Add the user to the sudo group
usermod -aG sudo "$username"

echo "$username added to sudo group with the specified password."
##################################################################

# Update and upgrade system
apt update && apt upgrade -y

##################################################################

# Enable UFW and configure firewall rules
# Install UFW if it's not already installed
if ! command -v ufw &> /dev/null; then
  apt install -y ufw
fi

# Allow SSH through the firewall
ufw allow OpenSSH

# Enable UFW
ufw enable

# Show UFW status
ufw status

echo "UFW is installed, configured, and enabled."

##################################################################

# Install required packages
apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker stable repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
apt update

# Install Docker Engine, CLI, and Docker Compose plugin
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Prompt for the username to add to the docker group
read -p "Enter username to add to docker group: " username

# Add the user to the docker group
usermod -aG docker "$username"

# Enable and start Docker service
systemctl enable docker
systemctl start docker

echo "Docker and Docker Compose installed and configured. User $username added to the docker group."

############################
############################
############################

# Refresh the environment with the new hostname and timezone
exec bash -l

# Display Fail2Ban status
fail2ban-client status

echo "Fail2Ban installed and configured. Service is running."
