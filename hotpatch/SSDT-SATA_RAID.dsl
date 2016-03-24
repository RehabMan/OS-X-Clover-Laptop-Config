// Fix SATA in RAID mode

DefinitionBlock("", "SSDT", 2, "hack", "SATARAID", 0)
{
    External(_SB.PCI0.SAT0, DeviceObj)
    
    Scope(_SB.PCI0.SAT0)
    {
        OperationRegion(RMP1, PCI_Config, 2, 2)
        Field(RMP1, AnyAcc, NoLock, Preserve)
        {
            SDID,16
        }
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            If (0x282a == SDID)
            {
                // 8086:282a is RAID mode, remap to supported 8086:2829
                Return (Package()
                {
                    "device-id", Buffer() { 0x29, 0x28, 0, 0 },
                })
            }
            Return (Package() { })
        }
    }
}
//EOF