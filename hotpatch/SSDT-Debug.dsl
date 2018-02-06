// for use with ACPIDebug
// This file was created by applying "Add DSDT Debug Methods" to an empty SSDT
//
// Use "Add SSDT Debug Extern Declarations" to access these methods from other
// hotpatch SSDTs or even patched OEM ACPI files.
//

DefinitionBlock("", "SSDT", 2, "hack", "_RMDT", 0)
{
    Device(RMDT)
    {
        Name(_HID, "RMD0000")
        Name(RING, Package(256) { })
        Mutex(RTMX, 0)
        Name(HEAD, 0)
        Name(TAIL, 0)
        // PUSH: Use to push a trace item into RING for ACPIDebug.kext
        Method(PUSH, 1)
        {
            Acquire(RTMX, 0xFFFF)
            // push new item at HEAD
            Local0 = HEAD + 1
            If (Local0 >= SizeOf(RING)) { Local0 = 0 }
            if (Local0 != TAIL)
            {
                RING[HEAD] = Arg0
                HEAD = Local0
            }
            Release(RTMX)
            Notify(RMDT, 0x80)
        }
        // FTCH: Used by ACPIDebug.kext to fetch an item from RING
        Method(FTCH)
        {
            Acquire(RTMX, 0xFFFF)
            // pull item from TAIL and return it
            Local0 = 0
            if (HEAD != TAIL)
            {
                Local0 = DerefOf(RING[TAIL])
                TAIL++
                If (TAIL >= SizeOf(RING)) { TAIL = 0 }
            }
            Release(RTMX)
            Return(Local0)
        }
        // COUN: Used by ACPIDebug.kext to determine number of items in RING
        Method(COUN, 0, NotSerialized)
        {
            Acquire(RTMX, 0xFFFF)
            // return count of items in RING
            Local0 = HEAD - TAIL
            if (Local0 < 0) { Local0 += SizeOf(RING) }
            Release(RTMX)
            Return(Local0)
        }
        // Helper functions for multiple params at one time
        Method(P1, 1) { PUSH(Arg0) }
        Method(P2, 2)
        {
            Local0 = Package(2) { }
            Local0[0] = Arg0
            Local0[1] = Arg1
            PUSH(Local0)
        }
        Method(P3, 3)
        {
            Local0 = Package(3) { }
            Local0[0] = Arg0
            Local0[1] = Arg1
            Local0[2] = Arg2
            PUSH(Local0)
        }
        Method(P4, 4)
        {
            Local0 = Package(4) { }
            Local0[0] = Arg0
            Local0[1] = Arg1
            Local0[2] = Arg2
            Local0[3] = Arg3
            PUSH(Local0)
        }
        Method(P5, 5)
        {
            Local0 = Package(5) { }
            Local0[0] = Arg0
            Local0[1] = Arg1
            Local0[2] = Arg2
            Local0[3] = Arg3
            Local0[4] = Arg4
            PUSH(Local0)
        }
        Method(P6, 6)
        {
            Local0 = Package(6) { }
            Local0[0] = Arg0
            Local0[1] = Arg1
            Local0[2] = Arg2
            Local0[3] = Arg3
            Local0[4] = Arg4
            Local0[5] = Arg5
            PUSH(Local0)
        }
        Method(P7, 7)
        {
            Local0 = Package(7) { }
            Local0[0] = Arg0
            Local0[1] = Arg1
            Local0[2] = Arg2
            Local0[3] = Arg3
            Local0[4] = Arg4
            Local0[5] = Arg5
            Local0[6] = Arg6
            PUSH(Local0)
        }
    }
}
//EOF
