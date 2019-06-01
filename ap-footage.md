You can retrieve the footage AP auto generates when it thinks there's a crash imminent 

```console
#!/bin/bash

host="192.168.1.100"
port=22

# Imagemagick used to create the gif's
sudo apt-get install imagemagick

# Save the dash footage
ssh -p $port tesla1@$host "mkdir ~/dashfootage; gwxfer gw:/DAS/ ~/dashfootage/; gwxfer gw:/EDR/DAS/ ~/dashfootage/"
scp -P $port -r tesla1@$host:~/dashfootage ~/
cd ~/dashfootage/ 

# Author: Nemsoma
# Summary: Rotate and create gif from png files

# Delay between frames
DELAY=25
# The GIF filename format (see date manpage)
GIF_FORMAT="+%Y-%m-%d %H:%M:%S"

date -r 1234 &>/dev/null && BSD=1

for d in */*
do
	mogrify -format png -flip -crop 320x207+0+0 +repage "${d}/*.PGM"

	stamp=$(echo "${d}" | cut -c -8)
	stamp=$((16#${stamp}))

	if [ -z $BSD ]
	then
		convert -loop 0 -delay $DELAY ${d}/*.png "$(date -d @${stamp} "${GIF_FORMAT}")-$(echo ${d} | cut -d / -f 2).gif"
	else
		convert -loop 0 -delay $DELAY ${d}/*.png "$(date -r ${stamp} "${GIF_FORMAT}")-$(echo ${d} | cut -d / -f 2).gif"
	fi

	rm ${d}/*.png*
done

find . -type f ! -iregex '.*\.\(gif\|sh\)$' -delete
find . -type d -empty -delete
```
