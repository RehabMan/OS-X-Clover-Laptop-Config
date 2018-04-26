// Automatic injection of HDAU properties

// Note: Only for Haswell and Broadwell

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_HDAU", 0)
{
#endif
    External(RMCF.AUDL, IntObj)

    // inject properties for audio
    Method(_SB.PCI0.HDAU._DSM, 4)
    {
        If (CondRefOf(\RMCF.AUDL)) { If (Ones == \RMCF.AUDL) { Return(0) } }
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Local0 = Package()
        {
            "layout-id", Buffer(4) { 3, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
        }
        If (CondRefOf(\RMCF.AUDL))
        {
            CreateDWordField(DerefOf(Local0[1]), 0, AUDL)
            AUDL = \RMCF.AUDL
        }
        Return(Local0)
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
