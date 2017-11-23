# Raspberry PI Workshop for the Freie Universitat

## Introduction

Cheap semiconductors and easy-to-use libraries allow everybody to improvise their own
low-tech solutions for their daily problems. This tutorial gives a bit of insight on
how to get started hacking with the Raspberry PI's GPIO.

For these examples you'll need python installed and a raspberry pi.

We'll implement a very simple button. What the button does is up to you. If you can
make it print something on activation, you can also make it launch the zombie killing
missiles ;)


## Plugging everything together.

(TBD: Wiring Diagram)

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

### Single Event Program

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

### What happens?

Well, embedded systems and electronics is different.


## Adding Sleep

```python
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

try:
  while True:
      if GPIO.input(23):
          print("Button pressed")
		  sleep(0.2)
          while True:
              if not GPIO.input(23):
                print("Button released")
				sleep(0.2)
				break

except KeyboardInterrupt:
    print "Keyboard Interrupt: Exit"
    GPIO.cleanup()
```
# fu-workshop
