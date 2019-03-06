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

date -r 1234 &>/dev/null && BSD=1

for d in */*
do
    mogrify -format png -flip "${d}/*.PGM"
    pngs=""
    for f in ${d}/*.png
    do
        pngs="${pngs} ${f}"
    done

    stamp=$(echo "${d}" | cut -c -8)
    stamp=$((16#${stamp}))

    if [ -z $BSD ]
    then
        convert -loop 0 -delay 25${pngs} "$(date -d @$stamp "+%Y-%m-%d %H:%M:%S")-$(echo ${d} | cut -d / -f 2).gif"
    else
        convert -loop 0 -delay 25${pngs} "$(date -r $stamp "+%Y-%m-%d %H:%M:%S")-$(echo ${d} | cut -d / -f 2).gif"
    fi
done
```

