// For disabling the discrete GPU

DefinitionBlock("", "SSDT", 2, "hack", "D-DGPU", 0)
{
    External(_SB.PCI0.PEG0.PEGP._OFF, MethodObj)
    
    Device(RMD1)
    {
        Name(_HID, "RMD10000")
        Method(_INI)
        {
            // disable discrete graphics (Nvidia) if it is present
            If (CondRefOf(\_SB.PCI0.PEG0.PEGP._OFF))
            {
                \_SB.PCI0.PEG0.PEGP._OFF()
            }
        }
    }
}
//EOF
