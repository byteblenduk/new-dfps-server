#!/usr/bin/env bash

# Check if the script is being run by setup.sh
if [ "$RUN_BY_SETUP" != "true" ]; then
  echo "This script must be run by setup.sh" 1>&2
  exit 1
fi

# Function to check the exit status of commands
check_status() {
  if [ $? -ne 0 ]; then
    echo "An error occurred. Exiting."
    exit 1
  fi
}

# Set up Uncomplicated Firewall (UFW)
echo "Configuring UFW..."

# Ensure UFW is installed
if ! command -v ufw &> /dev/null; then
  echo "UFW not found. Installing..."
  apt-get update && apt-get install -y ufw
  check_status
fi

# Apply UFW configurations
sudo ufw default deny incoming
check_status

sudo ufw default allow outgoing
check_status

sudo ufw allow OpenSSH
check_status

sudo ufw limit OpenSSH
check_status

sudo ufw enable
check_status

echo "UFW configuration completed."
