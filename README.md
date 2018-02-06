## Clover laptop config.plist and hotpatch

This project contains config.plist files for common laptops with Intel graphics.

It is linked by this guide: http://www.tonymacx86.com/el-capitan-laptop-support/148093-guide-booting-os-x-installer-laptops-clover.html

Refer to the guide for details on usage of the various system specfic config*.plist files.

--

There are also some handy SSDTs for use with Clover ACPI hotpatch (in conjunction with hotpatch/config.plist)
If you understand ACPI, you may find the SSDTs and hotpatch/config.plist quite useful.

Read here for the hotpatch guide:
https://www.tonymacx86.com/threads/guide-using-clover-to-hotpatch-acpi.200137/

A brief description of each hotpatch SSDT is provided below:

SSDT-RMCF.dsl
This file provides configuration data for other SSDTs.  Read the comments within the file for more information.

SSDT-RMDT.dsl
This SSDT is for use with ACPIDebug.kext.  Instead of patching your DSDT to add the RMDT device, you can use this SSDT and refer to the methods with External.  See ACPIDebug.kext documentation for more information regarding the RMDT methods.

SSDT-XOSI.dsl
This SSDT provides the XOSI method, which is a replacement for the system provided _OSI object when the _OSI->XOSI patch is being used.  This is actually one of the examples in the Clover ACPI hotpatch guide, linked above.

SSDT-IGPU.dsl
This SSDT injects Intel GPU properties depending on the configuration data in SSDT-RMCF and the device-id that is discovered to be present on the system.  It assumes the IGPU is named IGPU (typical is GFX0, requring GFX0->IGPU rename).
Configured with RMCF.TYPE, RMCF.HIGH, RMCF.IGPI, and SSDT-SKLSPF.aml.

SSDT-SKLSPF.aml
This SSDT is an optional SSDT that can be paired with SSDT-IGPU.dsl.  When present, SSDT-IGPU uses the data within as an override for various KabyLake graphics devices which spoofs those devices as Skylake.  Prior to 10.12.6, Skylake spoofing is the only option for KabyLake graphics.  And even with 10.12.6 (or later, including 10.13.x), it still may be useful to spoof KabyLake graphics as Skyake.  Keep in mind complete Skylake spoofing requires FakePCIID.kext + FakePCIID_Intel_HD_Graphics.kext.

SSDT-IMEI.dsl
This SSDT injects fake device-id as required for IMEI when using mixed HD3000/7-series or HD4000/6-series.
Be sure to read the comments within carefully, as customization is required if your system already has an IMEI identity in ACPI.

SSDT-PNLF.dsl
This SSDT injects a PNLF device that works with IntelBacklight.kext or AppleBacklight.kext.
Configured with RMCF.BKLT, RMCF.LMAX, RMCF.FBTP.
See guide for more information: https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightinjector-kext.218222/

SSDT-LPC.dsl
This SSDT injects properties to force AppleLPC to load for various unsupported LPC device-ids.  It assumes the LPC device is named LPCB.

SSDT-SATA.dsl
This SSDT injects properties (fake device-id, compatible) to enable the SATA controller with certain unsupported SATA controllers.  It assumes the SATA device is named SATA (typical is SAT0, thus requiring SAT0->SATA rename).

SSDT-DDGPU.dsl
This SSDT provides an _INI method that will call _OFF for a couple of common paths for a discrete GPU in a switched/dual GPU scenario.  This SSDT can work to disable the Nvidia or AMD graphics device, if the path matches (or is modified to math) and your _OFF method code path has no EC related code.
Refer to the hotpatch guide for a complete example.

SSDT-SMBUS.dsl
This SSDT injects the missing DVL0 device.  Mostly used with Sandy Bridge and Ivy Bridge systems.

SSDT-GPRW.dsl and SSDT-UPRW.dsl
This SSDT  is used in conjuction with the GPRW->XPRW or UPRW->XPRW patch.  Used together this SSDT can fix "instant-wake" by disabling "wake on USB".  It overrides the _PRW package return for GPE indexes 0x0d or 0x6d.
Potential companion patches are provided in hotpatch/config.plist 

SSDT-LANCPRW.dsl
Also part of fixing "instant wake", but this is for _PRW on the Ethernet device.
Potential companion patches are provided in hotpatch/config.plist.

SSDT-PTSWAK.dsl
This SSDT provides overrides for both _PTS and _WAK.
When combined with the appropriate companion patches from hotpatch/config.plist, these methods can provide various fixes.
The actions are controlled by RMCF.DPTS, RMCF.SHUT, RMCF.XPEE, RMCF.SSTF.
Refer to SSDT-RMCF.dsl for more information on those options.

SSDT-DEHCI.dsl
This SSDT can disable both EHCI controllers.  It is assumed both have been renamed to EH01/EH02 (typically original names are EHC1/EHC2)

SSDT-DEH01.dsl, SSDT-DEH02.dsl
Each of these SSDTs is just SSDT-DEHCI.dsl broken down to only disable EH01 or only EH02.
Use as appropriate depending on which EHCI controllers are active/present in your ACPI set.

SSDT-XWAK.dsl, SSDT-XSEL.dsl, SSDT-ESEL.dsl
Each of these SSDTs provides an empty XWAK, XSEL, and ESEL methods (respectively).
Use with the appropriate companion patch from hotpatch/config.plist.
Typically, these methods are disabled (by having no code in them) to disable certain actions native ACPI may be doing on wake from sleep or during startup that cause problems with the xHCI/EHCI configuration.

SSDT-XCPM.dsl
This SSDT injects "plugin-type"=1 on CPU0.  It assumes ACPI Processor objects are in Scope(_PR).
It can be used to enable native CPU power management on Haswell and later CPUs.
See guide for more information: https://www.tonymacx86.com/threads/guide-native-power-management-for-laptops.175801/

SSDT-HDEF.dsl and SSDT-HDAU.dsl
Injects layout-id, hda-gfx, and PinConfiguration properties on HDEF and HDAU in order to implement audio with patched AppleHDA.kext
Configured with: RMCF.AUDL

SSDT-EH01.dsl, SSDT-EH02.dsl, and SSDT-XHC.dsl
These SSDTs  inject USB power properties and control over FakePCIID_XHCIMux (dending on SSDT-DEH*.dsl).

SSDT-ALS0.dsl
Injects a fake ALS device (ambient light sensor).  This SSDT is used to fix problems with restoring brightness upon reboot.


