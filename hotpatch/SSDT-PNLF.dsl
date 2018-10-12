// Adding PNLF device for IntelBacklight.kext or AppleBacklight.kext+AppleBacklightInjector.kext

#define SANDYIVY_PWMMAX 0x710
#define HASWELL_PWMMAX 0xad9
#define SKYLAKE_PWMMAX 0x56c
#define CUSTOM_PWMMAX_07a1 0x07a1
#define CUSTOM_PWMMAX_1499 0x1499
#define COFFEELAKE_PWMMAX 0xffff

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_PNLF", 0)
{
#endif
    External(RMCF.BKLT, IntObj)
    External(RMCF.LMAX, IntObj)
    External(RMCF.LEVW, IntObj)
    External(RMCF.GRAN, IntObj)
    External(RMCF.FBTP, IntObj)

    External(_SB.PCI0.IGPU, DeviceObj)
    Scope(_SB.PCI0.IGPU)
    {
        OperationRegion(RMP3, PCI_Config, 0, 0x14)
    }

    // For backlight control
    Device(_SB.PCI0.IGPU.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId ("APP0002"))
        Name(_CID, "backlight")
        // _UID is set depending on PWMMax
        // 14: Sandy/Ivy 0x710
        // 15: Haswell/Broadwell 0xad9
        // 16: Skylake/KabyLake 0x56c (and some Haswell, example 0xa2e0008)
        // 17: custom LMAX=0x7a1
        // 18: custom LMAX=0x1499
        // 19: CoffeeLake 0xff7b
        // 99: Other (requires custom AppleBacklightInjector.kext)
        Name(_UID, 0)
        Name(_STA, 0x0B)

        Field(^RMP3, AnyAcc, NoLock, Preserve)
        {
            Offset(0x02), GDID,16,
            Offset(0x10), BAR1,32,
        }
        OperationRegion(RMB1, SystemMemory, BAR1 & ~0xF, 0xe1184)
        Field(RMB1, AnyAcc, Lock, Preserve)
        {
            Offset(0x48250),
            LEV2, 32,
            LEVL, 32,
            Offset(0x70040),
            P0BL, 32,
            Offset(0xc2000),
            GRAN, 32,
            Offset(0xc8250),
            LEVW, 32,
            LEVX, 32,
            Offset(0xe1180),
            PCHL, 32,
        }

        Method(_INI)
        {
            // IntelBacklight.kext takes care of this at load time...
            // If RMCF.BKLT does not exist, it is assumed you want to use AppleBacklight.kext...
            Local4 = 1
            If (CondRefOf(\RMCF.BKLT)) { Local4 = \RMCF.BKLT }
            If (0 == (1 & Local4)) { Return }

            // Adjustment required when using AppleBacklight.kext
            Local0 = ^GDID
            Local2 = Ones
            If (CondRefOf(\RMCF.LMAX)) { Local2 = \RMCF.LMAX }
            // Determine framebuffer type (for PWM register layout)
            Local3 = 0
            If (CondRefOf(\RMCF.FBTP)) { Local3 = \RMCF.FBTP }
            If (0 == Local3)
            {
                If (Ones != Match(Package()
                {
                    // Sandy HD3000
                    0x010b, 0x0102,
                    0x0106, 0x1106, 0x1601, 0x0116, 0x0126,
                    0x0112, 0x0122,
                    // Ivy
                    0x0152, 0x0156, 0x0162, 0x0166,
                    0x016a,
                    // Arrandale
                    0x0046, 0x0042,
                }, MEQ, Local0, MTR, 0, 0))
                {
                    Local3 = 1
                }
                Else
                {
                    // otherwise... Assume Haswell/Broadwell/Skylake
                    Local3 = 2
                }
            }

            // Local3 is now framebuffer type, depending on RMCF.FBTP or device-id detect
            If (1 == Local3)
            {
                // Sandy/Ivy
                if (Ones == Local2) { Local2 = SANDYIVY_PWMMAX }

                // change/scale only if different than current...
                Local1 = ^LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMMax but retain current backlight level by scaling
                    Local0 = (^LEVL * Local2) / Local1
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = ^P0BL, ^P0BL == Local7, ) { }
                    Local3 = Local2 << 16
                    If (Local2 > Local1)
                    {
                        // PWMMax is getting larger... store new PWMMax first
                        ^LEVX = Local3
                        ^LEVL = Local0
                    }
                    Else
                    {
                        // otherwise, store new brightness level, followed by new PWMMax
                        ^LEVL = Local0
                        ^LEVX = Local3
                    }
                }
            }
            ElseIf (2 == Local3) // No other values are valid for RMCF.FBTP
            {
                // otherwise... Assume Haswell/Broadwell/Skylake/KabyLake/KabyLake-R
                if (Ones == Local2)
                {
                    // check Haswell and Broadwell, as they are both 0xad9 (for most common ig-platform-id values)
                    If (Ones != Match(Package()
                    {
                        // Haswell
                        0x0d26, 0x0a26, 0x0d22, 0x0412, 0x0416, 0x0a16, 0x0a1e, 0x0a1e, 0x0a2e, 0x041e, 0x041a,
                        // Broadwell
                        0x0bd1, 0x0bd2, 0x0BD3, 0x1606, 0x160e, 0x1616, 0x161e, 0x1626, 0x1622, 0x1612, 0x162b,
                    }, MEQ, Local0, MTR, 0, 0))
                    {
                        Local2 = HASWELL_PWMMAX
                    }
                    // check CoffeeLake
                    ElseIf (Ones != Match(Package()
                    {
                        // CoffeeLake identifiers from AppleIntelCFLGraphicsFramebuffer.kext
                        0x3e9b, 0x3ea5, 0x3e92, 0x3e91,
                    }, MEQ, Local0, MTR, 0, 0))
                    {
                        Local2 = COFFEELAKE_PWMMAX
                    }
                    Else
                    {
                        // assume Skylake/KabyLake/KabyLake-R, both 0x56c
                        // 0x1916, 0x191E, 0x1926, 0x1927, 0x1912, 0x1932, 0x1902, 0x1917, 0x191b,
                        // 0x5916, 0x5912, 0x591b, others...
                        Local2 = SKYLAKE_PWMMAX
                    }
                }
                // INTEL OPEN SOURCE HD GRAPHICS, INTEL IRIS GRAPHICS, AND INTEL IRIS PRO GRAPHICS PROGRAMMER'S REFERENCE MANUAL (PRM)
                // FOR THE 2015-2016 INTEL CORE PROCESSORS, CELERON PROCESSORS AND PENTIUM PROCESSORS BASED ON THE "SKYLAKE" PLATFORM
                // Volume 12: Display (https://01.org/sites/default/files/documentation/intel-gfx-prm-osrc-skl-vol12-display.pdf)
                //   page 189
                //   Backlight Enabling Sequence
                //   Description
                //   1. Set frequency and duty cycle in SBLC_PWM_CTL2 Backlight Modulation Frequency and Backlight Duty Cycle.
                //   2. Set granularity in 0xC2000 bit 0 (0 = 16, 1 = 128).
                //   3. Enable PWM output and set polarity in SBLC_PWM_CTL1 PWM PCH Enable and Backlight Polarity.
                //   4. Change duty cycle as needed in SBLC_PWM_CTL2 Backlight Duty Cycle.
                // This 0xC value comes from looking what OS X initializes this
                // register to after display sleep (using ACPIDebug/ACPIPoller)
                If (0 == (2 & Local4))
                {
                    Local5 = 0xC0000000
                    If (CondRefOf(\RMCF.LEVW)) { If (Ones != \RMCF.LEVW) { Local5 = \RMCF.LEVW } }
                    ^LEVW = Local5
                }
                // from step 2 above (you may need 1 instead)
                If (4 & Local4)
                {
                    If (CondRefOf(\RMCF.GRAN)) { ^GRAN = \RMCF.GRAN }
                    Else { ^GRAN = 0 }
                }

                // change/scale only if different than current...
                Local1 = ^LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMAX but retain current backlight level by scaling
                    Local0 = (((^LEVX & 0xFFFF) * Local2) / Local1) | (Local2 << 16)
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = ^P0BL, ^P0BL == Local7, ) { }
                    ^LEVX = Local0
                }
            }

            // Now Local2 is the new PWMMax, set _UID accordingly
            // The _UID selects the correct entry in AppleBacklightInjector.kext
            If (Local2 == SANDYIVY_PWMMAX) { _UID = 14 }
            ElseIf (Local2 == HASWELL_PWMMAX) { _UID = 15 }
            ElseIf (Local2 == SKYLAKE_PWMMAX) { _UID = 16 }
            ElseIf (Local2 == CUSTOM_PWMMAX_07a1) { _UID = 17 }
            ElseIf (Local2 == CUSTOM_PWMMAX_1499) { _UID = 18 }
            ElseIf (Local2 == COFFEELAKE_PWMMAX) { _UID = 19 }
            Else { _UID = 99 }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF

