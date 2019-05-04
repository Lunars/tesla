# Adaptive headlights

1053571- 1 00-D - HD/LP ASY, SAE UP-LEVEL, RH

1053570- 1 00-D - HD/LP ASY, SAE UP-LEVEL, LH

gateway:

```
headlamp led
turnsignal led
```

# TPMS

internal.dat: `tpmstype 3`

![](https://i.imgur.com/v3VIdfa.png)

https://static.nhtsa.gov/odi/tsbs/2016/SB-10081828-5448.pdf

# PuP

internal.dat: `ambientlightsinstalled 1`

Interior door lighting
```
P/N 1007955-00-F RH Front Door ($54.48)
P/N 1008121-00-F RH Rear Door ($45.98)
P/N 1002977-00-F LH Front Door ($54.48)
P/N 1007988-00-F LH Rear Door ($45.98)
```
Or buy an LED strip on Amazon for $7

https://www.amazon.com/gp/product/B005GL5R56/

https://www.amazon.com/gp/product/B079C6T6HJ/

https://www.amazon.com/gp/product/B00VDOD9AA

https://www.abstractocean.com/foot-well-light-brackets-for-model-s-one-pair-tesla-part-1016677-00-a/#product-additional-info

# Subzero

## Heated steering wheel, 2015+ only

internal.dat: `steeringHeat 1`

Wiring exists in the steering column for all vehicles built after Dec 8 2014

$250 - 1036774-00-D - Wheel with heated component

$140 - Steering heater ecu and wiring harness - https://i.imgur.com/gTzLSNQ.png
Get the one for your car

```
1043892-00-A STEERING COLUMN CONTROL MODULE - ADAPTIVE CRUISE CONTROL, GENERATION 2 STEERING, AND HEATER 
1057356-00-B STEERING COLUMN CONTROL MODULE - ADAPTIVE CRUISE CONTROL, ?GENERATION 2 STEERING, AND HEATER 
```

## Washer nozzles

internal.dat: `nozzleHeatInstalled 1`

Just the washer nozzles that can be heated: 

$25 - 1005404-01-E - Heated washer nozzle assembly - 2x

May not be needed, but it includes a harness and wiring. It could be the same as the one currently installed in the car

$60 - 1025202-00-C - Windshield washer nozzles with harness and hose 

### Heated Rear Seats

internal.dat: `rearSeatHeatersInstalled 1`

1030459-00-A REAR CENTER HEATER MODULE  
*1030460-00-A REAR HEATER PATCH HARNESS Not sure if we need this

And you will need some heated pads, 3 sets of upper and lower

#### Heated Wipers

internal.dat: `wiperheatinstalled 1`


# LTE

```
1054968-01-B PCBA, LTE CONNECTIVITY, UBLOX GPS $8x
1035347-00-A SIM CARD, JASPER, This card is LTE specific
*1011778-01-C PCBA GYRO SENSOR 
*1014006-00-A BRKT, GYRO PCBA
You can reuse your old gyro, I did...
```

New modem will bolt into same 3 mount points.  Dont worry the 2 for the side gyro is in different spot.  MAKE sure you connect GPS antenna on connector labeled GPS.  Once again dont ask me why I know this.  You will need T20 bit to remove 18 screws, 12 that secure screen to chassis, and 6 that secure trim to mcu.  I flipped the trim around as I opened so I didn't have to cut the zip tie for bluetooth antenna .  Not removing the bluetooth antenna makes it a little harder to change the modem, have a helper stedy the MCU or prop it with things.  Then put back in car and good to go.
