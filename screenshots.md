
# Local Screenshots

## CID

```console
tesla1@cid-RedactedVIN$  curl -s http://cid:4070/screenshot
```

## IC

To get screenshots from the IC display, from the CID

```console
tesla1@cid-RedactedVIN$ curl -s http://ic:4130/screenshot
tesla1@cid-RedactedVIN$ scp -rp root@ic:/home/tesla/.Tesla/data/screenshots/ /home/tesla/.Tesla/data/
```

# Remotely Screenshotting displays

## IC

tesla1@cid-RedactedVIN$ 
```console
foo@bar$ curl -s http://ic:4130/screenshot
foo@bar$ scp -rp root@ic:/home/tesla/.Tesla/data/screenshots/ /remote/destination
```
tesla1@cid-RedactedVIN$ 
```console
foo@bar$ curl -s http://ic:4130/screenshot
foo@bar$ scp -rp root@cid:/home/tesla/.Tesla/data/screenshots/ /remote/destination
```

