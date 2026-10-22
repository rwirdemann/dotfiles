#!/bin/sh
bluetoothctl disconnect 2C:76:00:CD:DC:76
sleep 3
bluetoothctl connect 2C:76:00:CD:DC:76
sleep 3
wpctl status | grep -i -A3 sinks
