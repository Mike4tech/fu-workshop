import RPi.GPIO as GPIO
import time
import os

from twilio.rest import Client

# Your Account SID from twilio.com/console
account_sid = os.environ["TWILIO_SID"]
# Your Auth Token from twilio.com/console
auth_token  = os.environ["TWILIO_SECRET"]

client = Client(account_sid, auth_token)

def send_alert():
  message = client.messages.create(
    to="+4917627295457",
    from_="+18312221512", # Provisioned through Twilio's Web UI
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
