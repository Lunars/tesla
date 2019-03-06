You can retrieve the footage AP auto generates when it thinks there's a crash imminent 

```console
ssh tesla1@cid
mkdir ~/dashfootage
nano ~/dashfootage/conv.sh
chmod +x ~/dashfootage/conv.sh
gwxfer gw:/DAS ~/dashfootage/
gwxfer gw:/EDR/DAS ~/dashfootage/
cd ~/dashfootage/
bash conv.sh
find . -type f ! -iregex '.*\.\(gif\|sh\)$' -delete
find . -type d -empty -delete
```

conv.sh

```bash
#!/bin/bash

# Credit to nemsoma, thanks!

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

```
