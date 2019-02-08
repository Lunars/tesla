## For pre-ap, to force the autopilot cluster

```bash
ssh ic
sudo edit-settings-conf.pl -a vapi/forceHasDriverAssist=true
sudo edit-settings-conf.pl -a vapi/forceHasAutopilot=true
sudo edit-settings-conf.pl -a vapi/forceHasSelfPark=true
sudo edit-settings-conf.pl -a vapi/forceHasSpeedAssist=true
sudo edit-settings-conf.pl -a vapi/forceHasAdaptiveCruise=true
sudo edit-settings-conf.pl -a vapi/forceHasAutosteer=true
sudo edit-settings-conf.pl -a vapi/forceHasAutoLaneChange=true
sudo edit-settings-conf.pl -a vapi/forceHasForwardCollisionWarning=true
sudo edit-settings-conf.pl -a vapi/forceHasAutoEmergencyBraking=true
sudo edit-settings-conf.pl -a vapi/forceHasBlindSpotWarning=true
sudo edit-settings-conf.pl -a vapi/forceHasSideCollisionAvoidance=true
sudo edit-settings-conf.pl -a vapi/forceHasLaneDepartureWarning=true
sudo edit-settings-conf.pl -a vapi/forceHasAutoHiBeam=true

ssh cid
access-internal-dat.pl autopilot 2 "Toolbox"
access-internal-dat.pl lanedepature 1 "Toolbox"
access-internal-dat.pl blindspot 1 "Toolbox"

# Not sure if required:
# access-internal-dat.pl parkassistinstalled 2 "Toolbox"
```
