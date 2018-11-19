# How to 

## Update internal.dat

```bash
access-internal-dat.pl <key> <value> <user>

# Example
access-internal-dat.pl badging 1 "Toolbox"
```

## Change your current settings

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

## For pre-ap, to force the autopilot cluster

```bash
ssh ic
sudo edit-settings-conf.pl -a vapi/forceHasAutopilot=true

ssh cid
access-internal-dat.pl lanedepature 1 "Toolbox"
access-internal-dat.pl blindspot 1 "Toolbox"

# Not sure if required:
# access-internal-dat.pl parkassistinstalled 2 "Toolbox"
```

# Options

**badging**

```
0: none
1: founders
2: signature
3: "performance"
4: does not exist
```
**exterior**

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
