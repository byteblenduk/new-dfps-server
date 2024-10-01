#!/usr/bin/env bash

# Check if the script is run by setup.sh
if [ "$RUN_BY_SETUP" != "true" ]; then
  echo "This script must be run by setup.sh" 1>&2
  exit 1
fi

# User variables
USER_HOME="$USER_DIR"
DOCKER_COMPOSE_FILE="$USER_HOME/docker-compose.yml"
ENV_FILE="$USER_HOME/.env"

# Create the .env file with initial placeholders
echo "Creating .env file..."
cat <<EOF > "$ENV_FILE"
PROJECT_NAME=$PROJECT_NAME
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_PORT=$DB_PORT
EOF

# Create the docker-compose.yml file with a basic structure
echo "Creating docker-compose.yml file..."
cat <<EOF > "$DOCKER_COMPOSE_FILE"
version: '3'

services:
  db:
    image: mysql:latest
    container_name: ${PROJECT_NAME}_db
    environment:
      - MYSQL_DATABASE=\${DB_NAME}
      - MYSQL_USER=\${DB_USER}
      - MYSQL_PASSWORD=\${DB_PASSWORD}
      - MYSQL_ROOT_PASSWORD=\${DB_PASSWORD}
    ports:
      - "\${DB_PORT}:3306"
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
EOF

# Set ownership of the created files to the user
echo "Setting ownership of the files to the user..."
chown $USER:$USER "$ENV_FILE"
chown $USER:$USER "$DOCKER_COMPOSE_FILE"

# Inform that files were created successfully
echo "Files created successfully in $USER_HOME"
