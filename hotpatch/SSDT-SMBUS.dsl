// Adding SMBUS device

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_SMBUS", 0)
{
#endif
    Device(_SB.PCI0.SBUS.BUS0)
    {
        Name(_CID, "smbus")
        Name(_ADR, Zero)
        Device(DVL0)
        {
            Name(_ADR, 0x57)
            Name(_CID, "diagsvault")
            Method(_DSM, 4)
            {
                If (!Arg2) { Return (Buffer() { 0x03 } ) }
                Return (Package() { "address", 0x57 })
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
