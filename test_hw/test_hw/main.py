

# show the sonar distance on the ssd1306 display every second
import time
import machine
from machine import PWM, Pin, I2C
from oled import SSD1306_I2C 
# import board
# import busio
# import adafruit_ssd1306
import hcsr04

pinsA = [18, 20]
pinsB = [19, 21, 25]

on = False
lastHbrugSwitch = time.ticks_ms()
refreshTime = 500
def hbrug():
    global lastHbrugSwitch
    if(time.ticks_diff(time.ticks_ms(), lastHbrugSwitch) >= refreshTime):
        lastHbrugSwitch = time.ticks_ms()
    else:
        return
    global on
    on = not on
    for pin in pinsA:
        machine.Pin(pin, machine.Pin.OUT).value(on)
    for pin in pinsB:
        machine.Pin(pin, machine.Pin.OUT).value(not on)

servoPin = 15
servo = PWM(machine.Pin(servoPin))
servo.freq(50)
# Set Duty Cycle for Different Angles
max_duty = 6000
min_duty = 3000
half_duty = int(max_duty/2)

lastServoSwitch = time.ticks_ms()
servoTime = 1000
servoState = 0
servoAngles = [min_duty, half_duty, max_duty]

def servoF():
    global lastServoSwitch
    if(time.ticks_diff(time.ticks_ms(), lastServoSwitch) >= servoTime):
        lastServoSwitch = time.ticks_ms()
    else:
        return
    global servoState
    servoState = (servoState + 1) % len(servoAngles)
    servo.duty_u16(servoAngles[servoState])
    print("Servo angle set to: {} degrees".format(servoState * 90))


# i2c: scl: GP11, SDA: GP10
# sonar: trigger: GP9, echo: GP8
# Create the I2C interface.
try:
    SDA = machine.Pin(10)
    SCL = machine.Pin(11)
    i2c = machine.I2C(1, scl=SCL, sda=SDA)
    # Create the SSD1306 OLED display object.
    oled = SSD1306_I2C(128, 64, i2c)
    sonar = hcsr04.HCSR04(trigger_pin=9, echo_pin=8)

    while True:
        # Clear the display.
        oled.fill(0)
        # oled.show()
        # Write some text to the display.
        # oled.text("Hello, World!", 0, 0)
        oled.text("Sonar: {}  cm".format(sonar.distance_mm() // 10), 0, 10)
        oled.show()
        time.sleep(0.1)
        hbrug()
        servoF()
except Exception as e:
    print("Error: {}".format(e))


while True:
    hbrug()
    servoF()
    time.sleep(0.1)
