# Gateway Internal.dat Information



### Listing all options for internal.dat:

##### Retrieving current internal.dat settings

You can run the get-gateway-config.sh script to save the current gateway configuration to the file `var/etc/gateway.cfg`  
```console
tesla1@cid-RedactedVIN$ sudo get-gateway-config.sh;  cat /var/etc/gateway.cfg
```

##### Sample output

```
vin ***
birthday ***
chargertype single
airsuspension 2
adaptivecruise 0
# 2018-08-29 11:20:25.752000 Toolbox lib-vehicle 2018.24.5 *** changed frontfog 0 => 1
frontfog 1
# access-internal-dat.pl 2018-11-02 06:17:42: Toolbox changed rearfog from 0 to 1
rearfog 1
corneringlamps 1
homelink 1
sunroof 1
powerlift 1
audiotype premium
headlamp hid
# access-internal-dat.pl 2018-11-04 05:48:06: Toolbox changed landeparture from 0 to 1
landeparture 1
# access-internal-dat.pl 2018-11-04 05:48:14: Toolbox changed blindspot from 0 to 1
blindspot 1
rhd 0
intrusiontilt 0
memoryseats 1
memorymirrors 1
ocs 1
euvehicle 0
interior 0
exterior 1
dash 6
4wd 0
seatheaters 1
performance 2
badging 2
fastcharge 1
fastchargeinstalled 1
spoilerinstalled 1
wheeltype super_21_silver
roofcolor none
gpstype ublox
mapregion us
nokeylessentry 0
nopushtounlock 0
simulatedS1 0
# access-internal-dat.pl 2018-11-04 05:58:14: Toolbox changed ambientlightsinstalled from 0 to 1
ambientlightsinstalled 1
wiperheatinstalled 1
rearseatheatersinstalled 1
parkassistinstalled 1
headlightlevelerinstalled 0
country us
drlinstalled 1
lightpipeinstalled 1
sidemarkerinstalled 1
foldingmirrors 1
dimmablervmirror 1
otherfastchargeallowed 0
ionizertype 0
# access-internal-dat.pl 2018-06-17 12:00:52: Teleforce user *** changed twelveVBatteryType from 1 to 2
twelveVBatteryType 2
packconfig 41
```

## List of settings available on the gateway

#### airbagCutoffInstalled
- Description: Boolean toggle to inform the car if there is an air bag cut-off switch installed on the car. This is usually used to turn on/off the driver / passenger airbags when passengers are in positions which the airbag can cause more damage than it would stop.
- Values:
  - 0: Not Installed
  - 1: Installed

#### airSuspensionInstalled
- Description: Boolean toggle to inform the car if air bag suspension is installed on the car.
- Values:
  - 0: Not Installed
  - 1: Installed
#### ambientLightsInstalled
- Description: Boolean toggle to inform the car if cars have additional ambient lighting installed in the footwell and doors.
- Values:
  - 0: Not Installed
  - 1: Installed
#### audioType
- Description: Boolean toggle to inform the car which audio package is installed on the car.
- Values:
  - standard: standard audio package
  - premium: premium auto package
#### autopilot
- Description: Boolean toggle to inform the car if the owner has purchased the autopilot package. Note (there is no toggle for FSD at this time).
- Values:
  - 0: Not purchased
  - 1: Purchased
#### autopilotTrial
- Description: Boolean toggle to inform the car if the owner has activated an autopilot trial.
- Values:
  - 0: Trial is not active
  - 1: Trial is active
  
#### auxHvacType
#### badging
#### boardRevision
#### bodyControlsType
#### brakeHwType
#### chargerType
#### chargeState
#### chassisType
#### compressorType
#### cornerInstalled
#### country
#### curveLightingType
#### dasHw
#### dimmableRvMirror
#### drlInstalled
#### efficiencyPackage
#### epasType
#### espInterface
#### euVehicle
#### exteriorColorCode
#### falconStrutType
#### fastChargeAllowed
#### fastChargeInstalled
#### foldingMirrorsInstalled
#### forwardRadarHw
#### fourWheelDrive
#### freeSlaveCharger
#### frontCornerRadarHw
#### frontDoorActuationType
#### frontDoorLatchType
#### frontDriveUnitType
#### frontFogInstalled
#### frontSeatVentilationType
#### gpsType
#### headLampType
#### headlightLevelerInstalled
#### homelinkInstalled
#### HVJB16APerPhaseOK
#### intakeAirFilterType
#### intrusionTiltInstalled
#### ionizerType
#### isEbuck
#### lightPipeInstalled
#### mapRegion
#### memoryMirrorsInstalled
#### memorySeatsInstalled
#### navigationAllowed
#### noKeylessEntry
#### noPack
#### noPushToUnlock
#### noSpeedPulse
#### noVehicleSleep
#### nozzleHeatInstalled
#### numberHVILNodes
#### ocs
#### ocsInstalled
#### offboardUpdateState
#### offboardUpdateStatus
#### otherFastChargeAllowed
#### packConfig
#### parkAssistInstalled
#### parkSensorGeometryType
#### performanceAddOn
#### performanceConfig
#### performanceLock
#### powerLiftGate
#### pwsSpeakerType
#### radarPosition
#### rearCornerRadarHw
#### rearDriveUnitType
#### rearFacingSeats
#### rearFogInstalled
#### rearSeatControllerMask
#### rearSeatHeatersInstalled
#### rearSeatType
#### restraintControlsType
#### restraintsHardwareType
#### rhd
#### roofColor
#### screenAdhesiveType
#### seatHeatersInstalled
#### seatType
#### shutterType
#### sideMarkerInstalled
#### simulatedS1
#### softPackConfig
#### spoilerInstalled
#### standbySupplyRequired
#### steeringColumnType
#### steeringHeat
#### steeringWheel
#### sunroofInstalled
#### thBusInstalled
#### thirdRowSeatHeatType
#### thirdRowSeatType
#### topSpeedEnum
#### towPackage
#### tpmsType
#### tractionControlType
#### twelveVBatteryType
#### w025_easMia
#### w027_epbMia
#### w037_espMia
#### w044_tpmsMia
#### w104_ocsMia
#### w105_rcmMia
#### w170_parkAssistMia
#### w181_parkAssistSystemDTC
#### w206_parkAssistVersMismatch
#### w265_ibstMia
#### w268_ibstFailure
#### w277_iBoosterReduced
#### wakeupReason
#### wheelType
#### willBeGoingToSleep
#### wiperHeatInstalled
#### wouldSleep
#### xmAntInstalled

