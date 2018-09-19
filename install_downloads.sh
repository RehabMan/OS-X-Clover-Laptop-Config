#set -x

SUDO=sudo
#SUDO='echo #'
#SUDO=nothing
TAG=tag_file
TAGCMD=`pwd`/tools/tag
SLE=/System/Library/Extensions
LE=/Library/Extensions
EXCEPTIONS="Sensors|FakePCIID_AR9280|FakePCIID_Broadcom_WiFi.kext|BrcmPatchRAM|BrcmBluetoothInjector|BrcmFirmwareData|USBInjectAll|WhateverName"
ESSENTIAL="FakeSMC.kext RealtekRTL8111.kext IntelMausiEthernet.kext USBInjectAll.kext Lilu.kext WhateverGreen.kext AppleBacklightInjector.kext IntelBacklight.kext"

# extract minor version (eg. 10.9 vs. 10.10 vs. 10.11)
MINOR_VER=$([[ "$(sw_vers -productVersion)" =~ [0-9]+\.([0-9]+) ]] && echo ${BASH_REMATCH[1]})

# install to /Library/Extensions for 10.11 or greater
if [[ $MINOR_VER -ge 11 ]]; then
    KEXTDEST=$LE
else
    KEXTDEST=$SLE
fi

# this could be removed if 'tag' can be made to work on old systems
function tag_file
{
    if [[ $MINOR_VER -ge 9 ]]; then
        $SUDO "$TAGCMD" "$@"
    fi
}

function check_directory
{
    for x in $1; do
        if [ -e "$x" ]; then
            return 1
        else
            return 0
        fi
    done
}

function nothing
{
    :
}

function remove_kext
{
    $SUDO rm -Rf $SLE/"$1" $LE/"$1"
}

function install_kext
{
    if [ "$1" != "" ]; then
        echo installing $1 to $KEXTDEST
        remove_kext `basename $1`
        $SUDO cp -Rf $1 $KEXTDEST
        $TAG -a Gray $KEXTDEST/`basename $1`
    fi
}

function install_app
{
    if [ "$1" != "" ]; then
        echo installing $1 to /Applications
        $SUDO rm -Rf /Applications/`basename $1`
        $SUDO cp -Rf $1 /Applications
        $TAG -a Gray /Applications/`basename $1`
    fi
}

function install_binary
{
    if [ "$1" != "" ]; then
        echo installing $1 to /usr/bin
        $SUDO rm -f /usr/bin/`basename $1`
        $SUDO cp -f $1 /usr/bin
        $TAG -a Gray /usr/bin/`basename $1`
    fi
}

function install
{
    installed=0
    out=${1/.zip/}
    rm -Rf $out/* && unzip -q -d $out $1
    check_directory $out/Release/*.kext
    if [ $? -ne 0 ]; then
        for kext in $out/Release/*.kext; do
            # install the kext when it exists regardless of filter
            kextname="`basename $kext`"
            if [[ -e "$SLE/$kextname" || -e "$KEXTDEST/$kextname" || "$2" == "" || "`echo $kextname | grep -vE "$2"`" != "" ]]; then
                install_kext $kext
            fi
        done
        installed=1
    fi
    check_directory $out/*.kext
    if [ $? -ne 0 ]; then
        for kext in $out/*.kext; do
            # install the kext when it exists regardless of filter
            kextname="`basename $kext`"
            if [[ -e "$SLE/$kextname" || -e "$KEXTDEST/$kextname" || "$2" == "" || "`echo $kextname | grep -vE "$2"`" != "" ]]; then
                install_kext $kext
            fi
        done
        installed=1
    fi
    check_directory $out/Release/*.app
    if [ $? -ne 0 ]; then
        for app in $out/Release/*.app; do
            # install the app when it exists regardless of filter
            appname="`basename $app`"
            if [[ -e "/Applications/$appname" || -e "/Applications/$appname" || "$2" == "" || "`echo $appname | grep -vE "$2"`" != "" ]]; then
                install_app $app
            fi
        done
        installed=1
    fi
    check_directory $out/*.app
    if [ $? -ne 0 ]; then
        for app in $out/*.app; do
            # install the app when it exists regardless of filter
            appname="`basename $app`"
            if [[ -e "/Applications/$appname" || -e "/Applications/$appname" || "$2" == "" || "`echo $appname | grep -vE "$2"`" != "" ]]; then
                install_app $app
            fi
        done
        installed=1
    fi
    if [ $installed -eq 0 ]; then
        check_directory $out/*
        if [ $? -ne 0 ]; then
            for tool in $out/*; do
                install_binary $tool
            done
        fi
    fi
}

if [ "$(id -u)" != "0" ]; then
    echo "This script requires superuser access..."
fi

# unzip/install kexts
check_directory ./downloads/kexts/*.zip
if [ $? -ne 0 ]; then
    echo Installing kexts...
    cd ./downloads/kexts
    for kext in *.zip; do
        install $kext "$EXCEPTIONS"
    done
    if [[ $MINOR_VER -ge 11 ]]; then
        # 10.11 needs BrcmPatchRAM2.kext
        cd RehabMan-BrcmPatchRAM*/Release && install_kext BrcmPatchRAM2.kext && cd ../..
        # 10.11 needs USBInjectAll.kext
        cd RehabMan-USBInjectAll*/Release && install_kext USBInjectAll.kext && cd ../..
        # remove BrcPatchRAM.kext just in case
        remove_kext BrcmPatchRAM.kext
        # remove injector just in case
        remove_kext BrcmBluetoothInjector.kext
    else
        # prior to 10.11, need BrcmPatchRAM.kext
        cd RehabMan-BrcmPatchRAM*/Release && install_kext BrcmPatchRAM.kext && cd ../..
        # remove BrcPatchRAM2.kext just in case
        remove_kext BrcmPatchRAM2.kext
        # remove injector just in case
        remove_kext BrcmBluetoothInjector.kext
    fi
    # this guide does not use BrcmFirmwareData.kext
    remove_kext BrcmFirmwareData.kext
    # now using IntelBacklight.kext instead of ACPIBacklight.kext
    remove_kext ACPIBacklight.kext
    # deal with some renames
    remove_kext FakePCIID_BCM94352Z_as_BCM94360CS2.kext
    remove_kext FakePCIID_HD4600_HD4400.kext
    # IntelGraphicsFixup.kext is no longer used (replaced by WhateverGreen.kext)
    remove_kext IntelGraphicsFixup.kext
    # using AirportBrcmFixup.kext instead of FakePCIID_Broadcom_WiFi.kext
    remove_kext FakePCIID_Broadcom_WiFi.kext
    cd ../..
fi

# force cache rebuild with output
$SUDO touch $SLE && $SUDO kextcache -u /

# install/update kexts on EFI/Clover/kexts/Other
EFI=`./mount_efi.sh`
echo Updating kexts at EFI/Clover/kexts/Other
for kext in $ESSENTIAL; do
    if [[ -e $KEXTDEST/$kext ]]; then
        echo updating $EFI/EFI/CLOVER/kexts/Other/$kext
        cp -Rf $KEXTDEST/$kext $EFI/EFI/CLOVER/kexts/Other
    fi
    rm -Rf $EFI/EFI/CLOVER/kexts/Other/IntelGraphicsFixup.kext
done

# unzip/install tools
check_directory ./downloads/tools/*.zip
if [ $? -ne 0 ]; then
    echo Installing tools...
    cd ./downloads/tools
    for tool in *.zip; do
        install $tool
    done
    cd ../..
fi

# install VoodooPS2Daemon
echo Installing VoodooPS2Daemon to /usr/bin and /Library/LaunchDaemons...
cd ./downloads/kexts/RehabMan-Voodoo-*
$SUDO cp ./Release/VoodooPS2Daemon /usr/bin
$TAG -a Gray /usr/bin/VoodooPS2Daemon
$SUDO cp ./org.rehabman.voodoo.driver.Daemon.plist /Library/LaunchDaemons
$TAG -a Gray /Library/LaunchDaemons/org.rehabman.voodoo.driver.Daemon.plist
cd ../..
