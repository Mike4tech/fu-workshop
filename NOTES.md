# Appendix A. Setup USB Internet for RPI Zero W

From
[here](https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget/ethernet-gadget)

1. Burn Raspbian into the SD Card
2. Modify config.txt in the boot partition and add: `dtoverlay=dwc2`
3. Modify cmdline.txt and add `modules-load=dwc2,g_ether` after `rootwait`
4. (Optional) create a file called ssh in the boot partition (i.e `touch ssh`)

# Appendix B. Setup Rust for Cross-compilation

## Setup `cross`

```bash
curl https://sh.rustup.rs -sSf | sh
rustup component add rust-src
rustup install nightly-2017-10-25 # Use the latest version
# For v6
rustup target add arm-unknown-linux-gnueabihf
# For v7
rustup target add armv7-unknown-linux-gnueabihf
cargo install --vers 0.3.8 xargo
cargo install cross
```

## Building the API.

Clone repository `https://github.com/geeny/linux-hub-sdk.git`

Raspberry PI 3

```bash
cross build --bin hub-service --release --target armv7-unknown-linux-gnueabihf
--features="rest-service"
```

Raspberry PI Zero W
```bash
cross build --bin hub-service --release --target arm-unknown-linux-gnueabihf  --features="rest-service"
```

## Configuration:

```
cp ./geeny_hub_service.mvdb.json.example ./geeny_hub_service.mvdb.json
```

Then, modify all the paths so they point to real paths with the right permissions.

# Appendix C. API Cheatsheet

## Create Thing

```bash
curl -X POST \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -d '{
        "name": "<name-of-your-thing>",
        "serial_number": "123",
        "thing_type": "877827cc-0c78-4e55-80fe-2941479c681a"
        }' \
    'http://localhost:9000/api/v1/things' > thing.info
```

## Send Message

```bash
curl -H "Content-Type: application/json" -X POST -d '{"msgs":[]}'
http://localhost:9000/api/v1/messages/123
```

## Get your JWT Token:

```
curl -X POST \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -d '{
        "email": "<your-email-address>",
        "password": "<your-password>"
        }' \
    'https://connect.geeny.io/auth/login/' | jq -r '.token' > geeny.token
```

# Appendix: Using ethernet usb device.

1. Connect the micro-usb cable to the port labeled "USB". Make sure _NOT_ to use the
   one labeled PWR.

2. You will need Bonjour or similar in your computer. (avahi-daemon in linux)

3. Connect to the USB-Ethernet:

	- Ubuntu: In the network manager connect to the USB wired connection.
	- Go to NetworkManager, in the tab IPv4-settings set Method to `Link-Local Only`

4. Do: `ssh pi@raspberrypi.local`. Password `raspberry`
