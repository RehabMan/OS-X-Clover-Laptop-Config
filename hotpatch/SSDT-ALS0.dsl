// Fake ambient light sensor device

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_ALS0", 0)
{
#endif
    Device(_SB.ALS0)
    {
        Name(_HID, "ACPI0008")
        Name(_CID, "smc-als")
        Name(_ALI, 300)
        Name(_ALR, Package()
        {
            //Package() { 70, 0 },
            //Package() { 73, 10 },
            //Package() { 85, 80 },
            Package() { 100, 300 },
            //Package() { 150, 1000 },
        })
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
