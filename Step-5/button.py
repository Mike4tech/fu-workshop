import RPi.GPIO as GPIO
import time
import os
import requests
import json

EMAIL=""
PASSWORD=""
SERIAL_NUMBER=""

def login():
    url = 'http://localhost:9000/api/v1/login'
    payload = json.dumps({'email': EMAIL, 'password': PASSWORD})
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, data=payload, headers=headers)
    return response.text == "success"

def publish():
    print("publishing message...")
    url = 'http://localhost:9000/api/v1/messages/' + SERIAL_NUMBER
    payload = json.dumps({'msgs': []})
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, data=payload, headers=headers)
    print(response.text)

def pause():
  time.sleep(0.1)

def send_alert():
  publish()

def setup():
  if login():
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
    print("GPIO setup done")
  else:
    raise "error in login"

def run():
  while True:
    if GPIO.input(23):
      while GPIO.input(23):
        pass
      send_alert()
    pause()

try:
  setup()
  run()
except KeyboardInterrupt:
  pass
finally:
  print "Exit: Cleanup"
  GPIO.cleanup()
