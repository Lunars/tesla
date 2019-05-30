# How to 

## Automatic: update internal.dat

The easy method

```bash
access-internal-dat.pl <key> <value> <user>

# Example
access-internal-dat.pl badging 1 "comment this change"

# apply the settings
emit-reboot-gateway
```

## Manual: change your current settings

The manual longer method

```bash
# download the settings
gwxfer gw:/internal.dat ~/i.d

# make your modifications
nano ~/i.d

# upload the settings
gwxfer ~/i.d gw:/internal.dat 

# apply the settings
emit-reboot-gateway
```

# Gateway Internal.dat Information

##### Retrieving current internal.dat settings

You can run the get-gateway-config.sh script to save the current gateway configuration to the file `var/etc/gateway.cfg`  
```console
tesla1@cid-RedactedVIN$ sudo get-gateway-config.sh;  cat /var/etc/gateway.cfg
```

##### Sample output

https://github.com/Lunars/tesla/tree/master/dumps

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
- Description: Informs the car if the owner has purchased the autopilot package. Note (there is no toggle for FSD at this time).
- Values:
  - 0: Not purchased
  - 1: Purchased
  - 2: Purchased FSD
#### autopilotTrial
- Description: Boolean toggle to inform the car if the owner has activated an autopilot trial.
- Values:
  - 0: Trial is not active
  - 1: Trial is active
  
#### auxHvacType
#### badging
- Description: Informs the car which type of badging should be shown on the UI.
- Values: 
  - 0: None
  - 1: Founder's Edition
  - 2: Signature Edition
  - 3: Performance Edition
  - 4: None
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
- Description: Informs the car of what kind of driving assist hardware is installed. /var/etc/dashw doesn't exist on Model 3
- Values:
  - empty: is pre-DAS
  - 0: DAS0 (harnessed for DAS2.0, but no DAS ECU installed)
  - 1: DAS1
  - 2: DAS2.0
  - 3: DAS2.5
  - 4: DAS3.0
 
#### dimmableRvMirror
#### drlInstalled
#### efficiencyPackage
#### epasType
#### espInterface
#### euVehicle
#### exteriorColorCode

Use with `exterior` option

```
1: black
2: white
3: silver
4: gray
5: blue
6: green
7: brown
8: pearl
9: sigred
10: red
11: steelgrey
12: metallic black
13: titanium copper
14: sigblue
```

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
 - Description: GPS mapping type
 - Values:
  - ublox (only known value)
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

After 9, add 6 for your steering wheel number

Eg, 13: arachnid 21 black = `wheelType 19`

```
0: BASE_19
1: SILVER_21
2: CHARCOAL_21
3: SILVER_21_EURO
4: AERO_19
5: CHARCOAL_21_EURO
6: SUPER_21_GRAY
7: SUPER_21_SILVER
8: TURBINE_19
9: TURBINE_19_CHARCOAL
0A: AERO_TURBINE_19_METAL
0B: AERO_TURBINE_19_BLACK
0C: HELIX_20_SILVER
0D: AERO_TURBINE_20_SILVER
0E: TURBINE_22_SILVER
0F: CYCLONE_19_GREY
10: AERO_TURBINE_20_SLVRBLK
11: TURBINE_22_BLACK
12: ARACHNID_21_SILVER
13: ARACHNID_21_BLACK
14: ARACHNID_21_GREY
15: SLIPSTREAM_20_CARBON
16: SLIPSTREAM_20_SLVRBLK
17: SLIPSTREAM_19_CARBON
18: TWINTURBINE_21_SILVER
19: TWINTURBINE_21_CARBON
```

#### willBeGoingToSleep
#### wiperHeatInstalled
#### wouldSleep
#### xmAntInstalled

