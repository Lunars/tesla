# Welcome to the Tesla root information dump

We're just getting started filling this out, so feel free to jump in and help document things that need to be here. We're focused on documenting helpful tools, scripts, and information about what you can do with root access. 

If you found this Repo helpful and are looking at buying a tesla, please consider using ths referral code: http://ts.la/andrew2984

---

### Restart qtcar gui:

`/sbin/restart qtcar`

### Very low suspension:

```
sdv GUI_suspensionLevelRequest 7
# You will notice it going lower, front and rear
```

Or, 

You may be able to enable it in the GUI:

```
access-internal-dat.pl airsuspension 2
sdv VAPI_carType ModelX
# or sdv VAPI_carType 1
# lv VAPI_carType to confirm it changed
/sbin/restart qtcar
```

![](https://www.teslarati.com/wp-content/uploads/2015/09/Model-X-Firmware-7-Suspension.jpg)
