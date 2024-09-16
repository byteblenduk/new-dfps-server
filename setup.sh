#!/usr/bin/env bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root."
  exit 1
fi

# Update and upgrade system
apt update && apt upgrade -y

# Define the scripts directory
SCRIPT_DIR="./.scripts"

# Ensure the script directory exists
if [ ! -d "$SCRIPT_DIR" ]; then
  echo "Script directory $SCRIPT_DIR does not exist." 1>&2
  exit 1
fi

# Make all scripts in the .scripts directory executable
chmod +x "$SCRIPT_DIR"/*.sh

# Set environment variable to verify script origin
export RUN_BY_SETUP=true

# Prompt for new hostname
read -p "New Hostname: " hostname

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

# Set environment variables for hostname, user & password
export HOSTNAME=$hostname
export USERNAME=$username
export PASSWORD=$password

# Execute each setup script
for script in "$SCRIPT_DIR"/*.sh; do
  if [ -x "$script" ]; then
    echo "Running $script..."
    "$script" || { echo "Error running $script" 1>&2; exit 1; }
  else
    echo "Skipping $script (not executable)" 1>&2
  fi
done

# Inform user of completion
echo "All setup tasks completed."

# Refresh the environment with the new hostname
echo "Refreshing environment..."
exec bash -l
