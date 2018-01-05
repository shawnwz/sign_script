#!/bin/bash

source ./config.sh

cd $NASC_FOLDER/SSD_Out/
md5sum -c *.md5
if [ $? -ne 0 ]; then
	cd -
	exit 1
fi
cd -

gpg --yes --decrypt-files $NASC_FOLDER/SSD_Out/*.pgp

rm -rf $NASC_FOLDER/Production

mkdir -p $NASC_FOLDER/Production/release_starhub_sam7231_qa_v1
cp $NASC_FOLDER/SBP_Out/otv5_loader_kernel_squashfs.bin.1.pro.lbs $NASC_FOLDER/Production/release_starhub_sam7231_qa_v1/otv5_loader_kernel_squashfs.bin.lbs
cp $NASC_FOLDER/SSD_Out/otv5_loader_kernel_squashfs.bin.1.pro.lbs.cat_ssd1.lbs $NASC_FOLDER/Production/release_starhub_sam7231_qa_v1/otv5_loader_kernel_squashfs.bin.lbs_ssd1.lbs

sync

