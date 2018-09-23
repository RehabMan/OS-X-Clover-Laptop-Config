#!/bin/bash
#set -x

# get copy of tools if not present
if [[ ! -d ./tools ]]; then
    git clone https://github.com/RehabMan/hack-tools.git tools
fi
# update tools to latest
if [[ -e ./tools/.git ]]; then
    cd ./tools && git pull
    cd ..
fi

# include subroutines
DIR=$(dirname ${BASH_SOURCE[0]})
source "$DIR/tools/_download_subs.sh"

# remove deprecated downloads directory to avoid confusion
if [[ -e ./downloads ]]; then rm -Rf ./downloads; fi

# create _downloads directory and clean
if [[ ! -d ./_downloads ]]; then mkdir ./_downloads; fi && rm -Rf ./_downloads/* && cd ./_downloads

# download kexts
mkdir ./kexts && cd ./kexts
download_rehabman os-x-fakesmc-kozlek RehabMan-FakeSMC
download_rehabman os-x-voodoo-ps2-controller RehabMan-Voodoo
download_rehabman os-x-realtek-network RehabMan-Realtek-Network
#download os-x-acpi-backlight RehabMan-Backlight
#download os-x-intel-backlight RehabMan-IntelBacklight
download_rehabman os-x-acpi-battery-driver RehabMan-Battery
download_rehabman os-x-eapd-codec-commander RehabMan-CodecCommander
download_rehabman os-x-fake-pci-id RehabMan-FakePCIID
download_rehabman os-x-brcmpatchram RehabMan-BrcmPatchRAM
download_rehabman os-x-atheros-3k-firmware RehabMan-Atheros
download_rehabman os-x-usb-inject-all RehabMan-USBInjectAll
#download os-x-acpi-debug RehabMan-Debug
download_acidanthera Lilu acidanthera-Lilu
download_acidanthera WhateverGreen acidanthera-WhateverGreen
download_acidanthera AirportBrcmFixup acidanthera-AirportBrcmFixup
download_acidanthera BT4LEContiunityFixup acidanthera-BT4LEContiunityFixup
cd ..

# download tools
mkdir ./tools && cd ./tools
download_rehabman os-x-maciasl-patchmatic RehabMan-patchmatic
download_rehabman os-x-maciasl-patchmatic RehabMan-MaciASL
download_rehabman acpica iasl iasl.zip
cd ..

#EOF
