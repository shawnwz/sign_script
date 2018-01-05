#!/bin/bash

source ./config.sh

cd $NASC_FOLDER/SSD_Out/
md5sum -c *.md5
if [ $? -ne 0 ]; then
	cd -
	exit 1
fi
cd -

if [ -z "$PASSPHRASE" ]; then
	echo -n "Passphrase: "
	read -s PASSPHRASE
	echo -e "\r"
fi

gpg --yes --passphrase $PASSPHRASE --decrypt-files $NASC_FOLDER/SSD_Out/*.pgp

rm -rf $NASC_FOLDER/Production
mkdir -p $NASC_FOLDER/Production

cp $NASC_FOLDER/SBP_Out/*.lbs $NASC_FOLDER/Production/
for target in $( ls $NASC_FOLDER/Raw )
do
	mkdir -p $NASC_FOLDER/Production/$target
	find $NASC_FOLDER/Production/ -maxdepth 1 -type f -name \*.lbs | head -n1 | xargs -i sh -c 'mv {} $NASC_FOLDER/Production/'$target'/otv5_loader_kernel_squashfs_V1.bin_sbp.lbs'
	find $NASC_FOLDER/Production/ -maxdepth 1 -type f -name \*.lbs | head -n1 | xargs -i sh -c 'mv {} $NASC_FOLDER/Production/'$target'/otv5_loader_kernel_squashfs_V2.bin_sbp.lbs'
done

cp $NASC_FOLDER/SSD_Out/*.lbs $NASC_FOLDER/Production/
for target in $( ls $NASC_FOLDER/Raw )
do
	find $NASC_FOLDER/Production/ -maxdepth 1 -type f -name \*.lbs | head -n1 | xargs -i sh -c 'mv {} $NASC_FOLDER/Production/'$target'/otv5_loader_kernel_squashfs_V1.bin_ssd1.lbs'
	find $NASC_FOLDER/Production/ -maxdepth 1 -type f -name \*.lbs | head -n1 | xargs -i sh -c 'mv {} $NASC_FOLDER/Production/'$target'/otv5_loader_kernel_squashfs_V2.bin_ssd1.lbs'
done

sync

