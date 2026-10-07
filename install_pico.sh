#!/bin/bash
set -xe
while true; do
    picotool load -f ./Telemetrix4RpiPico.uf2 || true
    sleep 1
    done