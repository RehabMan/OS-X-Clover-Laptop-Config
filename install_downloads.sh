#!/bin/bash
#set -x

# customize EXCEPTIONS and ESSENTIAL as needed
EXCEPTIONS=
ESSENTIAL=
# customize HDA to indicate your HDA resources/HDA codec
#HDA=ALC283

# include subroutines
DIR=$(dirname ${BASH_SOURCE[0]})
source "$DIR/tools/_install_subs.sh"

warn_about_superuser

# install tools
install_tools

# remove old kexts
# EHCI is disabled, so no need for FakePCIID_XHCIMux.kext
remove_deprecated_kexts
#remove_kext FakePCIID_XHCIMux.kext
# remove other kexts not used anymore...
#remove_kext Example.kext

# install required kexts
install_download_kexts
install_brcmpatchram_kexts
install_backlight_kexts

# install special download kexts
# for example, if you need FakePCIID_XHCIMux.kext
#install_fakepciid_xhcimux
# or other special FakePCIID injectors
#install_kext _downloads/kexts/RehabMan-FakePCIID*/Release/FakePCIID_AR9280_as_AR946x.kext

# create/install patched AppleHDA files
install_hda

# all kexts are now installed, so rebuild cache
rebuild_kernel_cache

# update kexts on EFI/CLOVER/kexts/Other
update_efi_kexts

# VoodooPS2Daemon is deprecated
remove_voodoops2daemon

#EOF
