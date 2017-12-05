// SSDT-SkylakeSpoof.dsl
//
// The purpose of this file is to allow KabyLake or KabyLake-R systems to spoof Skylake graphics.
// Just include the built version of this file in ACPI/patched.

DefinitionBlock("", "SSDT", 2, "hack", "RM-RMGO", 0)
{
    Name(RMGO, Package()
    {
        // Kaby Lake/HD615
        0x591e, 0, Package()
        {
            "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1e, 0x19 },
            "model", Buffer() { "Intel HD Graphics 515" },
            "hda-gfx", Buffer() { "onboard-1" },
            "device-id", Buffer() { 0x1e, 0x19, 0x00, 0x00 },
            "RM,device-id", Buffer() { 0x1e, 0x19, 0x00, 0x00 },
            "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
        },
        // Kaby Lake/HD620
        0x5916, 0, Package()
        {
            "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x16, 0x19 },
            "model", Buffer() { "Intel HD Graphics 620" },
            "hda-gfx", Buffer() { "onboard-1" },
            "device-id", Buffer() { 0x16, 0x19, 0x00, 0x00 },
            "RM,device-id", Buffer() { 0x16, 0x19, 0x00, 0x00 },
            "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
        },
        // Kaby Lake/HD620
        0x5917, 0, Package()
        {
            "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x16, 0x19 },
            "model", Buffer() { "Intel HD Graphics 620" },
            "hda-gfx", Buffer() { "onboard-1" },
            "device-id", Buffer() { 0x16, 0x19, 0x00, 0x00 },
            "RM,device-id", Buffer() { 0x16, 0x19, 0x00, 0x00 },
            "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
        },
        // Kaby Lake/HD630
        0x5912, 0, Package()
        {
            "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x16, 0x19 },
            "model", Buffer() { "Intel HD Graphics 630" },
            "hda-gfx", Buffer() { "onboard-1" },
            "device-id", Buffer() { 0x12, 0x19, 0x00, 0x00 },
            "RM,device-id", Buffer() { 0x12, 0x19, 0x00, 0x00 },
            "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
        },
        // KabyLake/HD630 mobile?
        0x591b, 0, Package()
        {
            "AAPL,ig-platform-id", Buffer() { 0x00, 0x00, 0x1b, 0x19 },
            "model", Buffer() { "Intel HD Graphics 630" },
            "hda-gfx", Buffer() { "onboard-1" },
            "device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
            "RM,device-id", Buffer() { 0x1b, 0x19, 0x00, 0x00 },
            "AAPL,GfxYTile", Buffer() { 1, 0, 0, 0 },
        },
        // Kaby Lake/HD640
        0x5926, 0, Package()
        {
            "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x26, 0x19 },
            "model", Buffer() { "Intel Iris Plus Graphics 640" },
            "hda-gfx", Buffer() { "onboard-1" },
            "device-id", Buffer() { 0x26, 0x19, 0x00, 0x00 },
            "RM,device-id", Buffer() { 0x26, 0x19, 0x00, 0x00 },
        },
        // Kaby Lake/HD650
        0x5927, 0, Package()
        {
            //REVIEW: could use 0x19270000 or 0x19270004 (macOS only)
            "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x26, 0x19 },
            "model", Buffer() { "Intel Iris Plus Graphics 650" },
            "hda-gfx", Buffer() { "onboard-1" },
            //REVIEW: using 0x1926 because 0x1927 is not supported on 10.11.x
            "device-id", Buffer() { 0x26, 0x19, 0x00, 0x00 },
            //REVIEW: using 0x1926 because 0x1927 is not supported on 10.11.x
            "RM,device-id", Buffer() { 0x26, 0x19, 0x00, 0x00 },
        },
    })
}
//EOF
