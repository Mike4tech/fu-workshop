#!/bin/sh

RPI_HOST=$1
RPI_PATH=$2
BINARY_PATH=hub-sdk/target/armv7-unknown-linux-gnueabihf/release/hub-service

if [ -z $RPI_PATH]; then
    RPI_PATH="~/"
fi

if [ -z $RPI_HOST]; then
    echo "USAGE:"
    echo "    ./to_rpi <HOST>"
    echo ""
    echo "Example: ./to_rpi pi@10.34.65.189:~/hub_service"
    echo ""
else
    echo "Uploading to: $RPI_HOST:$RPI_PATH"
    scp "$BINARY_PATH" "$RPI_HOST:$RPI_PATH"
fi
