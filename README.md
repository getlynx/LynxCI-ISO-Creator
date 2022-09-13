![Lynx logo](https://get.clevver.org/9f72f19711a5784e0382d3e2fbfb3660171975b335f789404f149a146c08a05b.png)

# LynxCI ISO Creator

The image file that is used by LynxCI for the Raspberry Pi is a modified version of Raspberry Pi OS. The source OS is modified by this script to create a new image file. The new file has a modification to the /etc/rc.local file so on boot, it triggers the execution of the LynxCI install script. This design works well because the image file does not need to be updated when the LynxCI installer is updated. This script only needs to be executed when the [Raspberry Pi Foundation](https://www.raspberrypi.com/software/) releases a new version of Raspberry Pi OS Lite.

You can read more about the [LynxCI ISO here](https://docs.getlynx.io/lynx-core/lynxci/iso-for-raspberry-pi).

### Usage (as root user)

```./build.sh "https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-07/2022-09-06-raspios-bullseye-armhf-lite.img.xz"```

or

```wget -qO - https://raw.githubusercontent.com/getlynx/LynxCI-ISO-Creator/main/build.sh | bash```
