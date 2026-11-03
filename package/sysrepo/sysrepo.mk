################################################################################
#
# sysrepo
#
################################################################################

SYSREPO_VERSION = 5.2.27
SYSREPO_SITE = $(call github,sysrepo,sysrepo,v$(SYSREPO_VERSION))
SYSREPO_INSTALL_STAGING = YES
SYSREPO_LICENSE = BSD-3-Clause
SYSREPO_LICENSE_FILES = LICENSE
SYSREPO_DEPENDENCIES = libyang pcre2 host-sysrepo
HOST_SYSREPO_DEPENDENCIES = host-libyang host-pcre2

ifeq ($(BR2_INIT_SYSTEMD),y)
SYSREPO_DEPENDENCIES += systemd
endif

SYSREPO_CONF_OPTS = \
	-DENABLE_EXAMPLES=$(if $(BR2_PACKAGE_SYSREPO_EXAMPLES),ON,OFF) \
	-DENABLE_TESTS=OFF \
	-DENABLE_VALGRIND_TESTS=OFF \
	-DREPO_PATH=/etc/sysrepo \
	-DREPO_SHM_SETUP=OFF \
	-DNOTIFD_SETUP=OFF

ifneq ($(BR2_PACKAGE_SYSREPO_INTERNAL_DATA),)
SYSREPO_CONF_OPTS += \
	-DINTERNAL_MODULE_DATA_PATH=$(BR2_PACKAGE_SYSREPO_INTERNAL_DATA)
endif

ifdef BR2_PACKAGE_SYSREPO_GROUP
SYSREPO_CONF_OPTS += -DSYSREPO_GROUP="$(BR2_PACKAGE_SYSREPO_GROUP)" \
		     -DSYSREPO_UMASK="00007" -DNACM_SRMON_DATA_PERM=660
endif

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
SYSREPO_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-latomic
endif

# sysrepo maps its printed libyang context at a fixed address in every
# process.  The address is normally probed by running a program at
# configure time, which cannot be done when cross-compiling, so set it
# here instead.  Each address is in the gap between the heap and the mmap
# area of the default user memory layout of the kernel:
#
#   aarch64  48-bit VA, PIE at 0xaaaa..., mmap below 0xffff...
#   arm      3G/1G split, PIE at 4M, mmap below ~0xb7000000
#   riscv64  Sv39, PIE at ~0x2a_aaaa_a000, mmap below 0x40_0000_0000, with
#            Sv48 or Sv57 the mmap window is 47 bits, like x86_64, and
#            nothing else is mapped as low as this
#   x86_64   47-bit VA, PIE at 0x5555..., mmap below 0x7fff...
#
# A process that cannot map it falls back to compiling its own context.
ifeq ($(BR2_aarch64),y)
SYSREPO_CONF_OPTS += -DPRINTED_CONTEXT_ADDRESS=0xc00000000000
else ifeq ($(BR2_arm),y)
SYSREPO_CONF_OPTS += -DPRINTED_CONTEXT_ADDRESS=0x60000000
else ifeq ($(BR2_RISCV_64),y)
SYSREPO_CONF_OPTS += -DPRINTED_CONTEXT_ADDRESS=0x3500000000
else ifeq ($(BR2_x86_64),y)
SYSREPO_CONF_OPTS += -DPRINTED_CONTEXT_ADDRESS=0x600000000000
endif

define SYSREPO_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/sysrepo/S51sysrepo-plugind \
		$(TARGET_DIR)/etc/init.d/S51sysrepo-plugind
endef

HOST_SYSREPO_CONF_OPTS = \
	-DENABLE_EXAMPLES=OFF \
	-DENABLE_TESTS=OFF \
	-DENABLE_VALGRIND_TESTS=OFF \
	-DREPO_PATH=$(TARGET_DIR)/etc/sysrepo \
	-DREPO_SHM_SETUP=OFF \
	-DNOTIFD_SETUP=OFF

ifneq ($(BR2_PACKAGE_SYSREPO_INTERNAL_DATA),)
HOST_SYSREPO_CONF_OPTS += \
	-DINTERNAL_MODULE_DATA_PATH=$(BR2_PACKAGE_SYSREPO_INTERNAL_DATA)
endif

$(eval $(cmake-package))
$(eval $(host-cmake-package))
