ESP8266 Docker Buildbox
=======================

This build script use some resource which i mirror to google drive to get better download speed.
Usage
=====

> sudo docker build -t phuonglm/esp8266-builder .

Export the serial adaptor
=========================

You can export the ttyUSB0 device from the HOST to the GUEST instance with this command:

> root@mybox# docker run --privileged -v=/dev/ttyUSB0:/dev/ttyUSB0 -v=/mnt/Storage/phuonglm/Projects/external/esp8266:/home/workspace -i -t phuonglm/esp8266-builder
> 
> root@7dfd28f629ce:/# ls /dev/tty*
> 
> /dev/tty  /dev/ttyUSB0  /dev/tty0  /dev/tty1  /dev/tty2
> /dev/tty3  /dev/tty4  /dev/tty5  /dev/tty6  /dev/tty7  /dev/tty8
> /dev/tty9

Todo
====

* Add blinky example
* Add esptool to push blinky example
* Find some other simpler examples
