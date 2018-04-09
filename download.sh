#set -x
curl_options="--retry 5 --location --progress-bar"
curl_options_silent="--retry 5 --location --silent"

# download typical release from RehabMan bitbucket downloads
function download()
# $1 is subdir on rehabman bitbucket
# $2 is prefix of zip file name
{
    echo "downloading $2:"
    curl $curl_options_silent --output /tmp/org.rehabman.download.txt https://bitbucket.org/RehabMan/$1/downloads/
    local scrape=`grep -o -m 1 "/RehabMan/$1/downloads/$2.*\.zip" /tmp/org.rehabman.download.txt|perl -ne 'print $1 if /(.*)\"/'`
    local url=https://bitbucket.org$scrape
    echo $url
    if [ "$3" == "" ]; then
        curl $curl_options --remote-name "$url"
    else
        curl $curl_options --output "$3" "$url"
    fi
    echo
}

# download latest release from github (perhaps others)
function download_latest_notbitbucket()
# $1 is main URL
# $2 is URL of release page
# $3 is partial file name to look for
# $4 is file name to rename to
{
    echo "downloading latest $4 from $2:"
    curl $curl_options_silent --output /tmp/org.rehabman.download.txt "$2"
    local scrape=`grep -o -m 1 "/.*$3.*\.zip" /tmp/org.rehabman.download.txt`
    local url=$1$scrape
    echo $url
    curl $curl_options --output "$4" "$url"
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
download_latest_notbitbucket "https://github.com" "https://github.com/vit9696/Lilu/releases" "RELEASE" "nbb_vit9696-Lilu.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/lvs1974/IntelGraphicsFixup/releases" "RELEASE" "nbb_lvs1974-IntelGraphicsFixup.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/PMHeart/CoreDisplayFixup/releases" "RELEASE" "nbb_PMHeart-CoreDisplayFixup.zip"
download_latest_notbitbucket "https://github.com" "https://github.com/BarbaraPalvin/IntelGraphicsDVMTFixup/releases" "IntelGraphicsDVMTFixup" "nbb_BarbaraPalvin-IntelGraphicsDVMTFixup.zip"
cd ..

# download tools
mkdir ./tools && cd ./tools
download os-x-maciasl-patchmatic RehabMan-patchmatic
download os-x-maciasl-patchmatic RehabMan-MaciASL
download acpica iasl iasl.zip
cd ..

# download Clover related (HPFanReset.efi, as example only, only for ProBook, so disabled)
mkdir ./efi && cd ./efi
#download hp-probook-4x30s-fan-reset HPFanReset
cd ..
