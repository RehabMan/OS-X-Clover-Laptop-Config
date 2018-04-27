// for testing including all SSDTs with NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_IALL", 0)
{
    #define NO_DEFINITIONBLOCK
    #include "SSDT-RMCF.dsl"
    #include "SSDT-RMDT.dsl"
    #include "SSDT-XOSI.dsl"
    #include "SSDT-IGPU.dsl"
    #include "SSDT-SKLSPF.dsl"
    #include "SSDT-IMEI.dsl"
    #include "SSDT-PNLF.dsl"
    #include "SSDT-LPC.dsl"
    #include "SSDT-SATA.dsl"
    #include "SSDT-DDGPU.dsl"
    #include "SSDT-SMBUS.dsl"
    #include "SSDT-GPRW.dsl"
    #include "SSDT-UPRW.dsl"
    #include "SSDT-LANCPRW.dsl"
    #include "SSDT-PTSWAK.dsl"
    //#include "SSDT-DEHCI.dsl" // Not valid to combine DEHCI with DEH01/DEH02
    #include "SSDT-DEH01.dsl"
    #include "SSDT-DEH02.dsl"
    #include "SSDT-XWAK.dsl"
    #include "SSDT-XSEL.dsl"
    #include "SSDT-ESEL.dsl"
    #include "SSDT-XCPM.dsl"
    #include "SSDT-HDEF.dsl"
    #include "SSDT-HDAU.dsl"
    #include "SSDT-EH01.dsl"
    #include "SSDT-EH02.dsl"
    #include "SSDT-XHC.dsl"
}
//EOF
