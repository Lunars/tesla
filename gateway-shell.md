# Gateway Information

## WARNING - MODIFYING THE GATEWAY INCORRECTLY CAN LEAD TO POTENTIALLY PERMANENT DAMAGE TO YOUR CAR  


### Opening a shell remotely


##### Request shell on gateway: 

You must first send the correct message to the Gateway diagnositic port in order for the gateway to expose a telnet shell on the network using the following command. The port will stay open for 30 seconds, if no connection is made, the port will close automatically.

```console
foo@bar$ printf "\x12\x01" |socat - udp:gw:3500
```

Once the port is open, Use netcat (or equivalent tool) to create a connection to the newly opened telnet port. If successful, you will be prompted with `?`.
```console
foo@bar$ nc gw 23
?
```

Use the password `1q3e5t7u` for authentication. All gateways use the same static password. if successful, you will be prompted with `gw>`.

#### Example

```console
tesla1@cid-RedactedVIN$ printf "\x12\x01" |socat - udp:gw:3500
tesla1@cid-RedactedVIN$ nc gw 23
? 1q3e5t7u
gw> 
```


