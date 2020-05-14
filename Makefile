.PHONY: all

all:

all-install :=

<<<<<<< HEAD
DESTDIR ?= dest
CPIONAME ?= bootrr 

HELPERS := $(wildcard helpers/*)

BOARDS := $(wildcard boards/*)

BINS := bin/bootrr

LIBEXEC_DIR ?= $(prefix)/libexec
BOOTRR_DIR = $(LIBEXEC_DIR)/bootrr
=======
HELPERS := assert_file_is_empty \
           assert_device_present \
           assert_driver_present \
	   assert_mmc_present \
	   assert_partition_found \
	   assert_sysfs_attr_present \
	   bootrr \
	   bootrr-auto \
	   bootrr-generic-tests \
	   ensure_lib_firmware \
	   kernel_greater_than \
	   kernel_older_than \
	   rproc-start \
	   rproc-stop \
	   value_in_range \
	   state_check

BOARDS := arrow,apq8096-db820c \
	  google,kevin \
	  google,pi \
	  google,veyron-jaq \
	  qcom,apq8016-sbc \
	  qcom,msm8998-mtp \
	  qcom,sdm845-mtp \
	  qcom,qcs404-evb \
	  sony,xperia-castor
>>>>>>> Install the helpers to check the kernel revision

define add-scripts
$(DESTDIR)$(prefix)/$1/$2: $1/$2
	@echo "INSTALL $$<"
	@install -D -m 755 $$< $$@

all-install += $(DESTDIR)$(prefix)/$1/$2
endef

$(foreach v,${BOARDS},$(eval $(call add-scripts,$(BOOTRR_DIR),$v)))
$(foreach v,${HELPERS},$(eval $(call add-scripts,$(BOOTRR_DIR),$v)))
$(foreach v,${BINS},$(eval $(call add-scripts,$(prefix),$v)))

bin/bootrr: bin/bootrr.in Makefile
	@sed -e 's!@BOOTRR@!$(BOOTRR_DIR)!g' $< > $@.tmp
	@mv $@.tmp $@

install: $(all-install)

CPIO := $(PWD)/$(CPIONAME).cpio

$(CPIO): $(all-install)
	@cd $(DESTDIR) && find ./$(prefix) | cpio -o -H newc > $(CPIO)

%.cpio.gz: %.cpio
	@gzip < $< > $@

cpio: $(CPIO)

cpio.gz: $(CPIO).gz

clean:
	@rm -f $(CPIO) $(CPIO).gz bin/bootrr
