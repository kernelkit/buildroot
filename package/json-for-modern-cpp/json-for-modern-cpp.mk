################################################################################
#
# json-for-modern-cpp
#
################################################################################

JSON_FOR_MODERN_CPP_VERSION = 3.12.0
JSON_FOR_MODERN_CPP_SOURCE = json-$(JSON_FOR_MODERN_CPP_VERSION).tar.gz
JSON_FOR_MODERN_CPP_SITE = $(call github,nlohmann,json,v$(JSON_FOR_MODERN_CPP_VERSION))
JSON_FOR_MODERN_CPP_LICENSE = MIT
JSON_FOR_MODERN_CPP_LICENSE_FILES = LICENSE.MIT
JSON_FOR_MODERN_CPP_CPE_ID_VALID = YES

JSON_FOR_MODERN_CPP_INSTALL_STAGING = YES
# header only library
JSON_FOR_MODERN_CPP_INSTALL_TARGET = NO
JSON_FOR_MODERN_CPP_CONF_OPTS = -DJSON_BuildTests=OFF -DJSON_MultipleHeaders=ON

$(eval $(cmake-package))
