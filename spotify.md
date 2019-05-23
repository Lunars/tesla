# How to enable Spotify on the CID

In order to enable Spotify on the CID you must login to the CID and execute the following command:

```console
tesla1@cid$ edit-settings-conf.pl -a spotify/enable=1

OR

tesla1@cid$ sdv GUI_spotifyEnableOverride 1
```

## Disabling Slacker radio

Although it can be run alongside Spotify, many users choose to disable slacker radio as well because search will provide both slacker and spotify results with no way of determining which service the result is from

```console
tesla1@cid$ edit-settings-conf.pl -a slacker/enable=0
```
