// Adding PNLF device for IntelBacklight.kext

//REVIEW: come up with table driven effort here...
#define SANDYIVY_PWMMAX 0x710
#define HASWELL_PWMMAX 0xad9

DefinitionBlock("", "SSDT", 2, "hack", "PNLF", 0)
{
    External(RMCF.BKLT, IntObj)
    External(RMCF.LMAX, IntObj)
    External(_SB.PCI0.IGPU.GDID, FieldUnitObj)
    External(_SB.PCI0.IGPU.BAR1, FieldUnitObj)

    // For backlight control
    Device(_SB.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId ("APP0002"))
        Name(_CID, "backlight")
        Name(_UID, 10)
        Name(_STA, 0x0B)

        OperationRegion(RMB1, SystemMemory, \_SB.PCI0.IGPU.BAR1 & ~0xF, 0xe1184)
        Field(RMB1, AnyAcc, Lock, Preserve)
        {
            Offset(0x48250),
            LEV2, 32,
            LEVL, 32,
            Offset(0x70040),
            P0BL, 32,
            Offset(0xc8250),
            LEVW, 32,
            LEVX, 32,
            Offset(0xe1180),
            PCHL, 32,
        }

        Method(_INI)
        {
            // IntelBacklight.kext takes care of this at load time...
            If (1 != \RMCF.BKLT) { Return }

            // Adjustment required when using AppleBacklight.kext
            Local0 = \_SB.PCI0.IGPU.GDID
            If (Ones != Match(Package() { 0x0116, 0x0126, 0x0112, 0x0122, 0x0166, 0x42, 0x46 }, MEQ, Local0, MTR, 0, 0))
            {
                // Sandy/Ivy
                Local2 = \RMCF.LMAX
                if (Ones == \RMCF.LMAX) { Local2 = SANDYIVY_PWMMAX }

                // change/scale only if different than current...
                Local1 = LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMAX but retain current backlight level by scaling
                    Local0 = (LEVL * Local2) / Local1
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = P0BL, P0BL == Local7, ) { }
                    LEVL = Local0
                    LEVX = Local2 << 16
                }
            }
            Else
            {
                // otherwise... Assume Haswell/Broadwell/Skylake
                Local2 = \RMCF.LMAX
                if (Ones == \RMCF.LMAX) { Local2 = HASWELL_PWMMAX }

                // This 0xC value comes from looking what OS X initializes this\n
                // register to after display sleep (using ACPIDebug/ACPIPoller)\n
                LEVW = 0xC0000000

                // change/scale only if different than current...
                Local1 = LEVX >> 16
                If (!Local1) { Local1 = Local2 }
                If (Local2 != Local1)
                {
                    // set new backlight PWMAX but retain current backlight level by scaling
                    Local0 = (((LEVX & 0xFFFF) * Local2) / Local1) | (Local2 << 16)
                    //REVIEW: wait for vblank before setting new PWM config
                    //For (Local7 = P0BL, P0BL == Local7, ) { }
                    LEVX = Local0
                }
            }
        }
    }
}
//EOF
