// Deals with mixed systems (HD4000 on 6-series, HD3000 on 7-series)
// Will also add the missing IMEI device.

DefinitionBlock("", "SSDT", 2, "hack", "_IMEI", 0)
{
    // setup PCI_Config for IGPU
    External(_SB.PCI0.IGPU, DeviceObj)
    Scope(_SB.PCI0.IGPU) { OperationRegion(RMP2, PCI_Config, 2, 2) }

    // Note: If your ACPI set (DSDT+SSDTs) already defines IMEI (or HECI),
    // remove this Device definition, swap for External below
    Device(_SB.PCI0.IMEI) { Name(_ADR, 0x00160000) }
    //External(_SB.PCI0.IMEI, DeviceObj)
    Scope(_SB.PCI0.IMEI)
    {
        // deal with mixed system, HD3000/7-series, HD4000/6-series
        OperationRegion(RMP1, PCI_Config, 2, 2)
        // need the device-id from PCI_config to inject correct properties
        Field(RMP1, AnyAcc, NoLock, Preserve)
        {
            MDID,16
        }
        Field(^IGPU.RMP2, AnyAcc, NoLock, Preserve)
        {
            GDID,16,
        }
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Local1 = ^GDID
            Local2 = ^MDID
            If (0x1c3a == Local2 && Ones != Match(Package() { 0x0166, 0x0162 }, MEQ, Local1, MTR, 0, 0))
            {
                // HD4000 on 6-series, inject 7-series IMEI device-id
                Return (Package() { "device-id", Buffer() { 0x3a, 0x1e, 0, 0 } })
            }
            ElseIf (0x1e3a == Local2 && Ones != Match(Package() { 0x0116, 0x0126, 0x0112, 0x0122 }, MEQ, Local1, MTR, 0, 0))
            {
                // HD3000 on 7-series, inject 6-series IMEI device-id
                Return (Package() { "device-id", Buffer() { 0x3a, 0x1c, 0, 0 } })
            }
            Return (Package(){})
        }
    }
}
//EOF
