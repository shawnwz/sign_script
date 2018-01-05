#!/bin/bash

source ./config.sh

if [ -z "$PASSWORD" ]; then
	echo -n "Password for user "$NASC_USER": "
	read -s PASSWORD
	echo -e "\r"
fi

if [ -z "$PASSPHRASE" ]; then
	echo -n "Passphrase: "
	read -s PASSPHRASE
	echo -e "\r"
fi

source ./pgp1.sh
if [ $? -ne 0 ]; then
	exit 1
fi

source ./downloader.sh 7231 SBP
if [ $? -ne 0 ]; then
	exit 1
fi

source ./pgp2_hdi.sh
if [ $? -ne 0 ]; then
	exit 1
fi

source ./downloader.sh 7231 SSD
if [ $? -ne 0 ]; then
	exit 1
fi

source ./pgp3_hdi.sh
if [ $? -ne 0 ]; then
	exit 1
fi

