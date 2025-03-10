################################################################################
#
# python-pyqt5
#
################################################################################

PYTHON_PYQT5_VERSION = 5.15.6
PYTHON_PYQT5_SOURCE = PyQt5-$(PYTHON_PYQT5_VERSION).tar.gz
PYTHON_PYQT5_SITE = https://files.pythonhosted.org/packages/3b/27/fd81188a35f37be9b3b4c2db1654d9439d1418823916fe702ac3658c9c41
PYTHON_PYQT5_LICENSE = GPL-3.0
PYTHON_PYQT5_LICENSE_FILES = LICENSE

PYTHON_PYQT5_DEPENDENCIES = python-sip host-python-sip qt5base
PYTHON_PYQT5_MODULES = \
	QtCore QtGui \
	$(if $(BR2_PACKAGE_QT5BASE_DBUS),QtDBus) \
	$(if $(BR2_PACKAGE_QT5BASE_NETWORK),QtNetwork) \
	$(if $(BR2_PACKAGE_QT5BASE_OPENGL_LIB),QtOpenGL) \
	$(if $(BR2_PACKAGE_QT5BASE_PRINTSUPPORT),QtPrintSupport) \
	$(if $(BR2_PACKAGE_QT5BASE_XML),QtXml)

ifeq ($(BR2_PACKAGE_QT5BASE_WIDGETS),y)
PYTHON_PYQT5_MODULES += QtWidgets

# QtSql needs QtWidgets
ifeq ($(BR2_PACKAGE_QT5BASE_SQL),y)
PYTHON_PYQT5_MODULES += QtSql
endif

# QtTest needs QtWidgets
ifeq ($(BR2_PACKAGE_QT5BASE_TEST),y)
PYTHON_PYQT5_MODULES += QtTest
endif

# QtSvg needs QtWidgets
ifeq ($(BR2_PACKAGE_QT5SVG),y)
PYTHON_PYQT5_DEPENDENCIES += qt5svg
PYTHON_PYQT5_MODULES += QtSvg
endif
endif

ifeq ($(BR2_PACKAGE_QT5CONNECTIVITY),y)
PYTHON_PYQT5_DEPENDENCIES += qt5connectivity
PYTHON_PYQT5_MODULES += QtBluetooth QtNfc
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
PYTHON_PYQT5_DEPENDENCIES += qt5declarative
PYTHON_PYQT5_MODULES += QtQml

# QtQuick module needs opengl
ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK)$(BR2_PACKAGE_QT5BASE_OPENGL_LIB),yy)
PYTHON_PYQT5_MODULES += \
	QtQuick \
	$(if $(BR2_PACKAGE_QT5BASE_WIDGETS),QtQuickWidgets)
endif
endif

ifeq ($(BR2_PACKAGE_QT5ENGINIO),y)
PYTHON_PYQT5_DEPENDENCIES += qt5enginio
PYTHON_PYQT5_MODULES += Enginio
endif

ifeq ($(BR2_PACKAGE_QT5LOCATION),y)
PYTHON_PYQT5_DEPENDENCIES += qt5location
PYTHON_PYQT5_MODULES += QtPositioning
ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
PYTHON_PYQT5_MODULES += QtLocation
endif
endif

ifeq ($(BR2_PACKAGE_QT5MULTIMEDIA),y)
PYTHON_PYQT5_DEPENDENCIES += qt5multimedia
PYTHON_PYQT5_MODULES += \
	QtMultimedia \
	$(if $(BR2_PACKAGE_QT5BASE_WIDGETS),QtMultimediaWidgets)
endif

ifeq ($(BR2_PACKAGE_QT5SENSORS),y)
PYTHON_PYQT5_DEPENDENCIES += qt5sensors
PYTHON_PYQT5_MODULES += QtSensors
endif

ifeq ($(BR2_PACKAGE_QT5SERIALPORT),y)
PYTHON_PYQT5_DEPENDENCIES += qt5serialport
PYTHON_PYQT5_MODULES += QtSerialPort
endif

ifeq ($(BR2_PACKAGE_QT5WEBCHANNEL),y)
PYTHON_PYQT5_DEPENDENCIES += qt5webchannel
PYTHON_PYQT5_MODULES += QtWebChannel
endif

ifeq ($(BR2_PACKAGE_QT5WEBKIT),y)
PYTHON_PYQT5_DEPENDENCIES += qt5webkit
PYTHON_PYQT5_MODULES += \
	QtWebKit \
	$(if $(BR2_PACKAGE_QT5BASE_WIDGETS),QtWebKitWidgets)
endif

ifeq ($(BR2_PACKAGE_QT5WEBSOCKETS),y)
PYTHON_PYQT5_DEPENDENCIES += qt5websockets
PYTHON_PYQT5_MODULES += QtWebSockets
endif

ifeq ($(BR2_PACKAGE_QT5X11EXTRAS),y)
PYTHON_PYQT5_DEPENDENCIES += qt5x11extras
PYTHON_PYQT5_MODULES += QtX11Extras
endif

ifeq ($(BR2_PACKAGE_QT5XMLPATTERNS),y)
PYTHON_PYQT5_DEPENDENCIES += qt5xmlpatterns
PYTHON_PYQT5_MODULES += QtXmlPatterns
endif

PYTHON_PYQT5_QTCORE_LICENSE = Open Source

PYTHON_PYQT5_QTCORE_TYPE = shared

# Turn off features that aren't available in current qt configuration
PYTHON_PYQT5_QTCORE_DISABLE_FEATURES += $(if $(BR2_PACKAGE_QT5BASE_OPENGL),,PyQt_OpenGL)
PYTHON_PYQT5_QTCORE_DISABLE_FEATURES += $(if $(BR2_PACKAGE_QT5BASE_OPENGL_DESKTOP),,PyQt_Desktop_OpenGL)
PYTHON_PYQT5_QTCORE_DISABLE_FEATURES += $(if $(BR2_PACKAGE_OPENSSL),,PyQt_SSL)

define PYTHON_PYQT5_QTCORE
	echo $(1) >> $(2)/cfgtest_QtCore.out
endef

# Since we can't run generate cfgtest_QtCore.out by running qtdetail on target device
# we must generate the configuration.
define PYTHON_PYQT5_GENERATE_QTCORE
	$(RM) -f $(1)/cfgtest_QtCore.out
	$(call PYTHON_PYQT5_QTCORE,$(PYTHON_PYQT5_QTCORE_LICENSE),$(1))
	$(call PYTHON_PYQT5_QTCORE,$(PYTHON_PYQT5_QTCORE_TYPE),$(1))
	$(foreach f,$(PYTHON_PYQT5_QTCORE_DISABLE_FEATURES),
		$(call PYTHON_PYQT5_QTCORE,$(f),$(1)) \
	)
endef

# The file "qt.conf" can be used to override the hard-coded paths that are
# compiled into the Qt library. We need it to make "qmake" relocatable and
# tweak the per-package install paths
PYTHON_PYQT5_PRE_CONFIGURE_HOOKS += QT5_QT_CONF_FIXUP

PYTHON_PYQT5_CONF_OPTS = \
	--bindir $(TARGET_DIR)/usr/bin \
	--destdir $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages \
	--qmake $(HOST_DIR)/bin/qmake \
	--sysroot $(STAGING_DIR)/usr \
	-w --confirm-license \
	--no-designer-plugin \
	--no-docstrings \
	--no-sip-files \
	--assume-shared \
	$(foreach module,$(PYTHON_PYQT5_MODULES),--enable=$(module))

define PYTHON_PYQT5_CONFIGURE_CMDS
	$(call PYTHON_PYQT5_GENERATE_QTCORE,$(@D))
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(TARGET_CONFIGURE_OPTS) \
		$(HOST_DIR)/bin/python configure.py \
			$(PYTHON_PYQT5_CONF_OPTS) \
	)
endef

define PYTHON_PYQT5_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

# __init__.py is needed to import PyQt5
# __init__.pyc is needed if BR2_PACKAGE_PYTHON_PYC_ONLY is set
define PYTHON_PYQT5_INSTALL_TARGET_CMDS
	# Parallel install is not supported.
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D) install
	touch $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/PyQt5/__init__.py
	$(RM) -rf $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/PyQt5/uic/port_v2
endef

$(eval $(generic-package))
