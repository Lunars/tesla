# Gateway Information

## WARNING - MODIFYING THE GATEWAY INCORRECTLY CAN LEAD TO POTENTIALLY PERMANENT DAMAGE TO YOUR CAR  


### Opening a shell remotely


##### Request shell on gateway: 

You must first send the correct message to the Gateway diagnositic port in order for the gateway to expose a telnet shell on the network using the following command. The port will stay open for 30 seconds, if no connection is made, the port will close automatically.

```console
foo@bar$ printf "\x12\x01" |socat - udp:gw:3500
```

Once the port is open, Use netcat (or equivalent tool) to create a connection to the newly opened telnet port. If successful, you will be prompted with `?`.
```console
foo@bar$ nc gw 23
?
```

Use the password `1q3e5t7u` for authentication. All gateways use the same static password. if successful, you will be prompted with `gw>`.

#### Example

```console
tesla1@cid-RedactedVIN$ curl localhost:7654/wake_up
tesla1@cid-RedactedVIN$ printf "\x12\x01" |socat - udp:gw:3500
tesla1@cid-RedactedVIN$ nc gw 23
? 1q3e5t7u
gw> 
```

```bash
gw> help
Board Revision: 6
Vehicle Version: develop/2019.12.1.1-4-4b1dd298a9
Application 0.0
CRC: 38d92723, buildType: 1 (PLATFORM)
GIT: 4b1dd298a97a35adfcfda12bb700a53be5349cca
Bootloader Version: 2.3.2

help - help
? - help
exit - exit
reboot - reboot
free - display free memory
uptime - system uptime
ls - list directory contents [dir]
rm - remove files or dirs <name> [name...]
mv - rename files or dirs <from> <to>
cat - display file contents <file>
cp - copy file <from> <to>
mkdir - create dir <dir>
chkdsk - error check sd card
formatsd - format sd card
ex - force exception [wd|dtlb|stkrd|stkwr]
date - date
dbglog - debug logging
resetbms - reset bms
tegra - tegra serial communications [baud]
tegrareset - tegra reset [gpio]
hub - hub [on|off]
status - status info
clearlogs - Clear the logs and then reboot
udsdebug - udsdebug <mask>
hwid - hwid [moduleName]
dbgrails - debug power rails
dbgtimers - debug timers
miiread - read mii register <0xaddr> <0xreg>
ic - turn ic [on|off]
dbgrtc - show rtc debug info
repairsd - repair sd card boot sector
dumpbs - dump sd card boot sector
reseti2c - reset i2c hardware
readrtc - read rtc
lwip - lwip statistics
flushinfo - show flush info
stackinfo - show task stack info
dbglv - debug Low Voltage batt management
gw>
```

