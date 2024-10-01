#!/usr/bin/env bash

# Check if the script is run by setup.sh
if [ "$RUN_BY_SETUP" != "true" ]; then
  echo "This script must be run by setup.sh" 1>&2
  exit 1
fi

# User home directory (use tilde expansion for flexibility)
USER_HOME=$(eval echo "~$USERNAME")

# Radarr service configuration
cat >> "$DOCKER_COMPOSE_FILE" <<EOL

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
