#!/usr/bin/env bash

# Check if the script is run by setup.sh
if [ "$RUN_BY_SETUP" != "true" ]; then
  echo "This script must be run by setup.sh" 1>&2
  exit 1
fi

# Install Fail2Ban if it is not already installed
if ! command -v fail2ban-server &> /dev/null; then
  echo "Fail2Ban not found. Installing Fail2Ban..."
  apt update && apt install -y fail2ban
else
  echo "Fail2Ban is already installed."
fi

# Create a custom jail configuration file
jail_conf="/etc/fail2ban/jail.d/custom-ssh.conf"

echo "Setting up Fail2Ban SSH jail..."
cat << EOF > "$jail_conf"
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
maxretry = 3
findtime = 30m
bantime = 5m
EOF

# Restart Fail2Ban to apply the new configuration
echo "Restarting Fail2Ban to apply changes..."
systemctl restart fail2ban

# Check the status of Fail2Ban to ensure it's running
if systemctl is-active --quiet fail2ban; then
  echo "Fail2Ban is active and running."
else
  echo "Fail2Ban failed to start. Please check the logs for details."
  exit 1
fi

# Inform user of completion
echo "Fail2Ban setup complete with SSH jail configuration."
