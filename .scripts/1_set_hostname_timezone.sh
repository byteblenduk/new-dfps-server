#!/usr/bin/env bash

# Check if the script is run by setup.sh
if [ "$RUN_BY_SETUP" != "true" ]; then
  echo "This script must be run by setup.sh" 1>&2
  exit 1
fi

# Validate hostname input
if [[ -z "$HOSTNAME" ]]; then
  echo "Hostname cannot be empty. Exiting."
  exit 1
fi

# Change the hostname
if ! hostnamectl set-hostname "$HOSTNAME"; then
  echo "Failed to change hostname. Exiting."
  exit 1
fi

# Update /etc/hosts to reflect the new hostname
current_hostname=$(hostname)
if ! sed -i "s/$current_hostname/$HOSTNAME/" /etc/hosts; then
  echo "Failed to update /etc/hosts. Exiting."
  exit 1
fi

# Update the timezone to Europe/London
if ! timedatectl set-timezone Europe/London; then
  echo "Failed to set timezone. Exiting."
  exit 1
fi

# Inform user of changes
echo "Hostname changed to $HOSTNAME and timezone set to Europe/London."
