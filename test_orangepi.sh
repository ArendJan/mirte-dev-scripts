#!/bin/bash

# set -xe

# This script connects to the robot via ssh and runs some commands to check if the robot is up and running.
# If the robot is crashed within a minute, then it's assumed the wifi chip is broken and orangepizero1 is 'dead'.
# Needs a sd card where ssd-copy-id is set up, so that ssh can be done without password.

# lsusb is run to check that usb is working.

IP=192.168.44.1
while true; do
ssh  -o ConnectTimeout=1  mirte@$IP -t "lsusb; ip a; uptime; sleep 60; lsusb; uptime; ip a; sudo shutdown now" && exit || true
sleep 1
done
