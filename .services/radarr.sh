#!/usr/bin/env bash

# Radarr service configuration
cat >> "$DOCKER_COMPOSE_FILE" <<EOL

  radarr:
    container_name: radarr
    image: ghcr.io/hotio/radarr
    environment:
      - PUID=1000
      - PGID=1000
      - UMASK=002
      - TZ=Europe/London
    volumes:
      - ./.appdata/radarr/config:/config
      - /data:/data
