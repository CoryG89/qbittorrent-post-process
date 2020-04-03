#!/usr/bin/env bash

HOST='http://localhost:8080'
USER='admin'
PASS='adminadmin'

# Expect torrent hash to be passed to this script on download completion
HASH="$1"

BASE_URL="$HOST/api/v2"
LOGIN_API="$BASE_URL/auth/login"
PROPERTIES_API="$BASE_URL/torrents/properties"
FILES_API="$BASE_URL/torrents/files"

# Call qBitorrent WebAPI to authenticate, dump the headers and extract session cookie
SID=$(curl -sL -D - -d "username=$USER&password=$PASS" "$LOGIN_API" | grep -oP 'SID=[^;]+')

# Call qBittorrent WebAPI w/ session cookie and the torrent hash
# to get the base path for the torrent's location on the file system
BASE_PATH=$(curl -sL -b "$SID" "$PROPERTIES_API?hash=$HASH" | jq -r '.save_path')

# Call the qBittorrent WebAPI to get a relative path for each file contained in the torrent
for REL_PATH in $(curl -sL -b "$SID" "$FILES_API?hash=$HASH" | jq -r '.[].name')
do
  ABS_PATH="$BASE_PATH$REL_PATH"

  # If the file has a supported archive file extension, extract with 7zip
  if [[ "$ABS_PATH" =~ \.(rar|zip|7z)$ ]]; then
    7z x "$ABS_PATH" -o"$(dirname "$ABS_PATH")"
  fi

  # Do some other stuff...?
done
