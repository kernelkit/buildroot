VEST i.MX 8M Plus Development Kit
=================================

This is the Buildroot support for the VEST (Venture) NXP i.MX8MP dev kit.
It has a slot for the VEST EDG i.MX8M Plus SMARC module.

This build use entirely upstream components: TF-A, U-Boot and kernel.

The only non-upstream component is the device tree.


How to build it
===============

Configure Buildroot and build it:

  $ make vest-e2i-plus_defconfig
  $ make


Flashing the SD card image
==========================

Copy the sdcard.img file into the SD card:

  $ sudo dd if=output/images/sdcard.img of=<your-sd-device>; sync


Booting the board
=================

To boot your newly created system:

- Insert the SD card in the MicroSD slot of the board.
- Connect a serial to USB cable to the DEBUG port.
- Open a terminal on ttyUSB2 port. For example: sudo picocom -b 115200 /dev/ttyUSB2
- Power on the board.
