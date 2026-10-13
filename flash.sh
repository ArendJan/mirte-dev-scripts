#!/bin/bash

# set -xe

# uploads telemetrix file (from home dir) to pico, needs to be connected with usb and button pressed, so that pico is in bootloader mode.

while true; do
    cp ~/Telemetrix4RpiPico.uf2 /media/robohouse/RPI-RP2 && echo "DONE!!!!!!!!!!!!!!!!!!!!!" || true
    sleep 0.5
done
