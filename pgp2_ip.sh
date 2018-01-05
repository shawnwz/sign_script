#!/bin/bash

source ./config.sh

cd $NASC_FOLDER/SBP_Out/
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

gpg --yes --passphrase $PASSPHRASE --decrypt-files $NASC_FOLDER/SBP_Out/*.pgp
if [ $? -ne 0 ]; then
	exit 1
fi

rm -f $NASC_FOLDER/SSD_In/*
mkdir -p $NASC_FOLDER/SSD_In
mkdir -p $NASC_FOLDER/SSD_Out
cp $NASC_FOLDER/SBP_Out/*.lbs $NASC_FOLDER/SSD_In

stage2rel=$NASC_FOLDER/../stage2_without_FIH.bin
if [ ! -f "$stage2rel" ]; then
	echo "No production stage2"
	exit 1
fi

find $NASC_FOLDER/SSD_In -type f -name \*.pro.lbs | xargs -i sh -c 'cat {} '$stage2rel' > {}.cat'

find $NASC_FOLDER/SSD_In -type f -name \*.cat | xargs -i sh -c 'gpg -e -r "NASC Signing" --trust-mode always --yes {}'

rm -f $NASC_FOLDER/SSD_In/*.lbs
rm -f $NASC_FOLDER/SSD_In/*.cat

sync
