// Disabling XWAK

DefinitionBlock("", "SSDT", 2, "hack", "_XWAK", 0)
{
    External(_SB.PCI0.XHC, DeviceObj)

    // In DSDT, native XWAK is renamed ZWAK
    // As a result, calls to it land here.
    Method(_SB.PCI0.XHC.XWAK)
    {
        // do nothing
    }
}
//EOF
