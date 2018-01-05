#!/bin/bash

source ./config.sh

find $NASC_FOLDER/Enc_Out -type f | xargs -i sh -c 'gpg -e -r "NASC Signing" --trust-mode always --yes {}'

rm -f $NASC_FOLDER/SBP_In/*
mkdir -p $NASC_FOLDER/SBP_In
mkdir -p $NASC_FOLDER/SBP_Out
mv $NASC_FOLDER/Enc_Out/*.gpg $NASC_FOLDER/SBP_In

sync

