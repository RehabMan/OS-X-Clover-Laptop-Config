// Automatic injection of IGPU properties

DefinitionBlock("", "SSDT", 2, "hack", "IGPU", 0)
{
    External(_SB.PCI0.IGPU, DeviceObj)

    External(RMCF.TYPE, IntObj)
    External(RMCF.HIGH, IntObj)

    Scope(_SB.PCI0.IGPU)
    {
        // need the device-id from PCI_config to inject correct properties
        OperationRegion(RMP1, PCI_Config, 2, 2)
        Field(RMP1, AnyAcc, NoLock, Preserve)
        {
            GDID,16
        }
        // Injection tables for laptops
        Name(LAPL, Package() // low resolution
        {
            // Sandy Bridge/HD3000
            0x0116, 0x0126, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,snb-platform-id", Buffer() { 0x00, 0x00, 0x01, 0x00 },
                "AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
            },
            // Ivy Bridge/HD4000
            0x0166, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x03, 0x00, 0x66, 0x01 },   //768p
                "model", Buffer() { "Intel HD Graphics 4000" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4200
            0x0a1e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "model", Buffer() { "Intel HD Graphics 4200" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4400
            0x0a16, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "model", Buffer() { "Intel HD Graphics 4400" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4600
            0x0416, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "model", Buffer() { "Intel HD Graphics 4600" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD5000/HD5100/HD5200
            0x0a26, 0x0a2e, 0x0d26, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5300
            0x161e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5300" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5500
            0x1616, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5500" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5600
            0x1612, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5600" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD6000/HD6100/HD6200
            0x1626, 0x162b, 0x1622, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Skylake/HD520
            //REVIEW: add more ids..., just guessing on the ID
            0x1916, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x12, 0x19 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
        })
        Name(LAPH, Package() // high resolution
        {
            // Sandy Bridge/HD3000
            0x0116, 0x0126, 0, Package()
            {
                "AAPL00,DualLink", Buffer() { 0x01, 0, 0, 0, },
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,snb-platform-id", Buffer() { 0x00, 0x00, 0x01, 0x00 },
                "AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
            },
            // Ivy Bridge/HD4000
            0x0166, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x04, 0x00, 0x66, 0x01 }, //900p+
                "model", Buffer() { "Intel HD Graphics 4000" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4200
            0x0a1e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x08, 0x00, 0x2e, 0x0a }, //UHD/QHD+
                "model", Buffer() { "Intel HD Graphics 4200" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4400
            0x0a16, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x08, 0x00, 0x2e, 0x0a }, //UHD/QHD+
                "model", Buffer() { "Intel HD Graphics 4400" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4600
            0x0416, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x08, 0x00, 0x2e, 0x0a }, //UHD/QHD+
                "model", Buffer() { "Intel HD Graphics 4600" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD5000/HD5100/HD5200
            0x0a26, 0x0a2e, 0x0d26, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x08, 0x00, 0x2e, 0x0a }, //UHD/QHD+
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5300
            0x161e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5300" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5500
            0x1616, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5500" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5600
            0x1612, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5600" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD6000/HD6100/HD6200
            0x1626, 0x162b, 0x1622, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x16 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Skylake/HD520
            //REVIEW: add more ids..., just guessing on the ID
            0x1916, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x12, 0x19 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
        })

        // Injection tables for desktops
        Name(DESK, Package()
        {
            // Sandy Bridge/HD3000 (supported)
            0x0116, 0x0126, 0, Package()
            {
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,snb-platform-id", Buffer() { 0x10, 0x00, 0x03, 0x00 },
                //"AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
                "AAPL00,DualLink", Buffer() { 0x01, 0, 0, 0, },
            },
            // Sandy Bridge/HD3000 (unsupported)
            0x0112, 0x0122, 0, Package()
            {
                "device-id", Buffer() { 0x26, 0x01, 0x00, 0x00 },
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,snb-platform-id", Buffer() { 0x10, 0x00, 0x03, 0x00 },
                //"AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
                "AAPL00,DualLink", Buffer() { 0x01, 0, 0, 0, },
            },
            // Ivy Bridge/HD4000
            0x0166, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x0a, 0x00, 0x66, 0x01 },
                "model", Buffer() { "Intel HD Graphics 4000" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4200
            0x0a1e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                "model", Buffer() { "Intel HD Graphics 4200" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4400
            0x0a16, 0x041e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                "model", Buffer() { "Intel HD Graphics 4400" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4600 (mobile)
            0x0416, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                "model", Buffer() { "Intel HD Graphics 4600" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD4600 (desktop)
            0x0412, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                "model", Buffer() { "Intel HD Graphics 4600" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Haswell/HD5000/HD5100/HD5200
            0x0a26, 0x0a2e, 0x0d22, 0x0d26, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5300/HD5500/HD5600/HD6000 (future)
            0x161e, 0x1616, 0x1612, 0x1626, 0x162b, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x2b, 0x16 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Skylake/HD520
            //REVIEW: add more ids..., just guessing on the ID
            0x1916, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x12, 0x19 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
        })

        // inject properties for integrated graphics on IGPU
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            // determine correct injection table to use based on graphics config in SSDT-Config.aml
            Local0 = Ones
            If (0 == \RMCF.TYPE)
                { Local0 = DESK }
            ElseIf (1 == \RMCF.TYPE)
            {
                If (0 == \RMCF.HIGH)
                    { Local0 = LAPL }
                ElseIf (1 == \RMCF.HIGH)
                    { Local0 = LAPH }
            }
            // search for matching device-id in device-id list
            Local1 = Match(Local0, MEQ, GDID, MTR, 0, 0)
            If (Ones != Local1)
            {
                // start search for zero-terminator (prefix to injection package)
                Local1 = Match(Local0, MEQ, 0, MTR, 0, Local1+1)
                Return (DerefOf(Local0[Local1+1]))
            }
            // should never happen, but inject nothing in this case
            Return (Package() { })
        }
    }
}
//EOF
