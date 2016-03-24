// configuration data for other SSDTs in this pack

DefinitionBlock("", "SSDT", 2, "hack", "RMCF", 0)
{
    Device(RMCF)
    {
        Name(_ADR, 0)

        // TYPE: Indicates the type of computer... desktop or laptop
        //
        //  0: desktop
        //  1: laptop
        Name(TYPE, 1)

        // HIGH: High resolution/low resolution selection.  Affects IGPU injection.
        //
        // For 1600x900+ on Sandy/Ivy, use 1
        // For UHD/QHD+ on Haswell/Broadwell, use 1
        // Others (low resolution), use 0
        Name(HIGH, 0)

        // DPTS: For laptops only: set to 1 if you want to enable and
        //  disable the DGPU _PTS and _WAK.
        //
        //  0: does not manipulate the DGPU in _WAK and _PTS
        //  1: disables the DGPU in _WAK and enables it in _PTS
        Name(DPTS, 0)

        // SHUT: Shutdown fix, disable _PTS code when Arg0==5 (shutdown)
        //
        //  0: does not affect _PTS behavior during shutdown
        //  1: disables _PTS code during shutdown
        Name(SHUT, 0)
    }
}
//EOF
