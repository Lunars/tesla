# Heated steering wheel, > Dec 2014 needs physical harness modification

Wiring exists coming from dash to behind the steering column for all vehicles built after Dec 8 2014. For vehicles before this, there are no easy instructions...The MCU sends CAN + PWR to SCCM for heated steering wheel (? accuracy not confirmed)

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

Pre Dec 2014 cars need additional modification since the harness plugging into SCCM does not have power and ground for the heater.

For the modification you will need to remove the green Pin 6 on the yellow SCCM connector. After you remove that replace it with a new wire connected to constant 12V.

Create a ground wire like above and place it in pin 7 of the SCCM connector.


Link with pictures https://teslamotorsclub.com/tmc/threads/pre-dec-2014-s-heated-steering-wheel-retrofit.165374/#post-4002253
