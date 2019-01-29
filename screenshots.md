
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

# Save the backlight to a variable, set it to 100, then set it back after imgur.sh ? 
sdv GUI_backlightUserRequest 100
CID=$(curl -s http://cid:4070/screenshot)
IC=$(curl -s http://ic:4130/screenshot)
CIDPATH=$(get_path_from_screenshot "$CID")
ICPATH=$(get_path_from_screenshot "$IC")
scp -rp root@ic:"$ICPATH" /home/tesla/.Tesla/data/screenshots/
bash ~/imgur.sh $CIDPATH $ICPATH
```

or use this version that sends the info in an email

```bash
#!/bin/bash

get_path_from_screenshot() {
	echo -e $1 | sed -e "s/\"//g;s/\\\//g;s/_rval_ : //g;s/--/NaN/g;s/ //1" | sed -e 's/[{}]//g'
}

#SMTP for sending email
server="smtps://smtp.somwhere.com:465"
m_file="/tmp/imgmail.txt"
m_from="yoursender@somwhere.com"
m_to="yourdestination@somwhereelse.com"
m_usr="yoursender"
m_pwd="yoursender_password"

# Save the backlight to a variable, set it to 100, then set it back after imgur.sh 
bklght=$(lv GUI_backlightUserRequest)
sdv GUI_backlightUserRequest 100
CID=$(curl -s http://cid:4070/screenshot)
IC=$(curl -s http://ic:4130/screenshot)
CIDPATH=$(get_path_from_screenshot "$CID")
ICPATH=$(get_path_from_screenshot "$IC")
scp -rp root@ic:"$ICPATH" /home/tesla/.Tesla/data/screenshots/
res=$(bash /var/root/scripts/imgur.sh $CIDPATH $ICPATH 2>&1 )
echo "From: Your Tesla <$m_from>" > $m_file
echo "To: The Owner <$m_to>" >> $m_file
echo "Subject: your Tesla screenshots" >> $m_file
echo " " >> $m_file
echo "Here are your screenshots, master!" >> $m_file
echo " " >> $m_file
echo "$res" >> $m_file
curl -u $m_usr:$m_pwd -n --ssl-reqd --mail-from "<$m_from>" --mail-rcpt "<$m_to>" --url $server -T $m_file
rm $m_file
sleep 3
sdv GUI_backlightUserRequest $bklght
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
