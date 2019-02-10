# Welcome to the Tesla root information dump

We're just getting started filling this out, so feel free to jump in and help document things that need to be here. We're focused on documenting helpful tools, scripts, and information about what you can do with root access. 

If you found this Repo helpful and are looking at buying a tesla, please consider using ths referral code: http://ts.la/andrew2984

---

### Restart qtcar gui:

`/sbin/restart qtcar`

### Very low suspension:

The display shows "Standard" when in Very Low mode

```
access-internal-dat.pl airsuspension 2
emit-reboot-gateway
# Now touch "Low" in the GUI to go to low suspension

sdv GUI_suspensionLevelRequest 7
# You will notice it going lower, front and rear
```

