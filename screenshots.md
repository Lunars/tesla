
# Local Screenshots

## Upload images to imgur.com

```console
curl https://raw.githubusercontent.com/tremby/imgur.sh/master/imgur.sh -o ~/imgur.sh
```

```bash
#!/bin/bash

get_path_from_screenshot() {
	echo -e $1 | sed -e "s/\"//g;s/\\\//g;s/_rval_ : //g;s/--/NaN/g;s/ //1" | sed -e 's/[{}]//g'
}

CID=$(curl -s http://cid:4070/screenshot)
IC=$(curl -s http://ic:4130/screenshot)
CIDPATH=$(get_path_from_screenshot "$CID")
ICPATH=$(get_path_from_screenshot "$IC")
scp -rp root@ic:"$ICPATH" /home/tesla/.Tesla/data/screenshots/
bash ~/imgur.sh $CIDPATH $ICPATH
```

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
