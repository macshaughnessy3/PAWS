# SPDX-FileCopyrightText: 2021 John Furcean
# SPDX-License-Identifier: MIT

"""I2C rotary encoder simple test example."""

import board                                            # type: ignore
from adafruit_seesaw import seesaw, rotaryio, digitalio # type: ignore

# import native i2c bus
from smbus import SMBus                                 # type: ignore
import time
#time.sleep(30)
seesaw = seesaw.Seesaw(board.I2C(), addr=0x36)
# address amplifier
i2caddress = 0x4B
i2cbus = SMBus(1)
# threshold values to be written to amp
minVal = 0x00
maxVal = 0x3F
currentVal = minVal

seesaw_product = (seesaw.get_version() >> 16) & 0xFFFF
print("Found product {}".format(seesaw_product))
with open('/home/pi/Code/PAWS/PAWS-RaspberryPi/startup/ble-uart-peripheral/poop.txt', 'a') as f:
            f.write("\n")
            f.write("bitch")
if seesaw_product != 4991:
    print("Wrong firmware loaded?  Expected 4991")

seesaw.pin_mode(24, seesaw.INPUT_PULLUP)
button = digitalio.DigitalIO(seesaw, 24)
button_held = False

encoder = rotaryio.IncrementalEncoder(seesaw)
last_position = 0

while True:

    # negate the position to make clockwise rotation positive
    position = -encoder.position

    if position != last_position:
        if last_position < position and currentVal < maxVal:
            currentVal = currentVal + 1
        else:
            if currentVal > minVal:
                currentVal = currentVal - 1
        last_position = position
        
        i2cbus.write_byte(i2caddress,currentVal) ## change the volume
        print
        ("Position: {}".format(position))

    if not button.value and not button_held:
        button_held = True
        print("Button pressed")

    if button.value and button_held:
        button_held = False
        print("Button released")
