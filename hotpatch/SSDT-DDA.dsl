// SSDT-DDA.dsl
//
// The purpose of this file is to define only the symbol RMDA.
// With RMDA defined, SSDT-HDEF, SSDT-HDAU, and SSDT-IGPU will disable "hda-gfx" injection
// by changing it to "#hda-gfx".
//
// Because "hda-gfx" needs to be disabled in some update scenarios, this mechanism
// provides an easy way to disable it by simply enabling this SSDT from the Clover menu.
// By default, this SSDT is not injected due to it being listed in DisabledAML.
//
// Overrides setting of RMCF.DAUD=1 or can be used in place of RMCF.DAUD=0

DefinitionBlock("", "SSDT", 2, "hack", "_DDA", 0)
{
    Name(RMDA, 1)
}
//EOF
