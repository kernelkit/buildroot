VEST i.MX 8M Plus Development Kit
=================================

The VEST i.MX8M Plus Dev Kit consists of a carrier board and a SOM (of
SO-DIMM type, not SMARC).  In many regards the board and SOM are very
similar to the NXP i.MX8MP EVK, hence the similarities in this doc.

- https://www.apc-vest.com/wp-content/Documents/User%20Manual/VEST/VEST%20i.MX8M%20Plus%20Carrier%20Board%20Hardware%20Reference%20Manual%20Rev%20C%20(20240301).pdf
- https://www.apc-vest.com/wp-content/Documents/User%20Manual/VEST/i.MX8M%20Plus%20SOM%20Board%20Hardware%20Reference%20Manual%20Rev%20C%20(20240229).pdf


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

Set SW1 (on the SOM) to boot from SD card: 0011

  +------------+------+
  | Boot Media |  SW1 |
  +------------+------+
  | Fuse       | 0000 |
  | Serial     | 0001 |
  | eMMC       | 0010 |
  | SD card    | 0011 |
  +------------+------+

Connect the USB-to-serial connector to CN21 (CN22 is the the Cortex-M
console), speed 115200 8N1.  The pinout of both connectors are:

     v
    1 2 3 4 5 6   CN21 (UART1)
    G N N R T N
    N C C x x C
    D     D D

     v
    1 2 3 4 5 6   CN22 (UART2)
    G N N R T N
    N C C x x C
    D     D D

Use an FTDI TTL-232R-RPi cable[1], for instance, to connect:

 - Connect the black GND to pin 1 (on CN21)
 - Connect the orange TxD to pin 4 (RxD on CN21)
 - Connect the yellow RxD to pin 5 (TxD on CN21)


[1]: https://ftdichip.com/wp-content/uploads/2020/07/DS_TTL-232R_RPi.pdf
