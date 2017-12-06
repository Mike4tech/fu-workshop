# RPI Workshop for the Freie Universitat

## Introduction

Cheap semiconductors and easy-to-use libraries allow everybody to improvise their own
low-tech solutions for their daily problems. This tutorial gives a bit of insight on
how to get started hacking with the Raspberry PI's GPIO.

For these examples you'll need python installed and a raspberry pi.

We'll implement a very simple button. What the button does is up to you. If you can
make it print something on activation, you can also make it launch the zombie killing
missiles ;)

## Step 0: Login to your RPI Zero W.

1. Connect the micro-usb cable to the port labeled "USB". Make sure _NOT_ to use the
   one labeled PWD.

2. You will need Bonjour or similar in your computer. (avahi-daemon in linux)

3. Connect to the USB-Ethernet:

	- Ubuntu: In the network manager connect to the USB wired connection.
	- Go to NetworkManager, in the tab IPv4-settings set Method to `Link-Local Only`

4. Do: `ssh pi@raspberrypi.local`. Password `raspberry`

### Check that the Geeny Hub is running by calling:

You can create a Geeny Dev account
[here](https://labs.geeny.io/register/developer?next=https%3A%2F%2Fdevelopers.geeny.io%2F)

`curl -H "Content-Type: application/json"\
      -X POST -d '{"email":"<your-user>","password":"<your-password>"}'\
	  http://localhost:9000/api/v1/login`


## Step 1: Plugging everything together.

You will need only 2 cables and a switch button.

- The input goes to the GPIO 23 (i.e second column. 8th row. Counting from top to bottom)
- And the power (first column, first row)

<img src="./slides/images/Button-Sketch.png" width="240"/>

## Step 2: GPIO Getting Started

Open your favorite editor and copy:

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

Test your code in the Raspberry Pi

```bash
# Copy the file
$ scp button.py pi@raspberrypi.local:~/
# Run the code:
$ ssh pi@raspberrypi.local
$ python button.py
```

Press the button. What's the behaviour? Anything wrong?

### Step 3: Fixing Debouncing

There are multiple points on which the conditions are met. Specially shortly after
the switch button presses against the contact points.

[Bouncing](https://en.wikipedia.org/wiki/Switch#Contact_bounce)

[The topic of switch bouncing is super interesting!](https://www.allaboutcircuits.com/technical-articles/switch-bounce-how-to-deal-with-it/)

One way to deal with it is to use a sleep/wait function.

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

## Step 4. Make it do something cool!

[From twilio's
documentation:](https://www.twilio.com/docs/api/messaging/send-messages#messaging-services)

A common solution we have seen is SMS powered emergency button for the care of the
elderly.

```python
import RPi.GPIO as GPIO
import time
import os

from twilio.rest import Client

# Your Account SID from twilio.com/console
# In this case. My account (Diego)
account_sid = "ACe9554c8d86227045b93590fe140a4d8c"
# Your Auth Token from twilio.com/console
auth_token  = os.environ["TWILIO_SECRET"]

client = Client(account_sid, auth_token)

def send_alert():
  message = client.messages.create(
    to="+4917627295457",
    from_="+18312221512",
    body="Diego! RED ALERT!")
  print("Sent: ", message.sid)

def pause():
    time.sleep(0.1)

GPIO.setmode(GPIO.BCM)
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

try:
  while True:
    if GPIO.input(23):
      while GPIO.input(23):
        pass
      send_alert()
    pause()

except KeyboardInterrupt:
  pass
finally:
  print "Exit: Cleanup"
  GPIO.cleanup()
```

## Step 5. Make it Geeny Enabled!

TBD:
