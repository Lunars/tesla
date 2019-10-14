#!/bin/bash

imgurAPI="/home/lunars/src/scripts/imgur.sh"
if [ ! -f "$imgurAPI" ]; then
    echo "Downloading imgur library"
    curl https://raw.githubusercontent.com/tremby/imgur.sh/master/imgur.sh -o $imgurAPI
    sleep 1
fi

get_path_from_screenshot() {
    echo -e $1 | sed -e "s/\"//g;s/\\\//g;s/_rval_ : //g;s/--/NaN/g;s/ //1" | sed -e 's/[{}]//g'
}

bklght=$(lv GUI_backlightUserRequest)
sdv GUI_backlightUserRequest 100
CID=$(curl -s http://cid:4070/screenshot)
sleep 2
IC=$(curl -s http://ic:4130/screenshot)
sleep 2
CIDPATH=$(get_path_from_screenshot "$CID")
ICPATH=$(get_path_from_screenshot "$IC")
scp -rp root@ic:"$ICPATH" /home/tesla/.Tesla/data/screenshots/
sdv GUI_backlightUserRequest $bklght
bash $imgurAPI $CIDPATH $ICPATH
