// Adding PNLF device for IntelBacklight.kext

DefinitionBlock("", "SSDT", 2, "hack", "PNLF", 0)
{
    // For backlight control
    Device(_SB.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId ("APP0002"))
        Name(_CID, "backlight")
        Name(_UID, 10)
        Name(_STA, 0x0B)
    }
}
//EOF
