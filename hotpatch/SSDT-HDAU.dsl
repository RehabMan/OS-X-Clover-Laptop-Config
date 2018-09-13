// Automatic injection of HDAU properties

// Note: Only for Haswell and Broadwell

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_HDAU", 0)
{
#endif
    External(RMCF.AUDL, IntObj)
    External(RMDA, IntObj)
    External(RMCF.DAUD, IntObj)

    // inject properties for audio
    Method(_SB.PCI0.HDAU._DSM, 4)
    {
        If (CondRefOf(\RMCF.AUDL)) { If (Ones == \RMCF.AUDL) { Return(0) } }
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Local0 = Package()
        {
            "layout-id", Buffer(4) { 2, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
        }
        If (CondRefOf(\RMCF.AUDL))
        {
            CreateDWordField(DerefOf(Local0[1]), 0, AUDL)
            AUDL = \RMCF.AUDL
        }
        // the user can disable "hda-gfx" injection by defining \RMDA or setting RMCF.DAUD=0
        // assumes that "hda-gfx" is always at index 2 (eg. "hda-gfx" follows ig-platform-id)
        Local1 = 0
        If (CondRefOf(\RMDA)) { Local1 = 1 }
        If (CondRefOf(\RMCF.DAUD)) { If (0 == \RMCF.DAUD) { Local1 = 1 } }
        If (Local1) { Local0[2] = "#hda-gfx"; }
        Return(Local0)
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
