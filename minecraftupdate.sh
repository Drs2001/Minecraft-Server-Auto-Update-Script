#!/bin/bash

FILES_TO_REMOVE="forge-auto-install.txt minecraft_server.jar README.md server_starter.conf server-icon.png server.properties start_server.bat"
VOLUME_PATH="/var/lib/pelican/volumes/"

if [[ $(id -u ) != 0 ]]; then
    echo "Need to run as root!! - please 'sudo su -'"
    exit 1
fi

if ! [ -z $1 ] && ! [ -z $2 ]; then
    if wget --spider -q "$1"; then

        # Download the zip from url passed
        echo "=== DOWNLOADING FILE FROM $1 ==="
        wget -q -O terra.zip $1
        echo "=== FINISHED DOWNLOADING ==="

        # Unzip the zip file and remove unneeded files
        echo "=== UNZIPPING CONTENTS ==="
        unzip -q -d terra terra.zip
        cd terra
        rm -r $FILES_TO_REMOVE
        echo "=== FINISHED UNZIPPING ==="

        # Copy files to pelican volume folder
        echo "=== COPYING FILES ==="
        cp -r . "$VOLUME_PATH$2"
        cd ..
        echo "=== FINISHED COPYING ==="

        # Clean up leftover files
        echo "=== CLEANING UP FILES ==="
        rm -r terra terra.zip
        echo "=== FINISHED CLEANING UP FILES ==="

        exit 0
    fi
else
    echo "=== EXPECTED 2 ARGS, URL OF ZIP TO DOWNLOAD AND UUID OF PELICAN VOLUME ==="
    exit 1
fi