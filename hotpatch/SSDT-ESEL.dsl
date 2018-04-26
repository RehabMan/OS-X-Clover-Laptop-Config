// Disabling ESEL

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_ESEL", 0)
{
#endif
    // In DSDT, native ESEL is renamed ESEX
    // As a result, calls to it land here.
    Method(_SB.PCI0.XHC.ESEL)
    {
        // do nothing
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
