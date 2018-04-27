// Disabling EHCI #1 (and EHCI #2)

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_DEH02", 0)
{
#endif
    External(_SB.PCI0.EH02, DeviceObj)
    External(_SB.PCI0.LPCB, DeviceObj)

    // registers needed for disabling EHC#1
    Scope(_SB.PCI0.EH02)
    {
        OperationRegion(RMP1, PCI_Config, 0x54, 2)
        Field(RMP1, WordAcc, NoLock, Preserve)
        {
            PSTE, 2  // bits 2:0 are power state
        }
    }
    Scope(_SB.PCI0.LPCB)
    {
        OperationRegion(RMP2, PCI_Config, 0xF0, 4)
        Field(RMP2, DWordAcc, NoLock, Preserve)
        {
            RCB4, 32, // Root Complex Base Address
        }
        // address is in bits 31:14
        OperationRegion(FDM2, SystemMemory, (RCB4 & Not((1<<14)-1)) + 0x3418, 4)
        Field(FDM2, DWordAcc, NoLock, Preserve)
        {
            ,13,    // skip first 13 bits
            FDE2,1, // should be bit 13 (0-based) (FD EHCI#2)
        }
    }
    Device(_SB.PCI0.RMD4)
    {
        Name(_HID, "RMD40000")
        Method(_INI)
        {
            // disable EHCI#2
            // put EHCI#2 in D3hot (sleep mode)
            ^^EH02.PSTE = 3
            // disable EHCI#2 PCI space
            ^^LPCB.FDE2 = 1
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
