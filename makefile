# makefile

#
# Patches/Installs/Builds DSDT patches for HP ProBook
#
# Created by RehabMan
#

BUILDDIR=./build
HOTPATCH=./hotpatch

HACK:=$(HACK) $(BUILDDIR)/SSDT-Config.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-XOSI.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-IGPU.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-IMEI.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-PNLF.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-LPC.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-SATA_RAID.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-Disable_DGPU.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-SMBUS.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-PRW.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-LANC_PRW.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-PTSWAK.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-Disable_EHCI.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-XWAK.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-XSEL.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-ESEL.aml
HACK:=$(HACK) $(BUILDDIR)/SSDT-PluginType1.aml

ALL=$(HACK)

.PHONY: all
all : $(ALL)

.PHONY: clean
clean:
	rm -f $(ALL)

# SSDT-HACK

IASLOPTS=-vw 2095 -vi -vs

$(BUILDDIR)/SSDT-Config.aml : $(HOTPATCH)/SSDT-Config.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-XOSI.aml : $(HOTPATCH)/SSDT-XOSI.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-IGPU.aml : $(HOTPATCH)/SSDT-IGPU.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-IMEI.aml : $(HOTPATCH)/SSDT-IMEI.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-PNLF.aml : $(HOTPATCH)/SSDT-PNLF.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-LPC.aml : $(HOTPATCH)/SSDT-LPC.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-SATA_RAID.aml : $(HOTPATCH)/SSDT-SATA_RAID.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-Disable_DGPU.aml : $(HOTPATCH)/SSDT-Disable_DGPU.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-SMBUS.aml : $(HOTPATCH)/SSDT-SMBUS.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-PRW.aml : $(HOTPATCH)/SSDT-PRW.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-LANC_PRW.aml : $(HOTPATCH)/SSDT-LANC_PRW.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-PTSWAK.aml : $(HOTPATCH)/SSDT-PTSWAK.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-Disable_EHCI.aml : $(HOTPATCH)/SSDT-Disable_EHCI.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-XWAK.aml : $(HOTPATCH)/SSDT-XWAK.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-XSEL.aml : $(HOTPATCH)/SSDT-XSEL.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-ESEL.aml : $(HOTPATCH)/SSDT-ESEL.dsl
	iasl $(IASLOPTS) -p $@ $^

$(BUILDDIR)/SSDT-PluginType1.aml : $(HOTPATCH)/SSDT-PluginType1.dsl
	iasl $(IASLOPTS) -p $@ $^

# EOF