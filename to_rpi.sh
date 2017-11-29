#!/bin/sh

RPI_HOST=$1
RPI_PATH=$2

BINARY_PATH=hub-sdk/target/armv7-unknown-linux-gnueabihf/release/hub-service
CONFIG_PATH=hub-sdk/geeny_hub_service.mvdb.json
CREDENTIALS_PATH=hub-sdk/credentials.mvdb.json
ELEMENTS_PATH=hub-sdk/elements.mvdb.json
CERTIFICATES_PATH=hub-sdk/certificates

if [ -z $RPI_PATH ]; then
    RPI_PATH="~/"
fi

if [ -z $RPI_HOST ]; then
    echo "USAGE:"
    echo "    ./to_rpi <HOST>"
    echo ""
    echo "Example: ./to_rpi pi@10.34.65.189:~/hub_service"
    echo ""
else
    HOST_PATH="$RPI_HOST:$RPI_PATH"
    echo "Uploading to: $HOST_PATH"

    scp -r \
        "$BINARY_PATH"\
	"$CONFIG_PATH"\
	"$CREDENTIALS_PATH"\
	"$ELEMENTS_PATH"\
	"$CERTIFICATES_PATH"\
	"$HOST_PATH"
fi
