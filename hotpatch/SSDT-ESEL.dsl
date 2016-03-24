// Disabling ESEL

DefinitionBlock("", "SSDT", 2, "hack", "ESEL", 0)
{
    External(_SB.PCI0.XHC, DeviceObj)

    // In DSDT, native ESEL is renamed ESEX
    // As a result, calls to it land here.
    Method(_SB.PCI0.XHC.ESEL)
    {
        // do nothing
    }
}
//EOF
