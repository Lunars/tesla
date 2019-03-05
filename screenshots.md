
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
bklght=$(lv GUI_backlightUserRequest)
sdv GUI_backlightUserRequest 100
CID=$(curl -s http://cid:4070/screenshot)
IC=$(curl -s http://ic:4130/screenshot)
CIDPATH=$(get_path_from_screenshot "$CID")
ICPATH=$(get_path_from_screenshot "$IC")
scp -rp root@ic:"$ICPATH" /home/tesla/.Tesla/data/screenshots/
bash ~/imgur.sh $CIDPATH $ICPATH
sleep 3
sdv GUI_backlightUserRequest $bklght
```

or use this one to email the pictures

```bash
#!/bin/bash

get_path_from_screenshot() {
        echo -e $1 | sed -e "s/\"//g;s/\\\//g;s/_rval_ : //g;s/--/NaN/g;s/ //1" | sed -e 's/[{}]//g'
}

#SMTP for sending email
server="smtps://smtp.somwhere.com:465"
m_file="/tmp/imgmail.html"
m_data="/tmp/imgmail.txt"
m_from="yoursender@somwhere.com"
m_to="yourdestination@somwhereelse.com"
m_usr="yoursender"
m_pwd="yoursender_password"

# Save the backlight to a variable, set it to 100, then set it back after imgur.sh ?
bklght=$(lv GUI_backlightUserRequest)
sdv GUI_backlightUserRequest 100
CID=$(curl -s http://cid:4070/screenshot)
IC=$(curl -s http://ic:4130/screenshot)
CIDPATH=$(get_path_from_screenshot "$CID")
ICPATH=$(get_path_from_screenshot "$IC")
scp -rp root@ic:"$ICPATH" /home/tesla/.Tesla/data/screenshots/

echo "<html>
<body>
    <div>
        <p>Hello Master, </p>
        <p>Please see the attached screen shots:</p>
        <p>CID</p>
        <img src=\"cid:png_cid.png\"width=\"150\" >
        <p>IC</p>
        <img src=\"cid:png_ic.png\" width=\"150\" >
    </div>
</body>
</html>" > $m_file

mail_from="Your Tesla <$m_from>"
mail_to="The Master <$m_to>"
mail_subject="Requested Screenshots"
mail_reply_to="Your Tesla <$m_from>"
mail_cc=""

function add_file {
    echo "--MULTIPART-MIXED-BOUNDARY
Content-Type: $1
Content-Transfer-Encoding: base64" >> "$m_data"

    if [ ! -z "$2" ]; then
        echo "Content-Disposition: inline
Content-Id: <$2>" >> "$m_data"
    else
        echo "Content-Disposition: attachment; filename=$4" >> "$m_data"
    fi
    echo "$3

" >> "$m_data"
}

message_base64=$(cat $m_file | base64)

echo "From: $mail_from
To: $mail_to
Subject: $mail_subject
Reply-To: $mail_reply_to
Cc: $mail_cc
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=\"MULTIPART-MIXED-BOUNDARY\"

--MULTIPART-MIXED-BOUNDARY
Content-Type: multipart/alternative; boundary=\"MULTIPART-ALTERNATIVE-BOUNDARY\"

--MULTIPART-ALTERNATIVE-BOUNDARY
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: base64
Content-Disposition: inline

$message_base64
--MULTIPART-ALTERNATIVE-BOUNDARY--" > "$m_data"

image_base64=$(cat $CIDPATH | base64)
add_file "image/png" "png_cid.png" "$image_base64"
image_base64=$(cat $ICPATH | base64)
add_file "image/png" "png_ic.png" "$image_base64"

echo "--MULTIPART-MIXED-BOUNDARY--" >> "$m_data"

curl -u $m_usr:$m_pwd -n --ssl-reqd --mail-from "<$m_from>" --mail-rcpt "<$m_to>" --url $server -T $m_data

rm $m_file
rm $m_data
rm $CIDPATH
rm $ICPATH
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
