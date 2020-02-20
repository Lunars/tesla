#!/bin/sh

# Thanks ag

rm -rf cpio
rm -rf _kernel*.extracted

dd if=cid-kernel.img bs=2048 skip=1 >kernel.lzf
lzf -d kernel.lzf

ARCHIVE=$(binwalk -D gz kernel | grep gzip | tail -1 | egrep -oe "  .*  " | tr -d " " | sed -e 's/0x//')
cd _kernel.extracted
mv ${ARCHIVE} tesla.cpio.gz && gunzip tesla.cpio.gz

# Optional
file *
mkdir cpio
cd cpio
cpio -idmv <../tesla.cpio

cd ../../

mv _kernel.extracted/cpio .
rm -rf _kernel*.extracted
rm -rf kerne*
