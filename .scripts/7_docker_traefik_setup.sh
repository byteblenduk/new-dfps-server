#!/usr/bin/env bash

# Check if the script is run by setup.sh
if [ "$RUN_BY_SETUP" != "true" ]; then
  echo "This script must be run by setup.sh" 1>&2
  exit 1
fi

# User home directory (use tilde expansion for flexibility)
USER_HOME=$(eval echo "~$USERNAME")

# Prompt for Let's Encrypt email and validate input
read -p "Please enter your Let's Encrypt email address: " LETSENCRYPTEMAIL
if [[ -z "$LETSENCRYPTEMAIL" ]]; then
  echo "Email cannot be empty." 1>&2
  exit 1
fi

# Create the .env file with initial placeholders
echo "Creating .env file..."
cat <<EOF > "$USER_HOME/.env"
DATA_DIR=/data
APPDATA_DIR=$USER_HOME/.appdata
LETSENCRYPTEMAIL=$LETSENCRYPTEMAIL  # Added Let's Encrypt email variable
EOF

# Check if the .env file was created successfully
if [ ! -f "$USER_HOME/.env" ]; then
  echo "Failed to create .env file" 1>&2
  exit 1
fi

# Create the acme.json file for Let's Encrypt certificates if it doesn't exist
if [ ! -f "$USER_HOME/acme.json" ]; then
  echo "{}" > "$USER_HOME/acme.json"  # Initialize with empty JSON
  chmod 600 "$USER_HOME/acme.json"  # Set permissions
  if [ $? -ne 0 ]; then
    echo "Failed to set permissions on acme.json" 1>&2
    exit 1
  fi
fi

# Create the docker-compose.yml file with a basic structure
echo "Creating docker-compose.yml file..."
cat <<EOF > "$USER_HOME/docker-compose.yml"
services:
  traefik:
    image: traefik:v2.10  # Use the latest stable version
    command:
      - "--api.insecure=true"  # Enable the Traefik dashboard (insecure, for testing only)
      - "--providers.docker=true"  # Enable Docker as a provider
      - "--entrypoints.web.address=:80"  # Define entrypoint for HTTP traffic
      - "--entrypoints.websecure.address=:443"  # Define entrypoint for HTTPS traffic
      - "--entrypoints.web.http.redirections.entryPoint.secure.redirect.entryPoint=websecure"  # Redirect HTTP to HTTPS
      - "--certificatesresolvers.myresolver.acme.httpchallenge=true"  # Enable HTTP challenge for Let's Encrypt
      - "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web"  # Entry point for the challenge
      - "--certificatesresolvers.myresolver.acme.email=\${LETSENCRYPTEMAIL}"  # Email from variable
      - "--certificatesresolvers.myresolver.acme.storage=/acme.json"  # Store certificates
    ports:
      - "80:80"  # Expose HTTP
      - "443:443"  # Expose HTTPS
      - "8080:8080"  # Expose Traefik dashboard
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"  # Enable Traefik to communicate with the Docker API
      - "./acme.json:/acme.json"  # Persistent storage for Let's Encrypt certificates
    restart: unless-stopped
EOF

# Check if the docker-compose.yml file was created successfully
if [ ! -f "$USER_HOME/docker-compose.yml" ]; then
  echo "Failed to create docker-compose.yml file" 1>&2
  exit 1
fi

# Set ownership of the created files to the user
echo "Setting ownership of the files to the user..."
chown "$USERNAME:$USERNAME" "$USER_HOME/.env"
chown "$USERNAME:$USERNAME" "$USER_HOME/docker-compose.yml"
chown "$USERNAME:$USERNAME" "$USER_HOME/acme.json"  # Ensure acme.json ownership

# Inform that files were created successfully
echo "Files created successfully for user $USERNAME"
