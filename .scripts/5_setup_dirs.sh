#!/usr/bin/env bash

# Check if the script is run by setup.sh
if [ "$RUN_BY_SETUP" != "true" ]; then
  echo "This script must be run by setup.sh" 1>&2
  exit 1
fi

# Check if the user exists
if ! id "$USERNAME" &>/dev/null; then
  echo "User $USERNAME does not exist."
  exit 1
fi

# Define the base directory path
BASE_DIR="/data"

# Create the directory structure
mkdir -p /data/torrents/3x/movies
mkdir -p /data/torrents/3x/scenes
mkdir -p /data/torrents/3x/tv
mkdir -p /data/torrents/3x/jav
mkdir -p /data/torrents/anime
mkdir -p /data/torrents/books
mkdir -p /data/torrents/comics
mkdir -p /data/torrents/movies
mkdir -p /data/torrents/music
mkdir -p /data/torrents/tv
mkdir -p /data/usenet/incomplete
mkdir -p /data/usenet/complete/3x/movies
mkdir -p /data/usenet/complete/3x/scenes
mkdir -p /data/usenet/complete/3x/tv
mkdir -p /data/usenet/complete/3x/jav
mkdir -p /data/usenet/complete/anime
mkdir -p /data/usenet/complete/books
mkdir -p /data/usenet/complete/comics
mkdir -p /data/usenet/complete/movies
mkdir -p /data/usenet/complete/music
mkdir -p /data/usenet/complete/tv
mkdir -p /data/media/3x/movies
mkdir -p /data/media/3x/scenes
mkdir -p /data/media/3x/tv
mkdir -p /data/media/3x/jav
mkdir -p /data/media/anime
mkdir -p /data/media/books
mkdir -p /data/media/comics
mkdir -p /data/media/photos
mkdir -p /data/media/movies
mkdir -p /data/media/music
mkdir -p /data/media/tv

# Set ownership to the specified user
chown -R "$USERNAME:$USERNAME" /data

# Set permissions
chmod -R 775 /data
find /data -type f -exec chmod 664 {} \;

echo "Directory structure created and ownership set to $USERNAME."
