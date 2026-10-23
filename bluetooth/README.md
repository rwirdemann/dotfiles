## Nach dem Boot

AirPods verbinden sich von alleine:

bluetoothctl info 2C:76:00:CD:DC:76

Firefox schaltet automatisch auf das Profil headset-head-unit um: 

pactl list cards | grep -A40 "bluez_card" | grep "Active Profile"

Nachdem Reload der Seite onlinemictest:

Profil ist headset-head-unit. Micro funktioniert aber nicht mehr. Pipewire
zeigt Fehler an:

systemctl --user status pipewire

pw.node: (bluez_in
put.2C_76_00_CD_DC_76.0-151) idle -> error (Received error event)
Okt 23 17:45:57 archlinux pipewire[1454]: pw.node: (bluez_ou
tput.2C_76_00_CD_DC_76.1-150) idle -> error (Received error event)
Okt 23 17:46:04 archlinux pipewire[1454]: pw.node: (bluez_ou
tput.2C_76_00_CD_DC_76.1-170) running -> error (Received error event)
Okt 23 17:46:04 archlinux pipewire[1454]: pw.node: (bluez_in
put.2C_76_00_CD_DC_76.0-147) running -> error (Received error event)
Okt 23 17:46:04 archlinux pipewire[1454]: pw.node: (bluez_ou
tput.2C_76_00_CD_DC_76.1-151) running -> error (Received error event)

Restart Pipewire behebt das Problem:

systemctl --user restart pipewire
