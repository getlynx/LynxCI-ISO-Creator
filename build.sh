#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Run script as root user
# wget -qO - https://raw.githubusercontent.com/getlynx/LynxCI-ISO-Creator/main/build.sh | bash -s "https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-07/2022-09-06-raspios-bullseye-armhf-lite.img.xz"

# If the download URL of the target img is not supplied, then use a default.
[ -z "$1" ] && target="https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-07/2022-09-06-raspios-bullseye-armhf-lite.img.xz" || target="$1"

# Grab the latest RaspberryOS Lite release
# https://www.raspberrypi.com/software/operating-systems/
# https://downloads.raspberrypi.org/raspios_lite_armhf/
echo "Downloading the supplied OS package. This is the new modified target OS."
wget -q "$target"

# Unpack the downloaded file
echo "Target OS downloaded, unpacking the compressed file."
unxz *.xz

# Create the dir for the image we are gonna mount.
mkdir -p /mnt/lynx1
mkdir -p /mnt/lynx2

# https://www.linuxquestions.org/questions/linux-general-1/how-to-mount-img-file-882386/
# Get the correct offset value we need.
#fdisk -l *.img

# Mount single partition from image of entire disk (device) - Ask Ubuntu
echo "Mounting the target virtual OS."
mount -v -o offset=4194304 -t vfat *.img /mnt/lynx1 > /dev/null 2>&1

# https://www.raspberrypi.com/news/raspberry-pi-bullseye-update-april-2022/
# read the part about Headless setup
echo "pi:\$6\$eH/dFQNHFvfWIQh3\$jgDE54KrKChVSMZr5StLj8vcpzaH/YcdKiethLDtIFHoXDcPAZMJ2Ji1qw2YMoeyE1WCvAkOJ.ExtiCTKIAMR1" > /mnt/lynx1/userconf.txt

umount /mnt/lynx1

mount -v -o offset=272629760 -t ext4 *.img /mnt/lynx2 > /dev/null 2>&1

echo "Setting up the rc.local file on the target OS."
echo "#!/bin/sh -e
#
# Print the IP address
_IP=\$(hostname -I) || true
if [ \"\$_IP\" ]; then
  printf \"My IP address is %s\n\" \"\$_IP\"
fi
printf \"\n\n\n\n\n\n\n\nLynxCI initialization will start in 60 seconds.\n\n\n\n\n\n\"
sleep 60
# Ping Google NS server to test public network access
if /bin/ping -c 1 8.8.8.8
then
        sleep 30
        wget -qO - https://raw.githubusercontent.com/getlynx/LynxCI/master/install.sh | bash
else
        echo \"Network access was not detected. For best results, connect an ethernet cable to your home or work wifi router. This device will reboot and try again in 60 seconds. For more information, visit https://docs.getlynx.io/lynx-core/lynxci/iso-for-raspberry-pi\"
        sleep 60
        reboot
fi
exit 0
" > /mnt/lynx2/etc/rc.local

umount /mnt/lynx2

currentDate=$(date +%F)
mv *.img "$currentDate"-LynxCI.img

echo "Compressing the modified target OS. This might take little while due to the high level of compression used with xz."
xz -9 "$currentDate"-LynxCI.img

echo "The file $currentDate-LynxCI.img.xz is now ready for distribution."
