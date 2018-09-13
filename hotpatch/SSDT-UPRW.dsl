// For solving instant wake by hooking GPRW or UPRW

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_UPRW", 0)
{
#endif
    External(XPRW, MethodObj)
    External(RMCF.DWOU, IntObj)

    // In DSDT, native UPRW is renamed to XPRW with Clover binpatch.
    // As a result, calls to UPRW land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 in the second position (sleep state supported)
    // of the return package.
    Method(UPRW, 2)
    {
        For (,,)
        {
            // when RMCF.DWOU is provided and is zero, patch disabled
            If (CondRefOf(\RMCF.DWOU)) { If (!\RMCF.DWOU) { Break }}
            // either RMCF.DWOU not provided, or is non-zero, patch is enabled
            If (0x6d == Arg0) { Return (Package() { 0x6d, 0, }) }
            If (0x0d == Arg0) { Return (Package() { 0x0d, 0, }) }
        }
        Return (XPRW(Arg0, Arg1))
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
