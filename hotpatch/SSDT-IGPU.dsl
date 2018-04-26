// Automatic injection of IGPU properties

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_IGPU", 0)
{
#endif
    External(RMCF.TYPE, IntObj)
    External(RMCF.HIGH, IntObj)
    External(RMCF.IGPI, IntObj)
    External(RMGO, PkgObj)

    External(_SB.PCI0.IGPU, DeviceObj)
    Scope(_SB.PCI0.IGPU)
    {
        // need the device-id from PCI_config to inject correct properties
        OperationRegion(RMP1, PCI_Config, 2, 2)
        Field(RMP1, AnyAcc, NoLock, Preserve)
        {
            GDID,16,
        }

        // Note: all injection packages must have ig-platform-id as the first entry (for IGPI override)

        // Injection tables for laptops
        Name(LAPL, Package() // low resolution
        {
            // Sandy Bridge/HD3000
            0x0116, 0x0126, 0, Package()
            {
                "AAPL,snb-platform-id", Buffer() { 0x00, 0x00, 0x01, 0x00 },
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
            },
            // Ivy Bridge/HD4000
            0x0166, 0x0162, 0, Package()
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
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
            },
            // Haswell/HD4400
            0x0a16, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "model", Buffer() { "Intel HD Graphics 4400" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
            },
            // Haswell/HD4600
            0x0416, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x06, 0x00, 0x26, 0x0a },
                "model", Buffer() { "Intel HD Graphics 4600" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
            },
        })
        Name(LAPH, Package() // high resolution
        {
            // Sandy Bridge/HD3000
            0x0116, 0x0126, 0, Package()
            {
                "AAPL,snb-platform-id", Buffer() { 0x00, 0x00, 0x01, 0x00 },
                "AAPL00,DualLink", Buffer() { 0x01, 0, 0, 0, },
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
                "AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
            },
            // Ivy Bridge/HD4000
            0x0166, 0x0162, 0, Package()
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
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
            },
            // Haswell/HD4400
            0x0a16, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x08, 0x00, 0x2e, 0x0a }, //UHD/QHD+
                "model", Buffer() { "Intel HD Graphics 4400" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
            },
            // Haswell/HD4600
            0x0416, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x08, 0x00, 0x2e, 0x0a }, //UHD/QHD+
                "model", Buffer() { "Intel HD Graphics 4600" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
            },
            // Haswell/HD5000/HD5100/HD5200
            0x0a26, 0x0a2e, 0x0d26, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x08, 0x00, 0x2e, 0x0a }, //UHD/QHD+
                "hda-gfx", Buffer() { "onboard-1" },
            },
        })
        Name(LAPG, Package() // laptop generic
        {
            // Broadwell/HD5300
            0x161e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1e, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5300" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5500
            0x1616, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x04, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5500" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5600
            0x1612, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x04, 0x00, 0x26, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5600" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD6000/HD6100/HD6200
            0x1626, 0x162b, 0x1622, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x04, 0x00, 0x26, 0x16 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
        })
        // Injection tables for desktops
        Name(DESK, Package()
        {
            // Sandy Bridge/HD3000 (supported)
            0x0116, 0x0126, 0, Package()
            {
                "AAPL,snb-platform-id", Buffer() { 0x10, 0x00, 0x03, 0x00 },
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
                //"AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
                "AAPL00,DualLink", Buffer() { 0x01, 0, 0, 0, },
            },
            // Sandy Bridge/HD3000 (unsupported)
            0x0112, 0x0122, 0, Package()
            {
                "AAPL,snb-platform-id", Buffer() { 0x10, 0x00, 0x03, 0x00 },
                "AAPL00,DualLink", Buffer() { 0x01, 0, 0, 0, },
                "model", Buffer() { "Intel HD Graphics 3000" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x26, 0x01, 0x00, 0x00 },
                //"AAPL,os-info", Buffer() { 0x30, 0x49, 0x01, 0x11, 0x11, 0x11, 0x08, 0x00, 0x00, 0x01, 0xf0, 0x1f, 0x01, 0x00, 0x00, 0x00, 0x10, 0x07, 0x00, 0x00 },
            },
            // Ivy Bridge/HD4000
            0x0166, 0x0162, 0, Package()
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
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
            },
            // Haswell/HD4400
            0x0a16, 0x041e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                "model", Buffer() { "Intel HD Graphics 4400" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
            },
            // Haswell/HD4600 (mobile)
            0x0416, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                "model", Buffer() { "Intel HD Graphics 4600" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
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
            // Broadwell/HD5300
            0x161e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1e, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5300" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5500
            0x1616, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x16, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5500" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD5600
            0x1612, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x16, 0x16 },
                "model", Buffer() { "Intel HD Graphics 5600" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell/HD6000/HD6100
            0x1626, 0x162b, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x16, 0x16 },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Broadwell Iris Pro Graphics 6200
            0x1622, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x22, 0x16 },
                "model", Buffer() { "Intel Iris Pro Graphics 6200" },
                "hda-gfx", Buffer() { "onboard-1" },
            },            // Skylake/HD510
            0x1902, 0x1906, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1e, 0x19 },
                "model", Buffer() { "Intel HD Graphics 510" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x02, 0x19, 0x00, 0x00 },
                "RM,device-id", Buffer() { 0x02, 0x19, 0x00, 0x00 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Skylake/HD515
            0x191e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1e, 0x19 },
                "model", Buffer() { "Intel HD Graphics 515" },
                "hda-gfx", Buffer() { "onboard-1" },
                "RM,device-id", Buffer() { 0x1e, 0x19, 0x00, 0x00 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Skylake/HD520
            0x1916, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x16, 0x19 },
                "model", Buffer() { "Intel HD Graphics 520" },
                "hda-gfx", Buffer() { "onboard-1" },
                "RM,device-id", Buffer() { 0x16, 0x19, 0x00, 0x00 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Skylake/HD530
            0x1912, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x16, 0x19 },
                "model", Buffer() { "Intel HD Graphics 530" },
                "hda-gfx", Buffer() { "onboard-1" },
                "RM,device-id", Buffer() { 0x12, 0x19, 0x00, 0x00 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Skylake/HD530 mobile?
            0x191b, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
                "model", Buffer() { "Intel HD Graphics 530" },
                "device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
                "RM,device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
                "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
            },
            // Skylake/HD540
            0x1926, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x26, 0x19 },
                "model", Buffer() { "Intel Iris Graphics 540" },
                "hda-gfx", Buffer() { "onboard-1" },
                "RM,device-id", Buffer() { 0x26, 0x19, 0x00, 0x00 },
            },
            // Skylake/HD550
            0x1927, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x26, 0x19 },
                "model", Buffer() { "Intel Iris Graphics 550" },
                //REVIEW: using 0x1926 because 0x1927 is not supported on 10.11.x
                "device-id", Buffer() { 0x26, 0x19, 0x00, 0x00 },
                "hda-gfx", Buffer() { "onboard-1" },
                "RM,device-id", Buffer() { 0x26, 0x19, 0x00, 0x00 },
            },
            // Skylake/Iris Pro HD580
            0x193b, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x05, 0x00, 0x3b, 0x19 },
                "model", Buffer() { "Intel Iris Pro Graphics 580" },
                "hda-gfx", Buffer() { "onboard-1" },
                "RM,device-id", Buffer() { 0x3b, 0x19, 0x00, 0x00 },
            },
            // Kaby Lake/HD615
            0x591e, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1e, 0x59 },
                "model", Buffer() { "Intel HD Graphics 615" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Kaby Lake/HD620
            0x5916, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x16, 0x59 },
                "model", Buffer() { "Intel HD Graphics 620" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Kaby Lake-R/UHD620
            0x5917, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x16, 0x59 },
                "model", Buffer() { "Intel UHD Graphics 620" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x16, 0x59, 0x00, 0x00 },
            },
            // Kaby Lake/HD630
            0x5912, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x12, 0x59 },
                "model", Buffer() { "Intel HD Graphics 630" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // KabyLake/HD630 mobile?
            0x591b, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x59 },
                "model", Buffer() { "Intel HD Graphics 630" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Kaby Lake/HD640
            0x5926, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x26, 0x59 },
                "model", Buffer() { "Intel Iris Plus Graphics 640" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // Kaby Lake/HD650
            0x5927, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x26, 0x59 },
                "model", Buffer() { "Intel Iris Plus Graphics 650" },
                "hda-gfx", Buffer() { "onboard-1" },
            },
            // CoffeeLake/UHD620
            0x3e91, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x12, 0x59 },
                "model", Buffer() { "Intel UHD Graphics 620" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x59, 0x00, 0x00 },
            },
            // CoffeeLake/UHD630
            0x3e92, 0, Package()
            {
                "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x12, 0x59 },
                "model", Buffer() { "Intel UHD Graphics 630" },
                "hda-gfx", Buffer() { "onboard-1" },
                "device-id", Buffer() { 0x12, 0x59, 0x00, 0x00 },
            },
        })

        // inject properties for integrated graphics on IGPU
        Method(_DSM, 4)
        {
            // IGPU can be set to Ones to disable IGPU property injection (same as removing SSDT-IGPU.aml)
            If (CondRefOf(\RMCF.IGPI)) { If (Ones == \RMCF.IGPI) { Return(0) } }
            // otherwise, normal IGPU injection...
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Local0 = Ones
            For (,,)
            {
                // allow overrides in RMGO, if present
                If (CondRefOf(\RMGO))
                {
                    Local1 = RMGO
                    Local0 = Match(Local1, MEQ, GDID, MTR, 0, 0)
                    if (Ones != Local0) { Break }
                }
                If (CondRefOf(\RMCF.TYPE))
                {
                    If (1 == \RMCF.TYPE) // laptop
                    {
                        Local2 = 0 // assume lowres if RMCF.HIGH not present
                        If (CondRefOf(\RMCF.HIGH)) { Local2 = \RMCF.HIGH }
                        If (0 == Local2) // lowres
                        {
                            Local1 = LAPL
                            Local0 = Match(Local1, MEQ, GDID, MTR, 0, 0)
                            if (Ones != Local0) { Break }
                        }
                        ElseIf (1 == Local2) // hires
                        {
                            Local1 = LAPH
                            Local0 = Match(Local1, MEQ, GDID, MTR, 0, 0)
                            if (Ones != Local0) { Break }
                        }
                        // not found in LAPL or LAPH, use generic
                        Local1 = LAPG
                        Local0 = Match(Local1, MEQ, GDID, MTR, 0, 0)
                        if (Ones != Local0) { Break }
                    }
                }
                // search desktop table
                Local1 = DESK
                Local0 = Match(Local1, MEQ, GDID, MTR, 0, 0)
                Break
            }
            // unrecognized device... inject nothing in this case
            If (Ones == Local0) { Return (Package() { }) }
            // start search for zero-terminator (prefix to injection package)
            Local0 = DerefOf(Local1[Match(Local1, MEQ, 0, MTR, 0, Local0+1)+1])
            // the user can provide an override of ig-platform-id (or snb-platform-id) in RMCF.IGPI
            If (CondRefOf(\RMCF.IGPI))
            {
                if (0 != \RMCF.IGPI)
                {
                    CreateDWordField(DerefOf(Local0[1]), 0, IGPI)
                    IGPI = \RMCF.IGPI
                }
            }
            Return (Local0)
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
