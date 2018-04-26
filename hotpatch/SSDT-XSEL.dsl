// Disabling XSEL

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_XSEL", 0)
{
#endif
    // In DSDT, native XSEL is renamed ZSEL
    // As a result, calls to it land here.
    Method(_SB.PCI0.XHC.XSEL)
    {
        // do nothing
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
