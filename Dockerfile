FROM ubuntu:14.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q git autoconf build-essential gperf bison flex texinfo libtool libncurses5-dev wget apt-utils gawk sudo unzip libexpat-dev python python-pip vim
RUN useradd -d /opt/Espressif -m -s /bin/bash esp8266
RUN echo "esp8266 ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/esp8266
RUN chmod 0440 /etc/sudoers.d/esp8266
RUN su esp8266 -c "mkdir /opt/Espressif/tools/ -p && cd /opt/Espressif/tools/; git clone -b lx106 git://github.com/jcmvbkbc/crosstool-NG.git && cd /opt/Espressif/tools/crosstool-NG && ./bootstrap && ./configure --prefix=`pwd` && make && sudo make install && ./ct-ng xtensa-lx106-elf && ./ct-ng build"

RUN cd /opt/Espressif/tools/crosstool-NG/builds/xtensa-lx106-elf/bin/ && ln -s xtensa-lx106-elf-objcopy xt-objcopy && ln -s xtensa-lx106-elf-gcc xt-xcc && ln -s xtensa-lx106-elf-nm xt-nm && ln -s xtensa-lx106-elf-objdump xt-objdump


RUN su esp8266 -c "mkdir /opt/Espressif/ESP8266_SDK && wget -q http://phuonglm.net/gdrive/esp8266/esp_iot_sdk_v0.9.4_14_12_19.zip -O /opt/Espressif/esp_iot_sdk_v0.9.4_14_12_19.zip && cd /opt/Espressif/ESP8266_SDK && unzip -o /opt/Espressif/esp_iot_sdk_v0.9.4_14_12_19.zip esp_iot_sdk_v0.9.4/* -d /opt/Espressif/ESP8266_SDK && mv esp_iot_sdk_v0.9.4/* ./ && rm -r esp_iot_sdk_v0.9.4 && rm /opt/Espressif/esp_iot_sdk_v0.9.4_14_12_19.zip"

RUN su esp8266 -c "wget -q http://phuonglm.net/gdrive/esp8266/libs.zip -O /opt/Espressif/libs.zip && cd /opt/Espressif/ESP8266_SDK && unzip -o /opt/Espressif/libs.zip"

RUN su esp8266 -c "wget -q http://phuonglm.net/gdrive/esp8266/esptool-0.0.2.zip -O /opt/Espressif/esptool-0.0.2.zip && cd /opt/Espressif/tools/ && unzip -o /opt/Espressif/esptool-0.0.2.zip && cd /opt/Espressif/tools/esptool && sed -i 's/WINDOWS/LINUX/g' Makefile && make; rm -rf /opt/Espressif/esptool-0.0.2.zip"
RUN ln -s /opt/Espressif/tools/esptool/esptool /usr/local/bin/esptool

RUN su esp8266 -c "cd /opt/Espressif/tools/; git clone https://github.com/themadinventor/esptool.git esptool_py"
RUN cd /opt/Espressif/tools/esptool_py/; sudo pip install -e .

RUN echo 'export XTENSA_TOOLS_ROOT=/opt/Espressif/tools/crosstool-NG/builds/xtensa-lx106-elf/bin/' >> /root/.profile && echo 'export SDK_EXTRA_INCLUDES=/opt/Espressif/ESP8266_SDK/include' >> /root/.profile && echo 'export SDK_EXTRA_LIBS=/opt/Espressif/ESP8266_SDK/lib/' >> /root/.profile && echo 'export SDK_BASE=/opt/Espressif/ESP8266_SDK/' >> /root/.profile && echo 'export ESPPORT=/dev/ttyUSB0' >> /root/.profile && echo 'export PATH=/opt/Espressif/tools/crosstool-NG/builds/xtensa-lx106-elf/bin/:$PATH' >> /root/.profile && echo 'chmod 777 /dev/ttyUSB0' >> /root/.profile

ENTRYPOINT ["/bin/bash", "-l"]