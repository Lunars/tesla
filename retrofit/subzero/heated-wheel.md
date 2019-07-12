# Heated steering wheel, > Dec 2014 only

Wiring exists coming from dash to behind the steering column for all vehicles built after Dec 8 2014. For vehicles before this, there are no easy instructions...The MCU sends LIN + PWR to SCCM for heated steering wheel (? accuracy not confirmed)

## Config

```bash
access-internal-dat.pl steeringheat 1
```

## Parts

* $200 - 1036774-00-D - Wheel with heated component, make sure it has the wire hanging out

![](https://i.imgur.com/6AMML5Q.jpg)

* $115 - Steering heater ecu and connected harness. You really only need the ecu, the wires going to and from it, and the ecu bracket that snaps onto the plate and holds the ecu + side connectors in place. You don't need this whole black plate 

"HEATED FUNCTION STEERING WHEEL CONTACT PLATE MODULE"

![](https://i.imgur.com/rVTehNB.jpg)

* $115 - 1057354-00-B - SCCM with 5 pins on left front. Do not buy one with 3 pins in the front left connector (brown connector)!

![](https://i.imgur.com/oG38xw6.png)

* $40 - 2498689 - Steering airbag wiring harness, with 5 pins in brown connector (blue and brown for heated wheel, typically). You need the white connector going into right voice switch, it has more pins than a non-heated switch connector. You also need the two black connectors that go into the ecu. You do not need the yellow connector (airbag)

![](https://i.imgur.com/KF0iur4.jpg)

## Install

Everything is plug and play. Remove steering wheel, remove SCCM. Add new SCCM, add new steering wheel.

Insert the heated contact plate into the new steering wheel (before install would help). All the wires will make sense when you go to install
