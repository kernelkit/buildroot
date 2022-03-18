################################################################################
#
# mv-ddr-marvell
#
################################################################################

# This is the latest commit on mv-ddr-devel as of 2022-01-17
MV_DDR_MARVELL_VERSION = 7753d4b3e42036d44bf3d5b68109f0c7d7aadbcc
MV_DDR_MARVELL_SITE = $(call github,MarvellEmbeddedProcessors,mv-ddr-marvell,$(MV_DDR_MARVELL_VERSION))
MV_DDR_MARVELL_LICENSE = GPL-2.0+ or LGPL-2.1 with freertos-exception-2.0, BSD-3-Clause, Marvell Commercial
MV_DDR_MARVELL_LICENSE_FILES = ddr3_init.c

$(eval $(generic-package))
