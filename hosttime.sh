#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root."
  exit
fi

# Prompt for new hostname
read -p "Enter the new hostname: " new_hostname

# Change the hostname
hostnamectl set-hostname "$new_hostname"

# Update /etc/hosts to reflect the new hostname
sed -i "s/$(hostname)/$new_hostname/" /etc/hosts

# Update the timezone to Europe/London
timedatectl set-timezone Europe/London

# Inform user of changes
echo "Hostname changed to $new_hostname and timezone set to Europe/London."

# Refresh the environment with the new hostname and timezone
exec bash -l
