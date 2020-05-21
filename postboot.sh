#!/bin/sh -e
# 5-19-2020 Ken postboot
#
# This is useful for Beaglebone Debian images 4-6-2020 or later.
#
# Create a folder in /home/debian/cronjobs. mkdir ~/cronjobs
#
# Put this file in the cronjobs folder
#
# Edit THIS file for Country and Time Zone see America/New_York below.
#
# Since this needs root permission add as sudo crontab -e  use full path names
#
# And add the following string. 1> and 2> need to be on the same line.
#
# @reboot sh /home/debian/cronjobs/postboot.sh 1>/home/debian/cronjobs/log
#                                              2>/home/debian/cronjobs/log
#
# Setup /etc/default/bb-boot if not set for your network. sudo nano /etc/default/bb-boot
#
# After completed test it  sudo reboot
#
# After systems comes up check log file. cat ~/cronjobs/log  . The log file only shows current boot.
#
# That's it.
#
if ! id | grep -q root; then
	/bin/echo "Must be run as root"
	exit
fi
if [ -f /etc/default/bb-boot ] ; then
	. /etc/default/bb-boot
fi
if [ "x${USB_CONFIGURATION}" = "x" ] ; then
	USB0_SUBNET=192.168.7
	DNS_NAMESERVER=8.8.8.8
fi
/bin/echo "=== Boot ==="
# Sleep 20 to allow system to complete reboot.
/bin/sleep 20
/bin/echo "Set Nameserver and Gateway"
/bin/echo "Nameserver ${DNS_NAMESERVER}, GW ${USB0_SUBNET}.1"
/bin/echo "nameserver ${DNS_NAMESERVER}" > /etc/resolv.conf
/bin/echo "Set route with gw ${USB0_SUBNET}.1"
/sbin/route add default gw ${USB0_SUBNET}.1 || true
/bin/sleep 2
/bin/echo "Display route"
# /sbin/netstat -rn
/sbin/route
/bin/echo "Set timezone"
# Check your timezone             |---------------|
/usr/bin/timedatectl set-timezone America/New_York
/usr/bin/timedatectl status
# Correct date/time and time zone should be displayed
/bin/echo -n "Finished at  " ; /bin/date
/bin/echo " "

