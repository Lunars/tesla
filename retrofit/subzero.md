# Subzero

## Heated steering wheel, > Dec 2014 only

Wiring exists in the steering column for all vehicles built after Dec 8 2014

```bash
access-internal-dat.pl steeringHeat 1
```

$200 - 1036774-00-D - Wheel with heated component, make sure it has the wire hanging out

![](https://i.imgur.com/6AMML5Q.jpg)

$115 - Steering heater ecu and connected harness

"HEATED FUNCTION STEERING WHEEL CONTACT PLATE MODULE"

![](https://i.imgur.com/rVTehNB.jpg)

$115 - 1057354-00-B - SCCM with 12 pins in back, 5 pins on left front 

![](https://i.imgur.com/n6wOOFd.png)

$40 - 2498689 - Steering airbag wiring harness, with 5 pins in brown connector (blue and brown for heated wheel, typically)

![](https://i.imgur.com/KF0iur4.jpg)

## Washer nozzles

```bash
access-internal-dat.pl nozzleHeatInstalled 1
```

Just the washer nozzles that can be heated: 

$25 - 1005404-01-E - Heated washer nozzle assembly - 2x

May not be needed, but it includes a harness and wiring. It could be the same as the one currently installed in the car

$60 - 1025202-00-C - Windshield washer nozzles with harness and hose 

### Heated Rear Seats

```bash
access-internal-dat.pl rearSeatHeatersInstalled 1
```

1030459-00-A REAR CENTER HEATER MODULE  
*1030460-00-A REAR HEATER PATCH HARNESS Not sure if we need this

And you will need some heated pads, 3 sets of upper and lower

#### Heated Wipers

```bash
access-internal-dat.pl wiperheatinstalled 1
```

You need a whole new windshield for this install. Typically, when you get a chip / crack in your windshield and Tesla replaces it for you, they give you a windshield with HWA (heated wiper area) already installed at the bottom of the shield. When that's done, you can either ask them to enable the config, or enable it yourself after verifying the connections are plugged in. It's the right side A pillar 
