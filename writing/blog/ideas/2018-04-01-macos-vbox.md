# Running macOS in VirtualBox

* Install the latest version of VirtualBox.
* Also install the Extension Pack.

Both downloads are [here](https://www.virtualbox.org/wiki/Downloads)

## Download the installer from MAS

* Problem : Older OS can't download newer OSs.

## Create a 10.11 or 10.12 ISO 

This is the process for creating a 10.11 or 10.12 macOS ISO.

* [macOS VirtualBox VM](https://github.com/geerlingguy/macos-virtualbox-vm)

Once you have created the ISO, follow the instructions to create the VirtualBox VM as described in the the next section.

## Create the 10.13 ISO and VirtualBox VM

This is the process for creating a 10.13 ISO. 

It also includes instructions for creating the VirtualBox VM image. Note that you have to manually select the `boot.efi` to continue the upgrade.

* [Create macOS VM](http://tobiwashere.de/2017/10/virtualbox-how-to-create-a-macos-high-sierra-vm-to-run-on-a-mac-host-system/)

## Serial Number

* [Find a working serial number](https://giuliomac.wordpress.com/2014/02/18/how-to-find-a-working-serial-number-for-your-hackintosh/)
    * * 2012 27 inch iMac C02JT1EGDNMP

* [Verify Serial Number](https://checkcoverage.apple.com/)

* Set the serial number on the VM

`VBoxManage setextradata macOS VBoxInternal/Devices/efi/0/Config/DmiSystemSerial C02JT1EGDNMP`

## Upgrade VirtualBox macOS to High Sierra

> "The recovery server could not be contacted"
`sudo ntpdate -u time.apple.com`

> After you install High Sierra and reboot the system, you're brought back into Sierra as if nothing happened.

## Updating to a new OS version

When attempting to update the OS, the system will reboot itself half way thru the install.

In order to continue the re

## Install High Sierra on unsupported Mac

My Mac is truly unsupported. The Broadcom wifi card is not compatible with High Sierra.

* [macOS High Sierra Patcher Tool for Unsupported Macs](http://dosdude1.com/highsierra/)
