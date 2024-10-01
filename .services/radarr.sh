#!/usr/bin/env bash

# Check if the script is run by setup.sh
if [ "$RUN_BY_SETUP" != "true" ]; then
  echo "This script must be run by setup.sh" 1>&2
  exit 1
fi

# User home directory (use tilde expansion for flexibility)
USER_HOME=$(eval echo "~$USERNAME")

# Check if the docker-compose.yml file exists
if [ ! -f "$USER_HOME/docker-compose.yml" ]; then
  echo "Error: docker-compose.yml file doesn't exist" 1>&2
  exit 1
fi

# Check if the Radarr service already exists in docker-compose.yml
if grep -q "radarr:" "$USER_HOME/docker-compose.yml"; then
  echo "Radarr service already exists in docker-compose.yml. No changes made." 1>&2
  exit 0
fi

echo "Adding Radarr to docker-compose.yml file..."
cat <<EOF >> "$USER_HOME/docker-compose.yml"  # Use '>>' to append to the file
  radarr:
    container_name: radarr
    image: lscr.io/linuxserver/radarr:latest
    environment:
      - PUID=\${PUID}
      - PGID=\${PGID}
      - TZ=\${TZ}
    volumes:
      - \${APPDATA_DIR}/radarr/config:/config
      - \${DATA_DIR}:/data
    labels:
      - "traefik.enable=true"  # Enable Traefik for this service
      - "traefik.http.routers.radarr.rule=Host(`radarr.\${BASE_DOMAIN}`)"  # Router rule for domain
      - "traefik.http.routers.radarr.entrypoints=websecure"  # Use the secure entrypoint
      - "traefik.http.routers.radarr.tls=true"  # Enable TLS
      - "traefik.http.routers.radarr.tls.certresolver=myresolver"  # Use the Let's Encrypt resolver
      - "traefik.http.services.radarr.loadbalancer.server.port=7878"  # Radarr's internal port
    restart: unless-stopped
EOF

echo "Radarr has been added to docker-compose.yml successfully."
