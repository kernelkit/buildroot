################################################################################
#
# libnetconf2
#
################################################################################

LIBNETCONF2_VERSION = 4.1.2
LIBNETCONF2_SITE = $(call github,CESNET,libnetconf2,v$(LIBNETCONF2_VERSION))
LIBNETCONF2_INSTALL_STAGING = YES
LIBNETCONF2_LICENSE = BSD-3-Clause
LIBNETCONF2_LICENSE_FILES = LICENSE
LIBNETCONF2_DEPENDENCIES = libyang
HOST_LIBNETCONF2_DEPENDENCIES = host-libyang

LIBNETCONF2_CONF_OPTS = \
	-DENABLE_TESTS=OFF \
	-DENABLE_VALGRIND_TESTS=OFF

# SSH and TLS come together in 4.x, or not at all when an SSH daemon
# runs the netconf-subsystem helper instead.
ifeq ($(BR2_PACKAGE_LIBNETCONF2_SSH_SUBSYSTEM),y)
LIBNETCONF2_CONF_OPTS += -DENABLE_SSH_TLS=OFF -DENABLE_SUBSYSTEM=ON
else
LIBNETCONF2_CONF_OPTS += -DENABLE_SSH_TLS=ON -DENABLE_SUBSYSTEM=OFF
LIBNETCONF2_DEPENDENCIES += libcurl libssh openssl
endif

ifeq ($(BR2_PACKAGE_LIBXCRYPT),y)
LIBNETCONF2_DEPENDENCIES += libxcrypt
endif

HOST_LIBNETCONF2_CONF_OPTS = \
	-DENABLE_TESTS=OFF \
	-DENABLE_VALGRIND_TESTS=OFF \
	-DENABLE_SSH_TLS=OFF \
	-DENABLE_SUBSYSTEM=OFF

$(eval $(cmake-package))
$(eval $(host-cmake-package))
