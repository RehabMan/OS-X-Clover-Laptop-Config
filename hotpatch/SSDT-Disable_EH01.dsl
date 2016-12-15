// Disabling EHCI #1 (and EHCI #2)

DefinitionBlock("", "SSDT", 2, "hack", "D-EH01", 0)
{
    External(_SB.PCI0, DeviceObj)
    External(_SB.PCI0.EH01, DeviceObj)
    External(_SB.PCI0.LPCB, DeviceObj)

    // registers needed for disabling EHC#1
    Scope(_SB.PCI0.EH01)
    {
        OperationRegion(RMP1, PCI_Config, 0x54, 2)
        Field(RMP1, WordAcc, NoLock, Preserve)
        {
            PSTE, 2  // bits 2:0 are power state
        }
    }
    Scope(_SB.PCI0.LPCB)
    {
        OperationRegion(RMP3, PCI_Config, 0xF0, 4)
        Field(RMP3, DWordAcc, NoLock, Preserve)
        {
            RCB3, 32, // Root Complex Base Address
        }
        // address is in bits 31:14
        OperationRegion(FDM3, SystemMemory, (RCB3 & Not((1<<14)-1)) + 0x3418, 4)
        Field(FDM3, DWordAcc, NoLock, Preserve)
        {
            ,15,    // skip first 15 bits
            FDE1,1, // should be bit 15 (0-based) (FD EHCI#1)
        }
    }
    Scope(_SB.PCI0)
    {
        Device(RMD3)
        {
            Name(_HID, "RMD30000")
            Method(_INI)
            {
                // disable EHCI#1
                // put EHCI#1 in D3hot (sleep mode)
                ^^EH01.PSTE = 3
                // disable EHCI#1 PCI space
                ^^LPCB.FDE1 = 1
            }
        }
    }
}
//EOF
