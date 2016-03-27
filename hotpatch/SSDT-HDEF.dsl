// Automatic injection of HDEF properties

DefinitionBlock("", "SSDT", 2, "hack", "HDEF", 0)
{
    External(_SB.PCI0.HDEF, DeviceObj)
    External(RMCF.AUDL, IntObj)

    // inject HDEF device if it doesn't exist
    If (!CondRefOf(_SB.PCI0.HDEF))
    {
        //REVIEW: not certain this really works...
        Device(HDEF)
        {
            Name(_ADR, 0x001B0000)
        }
    }

    // inject properties for audio
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Local0 = Package()
        {
            "layout-id", Buffer(4) { },
            "hda-gfx", Buffer() { "onboard-1" },
            "PinConfigurations", Buffer() { },
        }
        DerefOf(Local0[1]) = \RMCF.AUDL
        Return(Local0)
    }
}
//EOF
