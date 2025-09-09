#!/bin/bash
set -e

service postgresql start

# Check if extension folder exists and has content
if [ ! -d /extension/ ] || [ -z "$(find /extension/ -mindepth 1 -print -quit)" ]; then
    echo "[init] Copying and building "
    cp -r /usr/local/src/extension/* /extension/
    pg-reload
fi


echo "[start] Dropping into bash"
exec bash

