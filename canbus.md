Unlock car:

`sdv GUI_lockRequest unlock`


Only works when you're sitting in the driver's seat, AFAIK

# seat
printf "\x01\x03\x02\x09\x04\x00" | socat - udp:gw:3500

# mirror
printf "\x01\x01\x05\x0a\x00\x01\x04\x00" | socat - udp:gw:3500

# trunk
printf "\x01\x01\x02\x48\x04\x00\x30\x07\x00\xFF\xFF\x00" | socat - udp:gw:3500

# sunroof
printf "\x01\x01\x02\x08\x01\x50\x00\x00\x00\x00\x00\x00" | socat - udp:gw:3500

# P_mode
printf "\x01\x05\x00\x6D\x40\xD0\xXX\xXX" | socat - udp:gw:3500
