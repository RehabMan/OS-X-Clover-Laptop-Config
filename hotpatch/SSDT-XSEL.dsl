// Disabling XSEL

DefinitionBlock("", "SSDT", 2, "hack", "_XSEL", 0)
{
    // In DSDT, native XSEL is renamed ZSEL
    // As a result, calls to it land here.
    Method(_SB.PCI0.XHC.XSEL)
    {
        // do nothing
    }
}
//EOF
