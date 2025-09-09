#!/bin/bash
set -e

# Check if extension folder exists and has content
if [ ! -d /extension/ ] || [ -z "$(find /extension/ -mindepth 1 -print -quit)" ]; then
    echo "[init] Copying and building "
    cp -r /extension/ /extension/
    pg-reload
fi

service postgresql start

echo "[start] Dropping into bash"
exec bash

