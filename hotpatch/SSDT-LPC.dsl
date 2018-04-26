// To fix unsupported 8-series LPC devices

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_LPC", 0)
{
#endif
    External(_SB.PCI0.LPCB, DeviceObj)
    Scope(_SB.PCI0.LPCB)
    {
        OperationRegion(RMP0, PCI_Config, 2, 2)
        Field(RMP0, AnyAcc, NoLock, Preserve)
        {
            LDID,16
        }
        Name(LPDL, Package()
        {
            // list of 7-series LPC device-ids not natively supported (partial list)
            0x1e49, 0,
            Package()
            {
                "device-id", Buffer() { 0x42, 0x1e, 0, 0 },
                "compatible", Buffer() { "pci8086,1e42" },
            },
            // list of 8-series LPC device-ids not natively supported
            // inject 0x8c4b for unsupported LPC device-id
            0x8c46, 0x8c49, 0x8c4a, 0x8c4c, 0x8c4e, 0x8c4f,
            0x8c50, 0x8c52, 0x8c54, 0x8c56, 0x8c5c, 0x8cc3, 0,
            Package()
            {
                "device-id", Buffer() { 0x4b, 0x8c, 0, 0 },
                "compatible", Buffer() { "pci8086,8c4b" },
            },
            // list of 9-series LPC device-ids not natively supported (partial list)
            0x8cc6,
            // list of 100-series LPC device-ids not natively supported (partial list)
            0x9d48, 0x9d58, 0xa14e, 0xa150,
            // and 200-series...
            0xa2c5, 0,
            Package()
            {
                "device-id", Buffer() { 0xc1, 0x9c, 0, 0 },
                "compatible", Buffer() { "pci8086,9cc1" },
            },
        })
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            // search for matching device-id in device-id list, LPDL
            Local0 = Match(LPDL, MEQ, ^LDID, MTR, 0, 0)
            If (Ones != Local0)
            {
                // start search for zero-terminator (prefix to injection package)
                Local0 = Match(LPDL, MEQ, 0, MTR, 0, Local0+1)
                Return (DerefOf(LPDL[Local0+1]))
            }
            // if no match, assume it is supported natively... no inject
            Return (Package() { })
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
