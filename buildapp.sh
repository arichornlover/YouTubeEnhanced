#!/bin/bash

cd "$(dirname "$0")"

# Makefile
if 	[ -d ./tmp ]
then
	rm -rf ./tmp
fi
	read -e -p "==> Path to the decrypted YouTube.ipa or YouTube.app: " PATHTOYT
if 	[[ $PATHTOYT == *.ipa ]]
then 
	unzip -q "$PATHTOYT" -d ./tmp
	rm -rf ./tmp/Payload/YouTube.app/PlugIns/*.appex
	cp -R Extensions/*.appex tmp/Payload/YouTube.app/PlugIns 
	make package
	open ./packages

elif	[[ $PATHTOYT == *.app ]]
then
	mkdir -p ./tmp/Payload/
	cp -R "$PATHTOYT" ./tmp/Payload 2>/dev/null
	rm -rf ./tmp/Payload/YouTube.app/PlugIns/*.appex
	cp -R Extensions/*.appex tmp/Payload/YouTube.app/PlugIns 
	make package
	open ./packages
else
	echo "This is not an ipa/app!"
fi

# Clean up	
	tput setaf 1 && echo -e "==> \033[1mCleaning up...\033[0m"
	rm -rf tmp/ Resources .theos/_/Payload
