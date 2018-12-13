NAME = charger-influxdb-adapter
include .config
ESCAPED_BUILDDIR = $(shell echo '${BUILDDIR}' | sed 's%/%\\/%g')
ESCAPED_BASEURL = $(shell echo '${BASEURL}' | sed 's%/%\\/%g')
TARGET = $(BUILDDIR)/charger_influxdb_adapter

SERVERSRC:=$(BUILDDIR)/src/charger_influxdb_adapter.nim
BUILDSRC:=$(BUILDDIR)/charger_influxdb_adapter.nimble

all: $(TARGET)

$(TARGET): $(SERVERSRC) $(BUILDSRC)
	cd $(BUILDDIR); nimble build; cd -

$(SERVERSRC): core.org | prebuild
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | sed 's/$$$\{BASEURL}/$(ESCAPED_BASEURL)/g' | sed 's/$$$\{INFLUXUSR}/$(INFLUXUSR)/g' | sed 's/$$$\{INFLUXPWD}/$(INFLUXPWD)/g' | org-tangle -

$(BUILDSRC): build.org | prebuild
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

prebuild:
ifeq "$(wildcard $(BUILDDIR))" ""
	@mkdir -p $(BUILDDIR)
endif

clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean prebuild
