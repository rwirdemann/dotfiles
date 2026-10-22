bluetoothctl info 2C:76:00:CD:DC:76

bluetoothctl disconnect 2C:76:00:CD:DC:76
sleep 3
bluetoothctl connect 2C:76:00:CD:DC:76
sleep 3
wpctl status | grep -i -A3 sinks

pactl list cards | grep -A30 "bluez_card" | grep -E "headset|a2dp"

pactl list cards | grep -A40 "bluez_card" | grep "Active Profile"

pactl set-card-profile bluez_card.2C_76_00_CD_DC_76 headset-head-unit
