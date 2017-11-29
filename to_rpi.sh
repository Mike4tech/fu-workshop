#!/bin/sh

RPI_HOST=$1
RPI_PATH=$2

BINARY_PATH=hub-sdk/target/armv7-unknown-linux-gnueabihf/release/hub-service
CREDENTIALS_PATH=hub-sdk/credentials.mvdb.json
ELEMENTS_PATH=hub-sdk/elements.mvdb.json
CERTIFICATES_PATH=hub-sdk/certificates

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
    HOST_PATH="$RPI_HOST:$RPI_PATH"
    echo "Uploading to: $HOST_PATH"
    scp    "$CREDENTIALS_PATH"  "$HOST_PATH"
    echo "* Uploaded: $ELEMENTS_PATH"
    scp    "$ELEMENTS_PATH"     "$HOST_PATH"
    echo "* Uploaded: $CREDENTIALS_PATH"
    scp -r "$CERTIFICATES_PATH" "$HOST_PATH"
    echo "* Uploaded: $CERTIFICATES_PATH"
fi
