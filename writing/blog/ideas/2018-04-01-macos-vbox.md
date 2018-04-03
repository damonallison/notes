# Running macOS in VirtualBox

## Download the installer from MAS

* Problem : Older OS can't download newer OSs.

## Create ISO 

* [macOS VirtualBox VM](https://github.com/geerlingguy/macos-virtualbox-vm)

## Create the VirtualBox VM

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

## Install High Sierra on unsupported Mac

My Mac is truly unsupported. The Broadcom wifi card is not compatible with High Sierra.

* [macOS High Sierra Patcher Tool for Unsupported Macs](http://dosdude1.com/highsierra/)
