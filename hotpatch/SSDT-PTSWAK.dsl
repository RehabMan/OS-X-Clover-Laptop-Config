// Overriding _PTS and _WAK

DefinitionBlock("", "SSDT", 2, "hack", "PTSWAK", 0)
{
    External(ZPTS, MethodObj)
    External(ZWAK, MethodObj)

    External(_SB.PCI0.PEG0.PEGP._ON, MethodObj)
    External(_SB.PCI0.PEG0.PEGP._OFF, MethodObj)

    External(RMCF.DPTS, IntObj)
    External(RMCF.SHUT, IntObj)

    // In DSDT, native _PTS and _WAK are renamed ZPTS/ZWAK
    // As a result, calls to these methods land here.
    Method(_PTS, 1)
    {
        // Shutdown fix, if enabled
        if (\RMCF.SHUT && 5 == Arg0) { Return }

        If (\RMCF.DPTS)
        {
            // enable discrete graphics
            If (CondRefOf(\_SB.PCI0.PEG0.PEGP._ON)) { \_SB.PCI0.PEG0.PEGP._ON() }
        }

        // call into original _PTS method
        ZPTS(Arg0)
    }
    Method(_WAK, 1)
    {
        // Take care of bug regarding Arg0 in certain versions of OS X...
        // (starting at 10.8.5, confirmed fixed 10.10.2)
        If (Arg0 < 1 || Arg0 > 5) { Arg0 = 3 }

        // call into original _WAK method
        Local0 = ZWAK(Arg0)

        If (\RMCF.DPTS)
        {
            // disable discrete graphics
            If (CondRefOf(\_SB.PCI0.PEG0.PEGP._OFF)) { \_SB.PCI0.PEG0.PEGP._OFF() }
        }

        // return value from original _WAK
        Return (Local0)
    }
}
//EOF
