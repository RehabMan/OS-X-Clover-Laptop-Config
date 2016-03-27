// Disabling EHCI #1 (and EHCI #2)

DefinitionBlock("", "SSDT", 2, "hack", "D-EHCI", 0)
{
    External(_SB.PCI0, DeviceObj)
    External(_SB.PCI0.EH01, DeviceObj)
    External(_SB.PCI0.EH02, DeviceObj)
    External(_SB.PCI0.LPCB, DeviceObj)
    External(_SB.PCI0.XHC, DeviceObj)

    External(RMCF, DeviceObj)
    Scope(RMCF)
    {
        // SSDT-XHC tests this so it can change RM,pr2-force for FakePCIID_XHCIMux
        // We don't want FakePCIID_XHCIMux to route USB2 on XHCI to a
        // disabled EHCI controller!
        Name(RMED, 1)
    }

    Scope(_SB.PCI0)
    {
        // registers needed for disabling EHC#1
        Scope(EH01)
        {
            OperationRegion(RMP1, PCI_Config, 0x54, 2)
            Field(RMP1, WordAcc, NoLock, Preserve)
            {
                PSTE, 2  // bits 2:0 are power state
            }
        }
        // registers needed for disabling EHC#1
        Scope(EH02)
        {
            OperationRegion(RMP1, PCI_Config, 0x54, 2)
            Field(RMP1, WordAcc, NoLock, Preserve)
            {
                PSTE, 2  // bits 2:0 are power state
            }
        }
        Scope(LPCB)
        {
            OperationRegion(RMP1, PCI_Config, 0xF0, 4)
            Field(RMP1, DWordAcc, NoLock, Preserve)
            {
                RCB1, 32, // Root Complex Base Address
            }
            // address is in bits 31:14
            OperationRegion(FDM1, SystemMemory, (RCB1 & Not((1<<14)-1)) + 0x3418, 4)
            Field(FDM1, DWordAcc, NoLock, Preserve)
            {
                ,13,    // skip first 13 bits
                FDE2,1, // should be bit 13 (0-based) (FD EHCI#2)
                ,1,
                FDE1,1, // should be bit 15 (0-based) (FD EHCI#1)
            }
        }
        Device(RMD2)
        {
            Name(_HID, "RMD20000")
            Method(_INI)
            {
                // disable EHCI#1
                // put EHCI#1 in D3hot (sleep mode)
                ^^EH01.PSTE = 3
                // disable EHCI#1 PCI space
                ^^LPCB.FDE1 = 1

                // disable EHCI#2
                // put EHCI#2 in D3hot (sleep mode)
                ^^EH02.PSTE = 3
                // disable EHCI#2 PCI space
                ^^LPCB.FDE2 = 1
            }
        }
    }
}
//EOF
