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

source ./downloader.sh 7428 SBP
if [ $? -ne 0 ]; then
	exit 1
fi

source ./pgp2_ip.sh
if [ $? -ne 0 ]; then
	exit 1
fi

source ./downloader.sh 7428 SSD
if [ $? -ne 0 ]; then
	exit 1
fi

source ./pgp3_ip.sh
if [ $? -ne 0 ]; then
	exit 1
fi

