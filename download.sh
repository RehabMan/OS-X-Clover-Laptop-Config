#set -x

function download()
{
    echo "downloading $2:"
    curl --location --silent --output /tmp/org.rehabman.download.txt https://bitbucket.org/RehabMan/$1/downloads
    scrape=`grep -o -m 1 "/RehabMan/$1/downloads/$2.*\.zip" /tmp/org.rehabman.download.txt|perl -ne 'print $1 if /(.*)\"/'`
    url=https://bitbucket.org$scrape
    echo $url
    if [ "$3" == "" ]; then
        curl --remote-name --progress-bar --location "$url"
    else
        curl --output "$3" --progress-bar --location "$url"
    fi
    echo
}

if [ ! -d ./downloads ]; then mkdir ./downloads; fi && rm -Rf downloads/* && cd ./downloads

# download kexts
mkdir ./kexts && cd ./kexts
download os-x-fakesmc-kozlek RehabMan-FakeSMC
download os-x-voodoo-ps2-controller RehabMan-Voodoo
download os-x-realtek-network RehabMan-Realtek-Network
download os-x-intel-network RehabMan-IntelMausiEthernet
#download os-x-acpi-backlight RehabMan-Backlight
download os-x-intel-backlight RehabMan-IntelBacklight
download os-x-acpi-battery-driver RehabMan-Battery
download os-x-eapd-codec-commander RehabMan-CodecCommander
download os-x-fake-pci-id RehabMan-FakePCIID
download os-x-brcmpatchram RehabMan-BrcmPatchRAM
download os-x-atheros-3k-firmware RehabMan-Atheros
#download os-x-acpi-poller RehabMan-Poller
download os-x-usb-inject-all RehabMan-USBInjectAll
#download os-x-acpi-debug RehabMan-Debug
cd ..

# download tools
mkdir ./tools && cd ./tools
download os-x-maciasl-patchmatic RehabMan-patchmatic
download os-x-maciasl-patchmatic RehabMan-MaciASL
download acpica iasl iasl.zip
cd ..

# download Clover related (HPFanReset.efi)
mkdir ./efi && cd ./efi
download hp-probook-4x30s-fan-reset HPFanReset
cd ..
