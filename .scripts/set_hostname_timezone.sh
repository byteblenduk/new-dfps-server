#!/usr/bin/env bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root."
  exit 1
fi

# Prompt for new hostname
read -p "Enter the new hostname: " new_hostname

# Validate hostname input
if [[ -z "$new_hostname" ]]; then
  echo "Hostname cannot be empty. Exiting."
  exit 1
fi

# Change the hostname
if ! hostnamectl set-hostname "$new_hostname"; then
  echo "Failed to change hostname. Exiting."
  exit 1
fi

# Update /etc/hosts to reflect the new hostname
if ! sed -i "s/$(hostname)/$new_hostname/" /etc/hosts; then
  echo "Failed to update /etc/hosts. Exiting."
  exit 1
fi

# Update the timezone to Europe/London
if ! timedatectl set-timezone Europe/London; then
  echo "Failed to set timezone. Exiting."
  exit 1
fi

# Inform user of changes
echo "Hostname changed to $new_hostname and timezone set to Europe/London."
