#!/bin/bash

source ./config.sh

arg_model=$1
if [ "$arg_model" = "7428" ]||[ "$arg_model" = "GX-SH435EH" ]; then
	model=GX-SH435EH
elif [ "$arg_model" = "7231" ]||[ "$arg_model" = "GX-SH530CF" ]; then
	model=GX-SH530CF
else
	echo "Unknown Model: "$arg_model
	exit 1
fi

arg_signing_type=$2
if [ "$arg_signing_type" = "SBP" ]; then
	signing_type=SBP
elif [ "$arg_signing_type" = "SSD" ]; then
	signing_type=SSD
else
	echo "Unknown Signing type: "$arg_signing_type
	exit 1
fi

if [ -z "$PASSWORD" ]; then
	echo -n "Password for user "$NASC_USER": "
	read -s PASSWORD
	echo -e "\r"
fi

echo $(date +%m-%d\ %H:%M:%S)": (*) Start file uploading"
export PASSWORD
out=`python uploader.py $model $signing_type`
c2number=`echo $out | cut -d ';' -f 5 | awk '{print $2}'`

echo "C2 Number: "$c2number

if [ ${#c2number} -lt 6 ]; then
	echo "Invalid Nagra C2 number: "$c2number
	exit 1
fi
echo $(date +%m-%d\ %H:%M:%S)": (*) File uploading is done"

sleep 2100s

echo $(date +%m-%d\ %H:%M:%S)": (*) Start FTP downloading"
mkdir -p $NASC_FOLDER/${signing_type}_Out
rm -rf $NASC_FOLDER/${signing_type}_Out/*
for file in $(ls $NASC_FOLDER/${signing_type}_In)
do
	if [ "$signing_type" = "SBP" ]; then
		wget --quiet -P $NASC_FOLDER/${signing_type}_Out ftp://ftp.nagra.com/NASC_signing/$c2number/MOD/${file%.*}.lbs.md5 --ftp-user=$FTP_USER --ftp-password=$FTP_PASSWORD &
		wget --quiet -P $NASC_FOLDER/${signing_type}_Out ftp://ftp.nagra.com/NASC_signing/$c2number/MOD/${file%.*}.lbs.pgp --ftp-user=$FTP_USER --ftp-password=$FTP_PASSWORD &
	elif [ "$signing_type" = "SSD" ]; then
		wget --quiet -P $NASC_FOLDER/${signing_type}_Out ftp://ftp.nagra.com/NASC_signing/$c2number/SSD/${file%.*}_ssd1.lbs.md5 --ftp-user=$FTP_USER --ftp-password=$FTP_PASSWORD &
		wget --quiet -P $NASC_FOLDER/${signing_type}_Out ftp://ftp.nagra.com/NASC_signing/$c2number/SSD/${file%.*}_ssd1.lbs.pgp --ftp-user=$FTP_USER --ftp-password=$FTP_PASSWORD &
	fi
	sleep 15s
done

sleep 1800s

echo $(date +%m-%d\ %H:%M:%S)": (*) Check downloading status periodically"
cd $NASC_FOLDER/${signing_type}_Out/
while sleep 600s
do
	echo $(date +%m-%d\ %H:%M:%S)": check md5"
	md5sum --quiet -c $NASC_FOLDER/${signing_type}_Out/*.md5
	if [ $? -eq 0 ]; then
		break
	fi
done
md5sum --quiet -c $NASC_FOLDER/${signing_type}_Out/*.md5
if [ $? -ne 0 ]; then
	cd -
	echo $(date +%m-%d\ %H:%M:%S)": (*) FTP downloading: Detected MD5 error"
	exit 1
fi
cd -
echo $(date +%m-%d\ %H:%M:%S)": (*) FTP downloading is done"

