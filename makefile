# makefile

#
# Patches/Installs/Builds ACPI hotpatch binaries
#

BUILDDIR=./build
HOTPATCH=./hotpatch

HACK=$(wildcard $(HOTPATCH)/*.dsl)
HACK:=$(subst $(HOTPATCH),$(BUILDDIR),$(HACK))
HACK:=$(subst .dsl,.aml,$(HACK))

ALL=$(HACK)

.PHONY: all
all : $(ALL)

.PHONY: clean
clean:
	rm -f $(ALL)

IASLOPTS=-vw 2095 -vw 2008 -vw 4089 -vi -vs

build/%.aml : hotpatch/%.dsl
	iasl $(IASLOPTS) -p $@ $<

# EOF
