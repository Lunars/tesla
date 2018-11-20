
# Local Screenshots

## Upload images to imgur.com

1. Save imgur.sh

```console
curl https://raw.githubusercontent.com/tremby/imgur.sh/master/imgur.sh -o ~/imgur.sh
```

2. Save uploadImage.sh

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

3. Run

```console
chmod +x ~/uploadImage.sh
chmod +x ~/imgur.sh
bash ~/uploadImage.sh
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
