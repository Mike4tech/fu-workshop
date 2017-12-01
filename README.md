# Raspberry PI Workshop for the Freie Universitat

## Introduction

Cheap semiconductors and easy-to-use libraries allow everybody to improvise their own
low-tech solutions for their daily problems. This tutorial gives a bit of insight on
how to get started hacking with the Raspberry PI's GPIO.

For these examples you'll need python installed and a raspberry pi.

We'll implement a very simple button. What the button does is up to you. If you can
make it print something on activation, you can also make it launch the zombie killing
missiles ;)

## Login to your RPI Zero W.

1. Connect the micro-usb cable to the port labeled "USB". Make sure _NOT_ to use the
   one labeled PWD.

2. You will need Bonjour or similar in your computer. (avahi-daemon in linux)

3. Connect to the USB-Ethernet:

	- Ubuntu: In the network manager connect to the USB wired connection.
	- Go to NetworkManager, in the tab IPv4-settings set Method to `Link-Local Only`

4. Do: `ssh pi@raspberrypi.local`. Password `raspberry`

## Plugging everything together.

![Schematic](./slides/images/Button-Sketch.png | width=200)

### First Attempt

```python
# We'll be using the GPIO library to
# interact with the hardware
import RPi.GPIO as GPIO

# There are different ways to "count" the pins.
# We'll use the Broadcom notation
GPIO.setmode(GPIO.BCM)

# It's a Button. Then is an IN-put. We can select if we want to activate it
# as pull-down (activated on pressed) or pull-up. (Activated on release)
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

try:
  while True:
	  # 23 is the pin number based on BCM we wanted.
      if GPIO.input(23):
          print("Button 1 pressed")

# Takes care of cleaning up after is done
except KeyboardInterrupt:
    print "Keyboard Interrupt: Exit"
    GPIO.cleanup()
```

This program has a small catch. Try it out. What's the issue?

(The solution is next to this one, don't CHEAT!)

### Single Event Program (First Attempt)

```python
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

try:
  while True:
      if GPIO.input(23):
          print("Button pressed")
          while True:
              if not GPIO.input(23):
                print("Button released")
                break

except KeyboardInterrupt:
    print "Keyboard Interrupt: Exit"
    GPIO.cleanup()
```

### What Happens?

There are multiple points on which the conditions are met. Specially shortly after
the switch button presses against the contact points.

[Bouncing](https://en.wikipedia.org/wiki/Switch#Contact_bounce)

## Debouncing using a sleep

Adding a simple sleep fixes the problem

```python
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

def pause():
    time.sleep(0.1)

try:
  while True:
    if GPIO.input(23):
        print("Button pressed")
        while True:
            if not GPIO.input(23):
                print("Button released")
		break
    pause()

except KeyboardInterrupt:
    print "Keyboard Interrupt: Exit"
    GPIO.cleanup()
```

[The topic of switch bouncing is super interesting!](https://www.allaboutcircuits.com/technical-articles/switch-bounce-how-to-deal-with-it/)

## Install Rust:

```
curl -s https://static.rust-lang.org/rustup.sh | sh -s -- --channel=nightly
```

## Setting up the Geeny API


Clone repository `https://github.com/geeny/linux-hub-sdk.git`

```
cp ./geeny_hub_service.mvdb.json.example ./geeny_hub_service.mvdb.json
```

Modify all the paths so the point to real paths.

```
cargo run --bin hub-service --features="rest-service"
# Or
cargo run --release --bin hub-service --features="rest-service"
```
## Authenticate

curl -H "Content-Type: application/json" -X POST -d '{"email":"diego@geeny.io","password":"password"}' http://localhost:9000/api/v1/login

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

curl -H "Content-Type: application/json" -X POST -d '{"msgs":[]}' http://localhost:9000/api/v1/messages/123

# Additional Commands (Maybe needed)

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

# Appendix A. Setup USB Internet for Raspberry Pi Zero W

From
[here](https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget/ethernet-gadget)

1. Burn Raspbian into the SD Card
2. Modify config.txt in the boot partition and add: `dtoverlay=dwc2`
3. Modify cmdline.txt and add `modules-load=dwc2,g_ether` after `rootwait`
4. (Optional) create a file called ssh in the boot partition (i.e `touch ssh`)
