#!/bin/bash

LOCALDIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
TOOLS_DIR="$LOCALDIR/tools"

if [[ -d "$TOOLS_DIR/Firmware_extractor" ]]; then
    git -C "$TOOLS_DIR"/Firmware_extractor fetch origin
    git -C "$TOOLS_DIR"/Firmware_extractor reset --hard origin/master
else
    git clone -q https://github.com/erfanoabdi/Firmware_extractor "$TOOLS_DIR"/Firmware_extractor
fi
