#!/bin/bash

imgurAPI="/home/lunars/src/scripts/imgur.sh"
if [ ! -f "$imgurAPI" ]; then
    echo "Downloading imgur library"
    curl https://raw.githubusercontent.com/Lunars/tesla/master/src/scripts/imgur.sh -o $imgurAPI
    sleep 1
fi

get_path_from_screenshot() {
    echo -e $1 | sed -e "s/\"//g;s/\\\//g;s/_rval_ : //g;s/--/NaN/g;s/ //1" | sed -e 's/[{}]//g'
}

bklght=$(lv GUI_backlightUserRequest)
sdv GUI_backlightUserRequest 255 && sleep 1
CID=$(curl -s http://cid:4070/screenshot)
IC=$(curl -s http://ic:4130/screenshot)
sdv GUI_backlightUserRequest ${bklght//\"}
CIDPATH=$(get_path_from_screenshot "$CID")
if [ "$IC" != "" ]; then # ic may be sleeping (energy savings mode)
    ICPATH=$(get_path_from_screenshot "$IC")
    sleep 1
    scp -q -rp root@ic:"$ICPATH" /home/tesla/.Tesla/data/screenshots/
fi
bash $imgurAPI $CIDPATH $ICPATH
printf "\n"
