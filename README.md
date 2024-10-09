<h1 align="center">RM OS</h1>

<!-- ![](./.config/misc/assets/examples/example2.png) -->

**This repository contains operating system and user configurations of RM OS.**

This document outlines the process of installing Arch Linux and configuring it.
In sub-README files, we go through user configurations in details.

<!-- This document outlines steps to [instal and configure Arch Linux -->
<!-- afresh](#arch-linux), make [system configurations](#system-administration), and -->
<!-- easily [load user settings](#user). The user settings support a -->
<!-- command-line-only setup for seamlessly working in a range of Linux distributions -->
<!-- and other UNIX-like operating systems. -->


## Table of contents

1. [Arch Linux Installation](#arch-linux-installation)
    1. [Live Medium and ISO](#live-medium)
    2. [Disk Partitions and Mounting](#disk-partitions)
    3. [Internet and NTP](#internet-ntp)
    4. [Pacstrap and Chroot](#pacstrap-chroot)
2. [Arch Linux Configuration](#arch-linux-configuration)
    1. [Root Packages and Locale](#root-packages)
    2. [Bootloader](#bootloader)
    3. [Users and Groups](#users-groups)
    4. [Start Systemd Services](#systemd-services)
    5. [Exit and Reboot](#reboot)

## 1. Arch Linux Installation <a name="arch-linux-installation"></a>

### 1.1 Live Medium and ISO <a name="live-medium"></a>
* Download a bootable (ISO) image of [Arch Linux](archlinux.org)
* Write the image to a flash drive: 
    ```sh
    dd if=ISO_FILE of=/dev/DEVICE status=progress
    ```
* Boot from the flash drive


### 1.2 Disk Partitions and Mounting <a name="disk-partitions"></a>

| Partition | Partition type number | Size           | File system              | Mount points |
| --------- | --------------------- | -------------- | ------------------------ | ------------ |
| Boot      | 1 (EFI) or 4 (BIOS)   | 1GB            | FAT32 (`mkfs.fat -F 32`) | `/mnt/boot`  |
| Swap      | 19 (Linux Swap)       | Twice RAM size | Swap (`mkswap`)          |              |
| Root      | 23 (Linux Root)       | at least 16 GB | Ext4 (`mkfs.ext4`)       | `/mnt`       |
| Home      | 42 (Linux Home)       | Rest           | Ext4 (`mkfs.ext4`)       | `/mnt/home`  |

* Partition the disks as needed. use `fdisk /dev/DEVICE` to partition. Use options:
	* P for printing the table
	* n for a new partition
	* d for deleting a partition
	* L to list partition types
	* m for help
* After partitioning, format by making file system using
	* `mkfs.fat -F 32 [PARTITION]` for boot partition
	* `mkswap [PARTITION]` for swap partition 
	* `mkfs.ext4 [PARTITION]` for root and/or home partitions
* Then mount the partitions
	* `mount /dev/[PARTITION] /mnt` to mount the root partition
	* `mkdir /mnt/boot` and `mount /dev/[PARTITION] /mnt/boot` to mount boot partition
	* `mkdir /mnt/home` and `mount /dev/[PARTITION] /mnt/home` to mount home partition
	* `swapon [PARTITION]` for swap partition

### 1.3 Internet and NTP <a name="internet-ntp"></a>
* Connect to WIFI if not on wired ethernet connection.
* For Wifi, use:
	* `iwctl` to start the client
	* `device list` to list available devices
	* `station [device] connect [SSID]` to connect to an SSID
* Set NTP: `timedatectl set-ntp true`


### 1.4 Pacstrap and Chroot <a name="pacstrap-chroot"></a>
* Run pacstrap on base packages with the `instalfromcsv` script

    ```sh
    # prepare for installation
    cd /mnt/home

    # get scripts and install
    curl -Ls https://raw.githubusercontent.com/ramyamounir/rmos/refs/heads/main/.config/scripts/getarchsetupscripts | sh
    ./instalfromcsv base.csv
    ```

* Generate fstab file and check the file exists:
    ```sh
    # Generate fstab
    genfstab -U /mnt >> /mnt/etc/fstab

    # Check file exists
    cat /mnt/etc/fstab
    ```
* Finally, change root in the installed linux: 
	* Change root into installation: `arch-chroot /mnt`
	* Set root password: `passwd`


## 2. Arch Linux Configuration <a name="arch-linux-configuration"></a>

### 2.1 Root Packages and Locale <a name="root-packages"></a>

* Install Root packages with `pacman -S [PACKAGE]`:
    ```sh
    cd /home
    ./instalfromcsv root.csv
    ```

* Set locale and timezone:
	* uncomment `en_US.UTF-8 UTF-8` in `/etc/locale.gen`
	* Run `locale-gen` and `echo "LANG=en_US.UTF-8" > /etc/locale.conf`
	* Run `ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime`
	* Run `hwclock --systohc --localtime`
* Set hostname in `/etc/hostname` and hosts in `/etc/hosts` as shown:
    ```sh
    127.0.0.1   localhost
    ::1         localhost
    127.0.1.1   arch.localdomain    arch
    ```

### 2.2 Bootloader <a name="bootloader"></a>
* Install grub in the `/boot` directory
	* For EFI: 
        ```sh
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub_uefi --recheck
        ```
	* For BIOS:
        ```sh
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
        ```
* Create grub config:
    ```sh
    grub-mkconfig -o /boot/grub/grub.cfg
    ```
### 2.3 Users and Groups <a name="users-groups"></a>
* Add new groups if needed: `groupadd [GROUP]` for sudo, docker and media
* Add new user: `useradd -m ramy`
* Set password of new user: `passwd ramy`
* Set group of new user: `usermod -aG sudo,media,docker ramy`
* Uncomment sudo line in `EDITOR=nvim visudo`

### 2.4 Start Systemd Services <a name="systemd-services"></a>
* Synchronize NTP with `systemctl enable ntpd.service`
* Start the network manager service with `systemctl enable NetworkManager`

### 2.5 Exit and Reboot <a name="reboot"></a>

Exit from the arch installation and reboot after unplugging the live medium:
```sh
exit
umount -R /mnt
reboot
```

**User configurations for the Shell, Terminal Emulator, Nvim and others are available in the configs directory.**



