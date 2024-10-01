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
mkdir -p "$BASE_DIR/torrents/3x/movies"
mkdir -p "$BASE_DIR/torrents/3x/scenes"
mkdir -p "$BASE_DIR/torrents/3x/tv"
mkdir -p "$BASE_DIR/torrents/3x/jav"
mkdir -p "$BASE_DIR/torrents/anime"
mkdir -p "$BASE_DIR/torrents/books"
mkdir -p "$BASE_DIR/torrents/comics"
mkdir -p "$BASE_DIR/torrents/movies"
mkdir -p "$BASE_DIR/torrents/music"
mkdir -p "$BASE_DIR/torrents/tv"

mkdir -p "$BASE_DIR/usenet/incomplete"
mkdir -p "$BASE_DIR/usenet/complete/3x/movies"
mkdir -p "$BASE_DIR/usenet/complete/3x/scenes"
mkdir -p "$BASE_DIR/usenet/complete/3x/tv"
mkdir -p "$BASE_DIR/usenet/complete/3x/jav"
mkdir -p "$BASE_DIR/usenet/complete/anime"
mkdir -p "$BASE_DIR/usenet/complete/books"
mkdir -p "$BASE_DIR/usenet/complete/comics"
mkdir -p "$BASE_DIR/usenet/complete/movies"
mkdir -p "$BASE_DIR/usenet/complete/music"
mkdir -p "$BASE_DIR/usenet/complete/tv"

mkdir -p "$BASE_DIR/media/3x/movies"
mkdir -p "$BASE_DIR/media/3x/scenes"
mkdir -p "$BASE_DIR/media/3x/tv"
mkdir -p "$BASE_DIR/media/3x/jav"
mkdir -p "$BASE_DIR/media/anime"
mkdir -p "$BASE_DIR/media/books"
mkdir -p "$BASE_DIR/media/comics"
mkdir -p "$BASE_DIR/media/photos"
mkdir -p "$BASE_DIR/media/movies"
mkdir -p "$BASE_DIR/media/music"
mkdir -p "$BASE_DIR/media/tv"

# Set ownership to the specified user
chown -R "$USERNAME:$USERNAME" "$BASE_DIR"

# Set permissions
chmod -R 775 "$BASE_DIR"
find "$BASE_DIR" -type f -exec chmod 664 {} \;

echo "Directory structure created and ownership set to $USERNAME."
