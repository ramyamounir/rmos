# RM OS

This repository contains operating system and user configurations.

This document outlines steps to [install Arch Linux afresh](#arch-install),
[configure the root account](#root), and quickly [load user settings](#user). In
addition, it provides a [minimal terminal- and shell-based setup](#workbench)
for seamlessly working on a range of operating systems.

## Table of contents

1. [Arch Linux: installation and configuration](#arch-instal)
2. [Root account configurations](#root)
3. [User setup](#user)
    1. [Saving and applying patches](#user-patches)
4. [The workbench triad](#workbench)
    1. [Terminal emulator (Alacritty)](#workbench-alacritty)
    2. [Shell (zsh)](#workbench-zsh)
    3. [Text editor (vim)](#workbench-vim)
5. [Miscellaneous](#miscellaneous)
    1. [Users and groups management](#miscellaneous-user-group)
        1. [Groups](#miscellaneous-user-group-groups)
        2. [Users](#miscellaneous-user-group-users)
    2. [Graphics card](#miscellaneous-graphics-card)
    3. [Display manager (optional)](#miscellaneous-login-manager)
    4. [OpenSSH](#miscellaneous-openssh)
        1. [Generating SSH keys](#miscellaneous-openssh-keys)
    5. [Network configuration](#miscellaneous-network)
        1. [Making connections](#miscellaneous-network-connect)
        2. [WPA Supplicant](#miscellaneous-network-wpa)
    6. [Firewall](#ufw)
    7. [Reverse proxy](#nginx)
    8. [Network file system (NFS)](#miscellaneous-nfs)
    9. [Bluetooth](#miscellaneous-bluetooth)
    10. [GPG](#miscellaneous-gpg)
    11. [Keyring](#miscellaneous-keyring)
    12. [Printer](#miscellaneous-printer)
    13. [Git](#miscellaneous-git)
         1. [Configuration](#miscellaneous-git-configuration)
         2. [Configuring Git signing key with GPG](#miscellaneous-git-gpg)

## 1. Arch Linux: installation and configuration <a name="arch-instal"></a>

This section contains summarised [steps to
instal](https://wiki.archlinux.org/title/Installation_guide) the [Arch
Linux](https://archlinux.org/) operating system.

> **Note**. Most motherboards use the traditional BIOS (sometimes referred to as
> the legacy mode and often recommended if a choice is available); some,
> however, use and require UEFI. To check if the motherboard uses and requires
> UEFI, list the files in `/sys/firmware/efi/efivars`. If there are no files or
> no such directory exists, then the motherboard uses the traditional BIOS,
> otherwise UEFI.

0. [Download](https://archlinux.org/download/) an optical disc (ISO) image of
   Arch Linux. It can also be downloaded through a torrent file. For example,
   with [aria2](https://aria2.github.io/):

   ```sh
   aria2c <FILENAME>.torrent
   ```

   Write the image to a bootable storage medium--like [a flash
   disc](https://wiki.archlinux.org/title/USB_flash_installation_medium), for
   example:

   ```sh
   dd if=<ISO_FILE> of=/dev/DEV status=progress
   ```

   Boot the computer with the ISO.

1. Update the system clock:

   ```sh
   timedatectl set-ntp true
   ```

2. [Partition the discs](https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks),
   [set partition types](https://en.wikipedia.org/wiki/Partition_type),
   [format the partitions](https://wiki.archlinux.org/title/Installation_guide#Format_the_partitions)
   with appropriate file systems, and
   [mount](https://wiki.archlinux.org/title/Installation_guide#Mount_the_file_systems)
   them as needed:

   ```sh
   fdisk -l
   ```
   
   The table below is an example partition configuration.

   | Partition | Partition type number    | Size                                                    | File system               | Mount points                                   |
   | --------- | ---------------------    | ----                                                    | -----------               | ------------                                   |
   | Boot      | 1 (EFI) or 4 (BIOS boot) | 2GB (at least 300MB, at least 1GB for multiple kernels) | FAT 32 (`mkfs.fat -F 32`) | `/mnt/boot` (legacy) or `/mnt/boot/efi` (UEFI) |
   | Swap      | 19 (Linux Swap)          | 128GB (at least 150% of the RAM)                        | Swap (`mkswap`)           | ([SWAP])                                       |
   | Root      | 23 (Linux Root)          | 64GB (at least 15GB)                                    | Ext4 (`mkfs.ext4`)        | `/mnt`                                         |
   | Home      | 42 (Linux Home)          |                                                         | Ext4 (`mkfs.ext4`)        | `/mnt/home`                                    |

   Mount the partitions:

   ```sh
   swapon <parititon> # for the swap partition
   mount <partition> # for all others.
   ```

3. If using Wi-Fi, connect to the Internet:

   ```sh
   $ iwctl
   $ device list
   > station [station_no] connect [network_name]
   ```

4. Instal the Linux kernel and the Arch Linux distribution:

   ```sh
   cd /mnt/home
   curl https://raw.githubusercontent.com/ramyamounir/rmos/master/.local/scripts/getarchsetupscripts | bash
   
   # assuming that the root volume is mounted at `/mnt`; it can be changed in `instalfromcsv`
   ./instalfromcsv base.csv
   ```
   
   If there are any GPG key issues, run:

   ```sh
   rm -rf /etc/pacman.d/gnupg
   killall gpg-agent
   pacman-key --init
   pacman-key --populate archlinux
   ```

5. Generate the file system table (`fstab`):

   ```sh
   genfstab -U /mnt >> /mnt/etc/fstab
   ```

6. Change to the root account at mount point:

   ```sh
   arch-chroot /mnt
   ```

## 2. Root account configurations <a name="root"></a>

1. Set up the initial RAM file system (initramfs):

   ```sh
   mkinitcpio -P
   ```

2. Set root account password:

   ```sh
   passwd
   ```

3. Instal basic root packages:

   ```sh
   cd /home
   ./instalfromcsv root.csv
   ```

4. Set locale and system clock.

   Uncomment the language(s) of choice in `/etc/locale.gen` and run:

   ```sh
   locale-gen
   # echo "LANG=en_GB.UTF-8" > /etc/locale.conf
   ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
   hwclock --systohc --localtime # or --utc
   ```

   Enable and start NTP for synchronised clock across boots:

   ```sh
   systemctl enable ntpd.service
   systemctl start ntpd.service
   ```

5. Set up default terminal settings. To set the default teletypewriter (`tty`)
   (_i.e._, console) font, modify `/etc/vconsole.conf`:

   ```txt
   FONT=zap-ext-light18.psf
   ```

   To persist the settings, modify `/etc/profile`:

   ```txt
   # font settings for physical terminal (avoids warnings during ssh, etc.)
   if [[ "`tty`" == "/dev/tty"* ]]; then
       setfont -h28 zap-ext-light18.psf
       stty cols 213 rows 57 # the console window size
   fi
   ```

   > Some console fonts are available in
   > `.config/fontconfig/fonts/console-fonts`.

6. Set the host name ("machine name") in `/etc/hostname`.

7. **Boot loader**. This setup uses [GNU GRUB
   2](https://www.gnu.org/software/grub/) for configuring the boot loader and
   [EFI Boot Manager](https://github.com/rhboot/efibootmgr) for boot loader
   management.

   [Grub configuration](https://wiki.archlinux.org/title/GRUB) is summarised
   here:

   1. Instal GRUB:

      ```sh
      # for legacy BIOS
      grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub

      # for EFI mode
      grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
      ```
       
      To avoid the GRUB menu delay, set `GRUB_TIMEOUT_STYLE=hidden` in
      `/etc/default/grub`.

   2. Generate GRUB configuration files:

      ```sh
      grub-mkconfig -o /boot/grub/grub.cfg
      ```

   3. The bootup login message may be configured in `/etc/issue`.

The OS setup concludes here. Exit the root environment (`exit`) and reboot
(`reboot`) the system; unplug or remove the installation medium after power off
and before the reboot occurs.

## 3. User configurations <a name="user"></a>

Once a [network connection](#miscellaneous-network) has been established, a
fresh user setup may be done by simply running the following shell script:

```sh
curl https://raw.githubusercontent.com/ramyamounir/rmos/master/.local/scripts/setuparchuser | bash
```

For available commands, run `tvsos_help`.

### 3.1 Saving and applying patches <a name="user-patches"></a>

Patches saved for any package installed with Make using `setuparchuser` or
`instalfromcsv` will be applied automatically as specified in
`.config/patches/patches.csv` and the patch files saved in
`.config/patches`.

1. To explicitly apply patches, run:
   
   ```sh
   applysettings patch
   ```

2. To explicitly save patches, run:

   ```sh
   savesettings patch
   ```

Patches to be applied and saved for any new packages can be configured in
`.config/patches/patches.csv`.

## 4. The workbench triad <a name="workbench"></a>

These fairly OS-agnostic system configurations help set up the following triad
for a minimal, developer-useable workbench:

* a terminal emulator;
* a shell; and
* a text editor

### 4.1 Terminal emulator <a name="workbench-alacritty"></a>

[Alacritty](https://alacritty.org) is the configured terminal emulator and can
be configured in `$HOME/.config/alacritty/alacritty.yml`.

To apply the terminal theme, run `toggle_alacritty_theme`. Ensure that
`$HOME/.config/alacritty/theme.yaml` is linked to a terminal theme for rendering
colours properly (or simply toggle the terminal theme).

### 4.2 Shell <a name="workbench-zsh"></a>

[Z Shell (Zsh)](https://www.zsh.org) is the configured shell. However, most of
the configurations are available for [GNU
Bash](https://www.gnu.org/software/bash/); simply create symbolic links in the
home directory to `.config/bash/.bash_profile`, `.config/bash/.bashrc`, and
`.config/bash/.bash_logout`.

Zsh can also be easily installed in a `conda` environment. Alternatively, Zsh
can be installed without administrative privileges with the following
instructions:

```sh
# with apt
$ apt download zsh
$ dpkg -x zsh_<version.extension> $HOME/Applications/zsh
$ export SHELL=$HOME/Applications/zsh/bin/zsh
```

Run `instal_omsh` to instal the Zsh theme manager (or `instal_omsh 1` for
Bash). A [list of environment variables](./.config/misc/ENVIRONMENT.md) is used
to automatically customise the settings (for `bash` and `zsh`).

### 4.3 Text editor <a name="workbench-vim"></a>

[Neovim](https://neovim.io) is the configured text editor; however, most of the
configurations, if not all, work with [VI Improved (VIM)](https://www.vim.org/)
as will. For a first-time Vim setup, the functions `SetUp[Neo]Vim` and
`InstalPlugins` can be called in the Vim command mode in succession:

```vim
:call SetUp[Neo]Vim()
:call InstalPlugins()
```

To clean up at any point during the course of Vim usage, run:

```vim
:call CleanUpVim()
```

## 5. Miscellaneous <a name="miscellaneous"></a> 

### 5.1 Users and groups management <a name="miscellaneous-user-group"></a> 

#### 5.1.1 Groups <a name="miscellaneous-user-group-groups"></a> 

Create groups:

```sh
groupadd 
```

Groups may be granted or revoked administrative privileges (`sudo`) in
`/etc/sudoers`.

#### 5.1.2 Users <a name="miscellaneous-user-group-users"></a> 

Create users:

```sh
useradd -m -d <USER_DIR> <USERNAME>
passwd <username> # set user password
```

A user may be added to and removed from a group with `usermod` and deleted from
the system with `userdel`:

```sh
usermod -a <user> -G <group>
usermod -d <user> -G <group>
userdel -r <user>
```

### 5.2 Graphics card <a name="miscellaneous-graphics-card"></a> 

If you are using NVIDIA graphics cards, enable the persistent mode for quick
switch between terminal and GUI display modes and for other graphics performance
improvements:

```sh
systemctl enable nvidia-persistenced
systemctl start nvidia-persistenced
```

### 5.3 Login manager <a name="miscellaneous-login-manager"></a> 

Optionally, this configuration contains setup files for [Light Display
Manager (ldm)](https://github.com/canonical/lightdm).

The following configurations are sufficient for it to work (provided the
packages `lightdm` and `lightdm-webkit2-greeter` are installed).

```txt
# /etc/lightdm/lightdm.conf

[Seat:*]
...
greeter-session=lightdm-webkit2-greeter
user-session=xinitrc
session-wrapper=/etc/lightdm/Xsession # requires .xinitrc to have 755 permission
...
```

Then, enabling or disabling the manager is sufficient:

```bash
systemctl enable lightdm.service
```

To use an [aqua](https://en.wikipedia.org/wiki/Aqua_(user_interface))-like
login theme, place the theme's contents at `/usr/share/lightdm-webkit/themes` (a
copy is forked at `git@github.com:sujaltv/aqua.git`). To let the greeter apply
this theme, update its configuration:

```text
# /etc/lightdm/lightdm-webkit2-greeter.conf
[greeter]
...
webkit_theme = aqua
...
```

### 5.4 SSH server <a name="miscellaneous-openssh"></a> 

[OpenSSH](https://www.openssh.com/portable.html) is the default configured SSH
service provider and can be enabled and started as a service.

```sh
systemctl enable sshd
systemctl start sshd
```

The SSH server configurations can be modified in `/etc/ssh/sshd_config`.

The following are some specific configurations:

```text
PubkeyAuthentication              yes
AuthorizedKeysFile                .ssh/authorized_keys
PasswordAuthentication            no
Subsystem                         sftp /usr/lib/ssh/sftp-server   # enables SFTP/SCP
ChallengeResponseAuthentication   no                              #   for   MacOS
```

The server's IP address may be obtained with:

```sh
ip addr
```

#### 5.4.1 Generating SSH keys <a name="miscellaneous-openssh-keys"></a>

```sh
# Generating public-private key pair
> ssh-keygen

# Generating a public key from an existing private key
> ssk-keygen -f <FILENAME> -y > <PUBLIC_FILENAME> # if prmpter, enter the key password

# If the Return key results in ^M (i.e., no progress), run the following.
> stty sane
```

### 5.5 Network configuration <a name="miscellaneous-network"></a> 

[NetworkManager](https://networkmanager.dev/) is the default network manager in
this setup. It can be automatically enabled and started as a service:

```sh
systemctl enable NetworkManager
systemctl start NetworkManager
```

#### 5.5.1 Making connections <a name="miscellaneous-network-connect"></a> 

```sh
nmcli networking on # enable networking
nmcli radio wifi on # enable Wi-Fi
nmcli -a device wifi connect <SSID> # connect to a Wi-Fi
```

#### 5.5.2 WPA Supplicant <a name="miscellaneous-network-wpa"></a> 

NetworkManager requires [WPA Supplicant](https://w1.fi/wpa_supplicant/) to be
installed, enabled, and started.

```sh
systemctl enable wpa_supplicant
systemctl start wpa_supplicant
```

### 5.6 Firewall <a name="ufw"></a> 

[Uncomplicated Firewall (UFW)](https://launchpad.net/ufw) is the configured
firewall. It can be enabled or disabled as a service or _ad hoc_ with the
following commands.

```sh
# with systemctl
systemctl enable ufw
systemctl start ufw

# in addition... 
ufw enable # to enable
ufw reload # to reload
ufw disable # to disable
ufw status numbered # to list the configuration
```

### 5.7 Reverse Proxy <a name="nginx"></a> 

[Nginx](https://www.nginx.com/) is the configured reverse proxy server and can
be enabled and disabled as a service. The following is an example configuration.

```txt
# /etc/nginx/nginx.conf

# number of workers
worker_processes 1;

events {
    # number of connections per worker
    worker_connections 256;
}

http {
    # redirect all HTTP requests to HTTPS
    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name _;
        return 301 https://$host$request_uri;
    }

    server {
        # some process
        listen EXTERNAL_PORT ssl; # `ssl` if certificates are to be used
        server_name example.domain.com, example2.domain.com;
        # if using SSL keys
        ssl_certificate PATH_TO_CERT;
        ssl_certificate_key PATH_TO_KEY_PEM;

        location / {
            proxy_pass http://127.0.0.1:PROCESS_PORT;
            proxy_set_header Host $host;
            poxy_set_header X-Real-IP $remote_addr;
            poxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        }
    } 
}

# streams (e.g., ssh)
stream {
    server {
        listen EXTERNAL_PORT;
        proxy_pass 127.0.0.1:INTERNAL_PORT; # e.g.: 127.0.0.1:22 for ssh
    }
}
```

A generic error file may also be configured as follows:

```txt
# /etc/nginx/error_conf

location = /error.html {
	root /usr/share/nginx/html;
}
error_page <ERROR_CODE> /error.html;
```

and may be included in any `server` section of the main configuration as:

```txt
include error_conf;
```

[Certbot](https://certbot.eff.org/) may be used for obtaining SSL certificates
for free of charge.

```sh
# example
certbot certonly --nginx --domain example.domain.com
```

Alternatively, self-signed certificates may be created with
[OpenSSL](https://www.openssl.org/):

```sh
openssl req -x509 -nodes -days 730 -newkey rsa:4080 -keyout <KEY_PATH.pem> -out <CERT_PATH.pem>
```

### 5.8 Network file system (NFS) <a name="miscellaneous-nfs"></a> 

This configuration uses the [Linux kernel implementation of
NFS](https://nfs.sourceforge.net/). It can be set up with `nfs-utils` and
configured in `/etc/exports`. An example configuration is hereunder:

```txt
/dev/sdb hostname1(rw,sync) hostname2(ro,sync)
```

A service needs to be started for the server to function:

```sh
systemctl enable nfs-server.service
systemctl start nfs-server.service
```

Mounting can be as `sudo mount HOST_IP:SHARED_PATH DEST_PATH`.

An appropriate `fstab` entry may be added in `/etc/fstab`:

```txt
PATH    DEST    nfs     noauto,nofail,ro   0   2
```

### 5.9 Bluetooth <a name="miscellaneous-bluetooth"></a> 

This configuration uses the Linux Bluetooth protocol stack
[BlueZ](http://www.bluez.org/), configurable with `bluez` and its utilities
extension `bluez-utils`. It can be enabled and started as a service:

```sh
systemctl enable bluetooth
systemctl start bluetooth
```

> **Note:** To ensure that Bluetooth hardware is supported by the system, run
> `rfkill list`. To unblock (if blocked), run `sudo rfkill unblock bluetooth`.

To scan, connect, list, delete, and perform other operations on Bluetooth
devices, enter the Bluetooth controller interactive shell:

```sh
bluetoothctl
> agent on # enable Bluetooth agent
> scan on # scan devices
> pair XX:XX:XX:XX:XX:XX # pair a device
> connect XX:XX:XX:XX:XX:XX # connect to a device
> exit # exit the interactive shell
```

or directly inline in the command line interface (_e.g._, `bluetoothctl connect
XX:XX:XX:XX:XX:XX`).

### 5.10 GPG <a name="miscellaneous-gpg"></a> 

This configuration uses [GNU Privacy Guard (GPG)](https://www.gnupg.org/) for
OpenPGP.

```sh
# Generating a secret key
> gpg --full-generate-key

# Listing secret keys
> gpg --list-secret-keys --keyid-format long

# Exporting a secret key to a file
> gpg --export-secret-keys --armor <KEY_ID> > <FILENAME>

# Importing a saved key (for reuse)
> gpg --import <FILENAME>

# Generating a public key from the secret key
> gpg --armour --export <KEY_ID>

# Exporting a public key to a file
> gpg --armour --export <KEY_ID> > <FILENAME>

# Deleting a secret key
> gpg --delete-secret-key <KEY_ID>

# Deleting a public key
> gpg --delete-key <KEY_ID>

# list all keys
> gpg --list-keys --keyid-format long

# list secret keys
> gpg --list-secret-keys --keyid-format long

# list public keys
> gpg --list-public-keys --keyid-format long

# edit a key
> gpg --edit-key <KEY_ID>
$ adduid
$ save
```

The agent my be killed and restarted with the following commands:

```sh
gpg-agent kill
gpg-connect-agent reloadagent /bye
```

### 5.11 Keyring <a name="miscellaneous-keyring"></a> 

[GNOME Keyring](https://wiki.gnome.org/Projects/GnomeKeyring) is the default
keyring installed with this setup and can be enabled per and by the user:

```sh
systemctl --user enable gcr-ssh-agent.socket gcr-ssh-agent.service
systemctl --user start gcr-ssh-agent.socket gcr-ssh-agent.service
```

This keyring requires the following configurations in `/etc/pam.d/login` to work
across login sessions:

```txt
...
auth       optional     pam_gnome_keyring.so
...
session    optional     pam_gnome_keyring.so auto_start
```

### 5.12 Printer <a name="miscellaneous-printer"></a> 

To enable printer services from the get go, enable and start `cups.service`;
alternatively, to enable the printer services only upon request, enable and
start `cups.socket`.

The printer may be searched with the [appropriate
driver](https://wiki.archlinux.org/title/CUPS/Printer-specific_problems) and
added to CUPS using `lpadmin`. For example, Canon Pixma MX490 may be added by
first looking up its URI:

```sh
cnijlgmon3 # prints the URI
sudo lpadmin -p <PRINTER_NAME> -P /usr/share/cups/model/<DRIVER>.ppd -v <URI> -E
```

Other useful commands:

```sh
lpinfo -m # list available drivers

lpinfo -v # list available printers

lpstat -p <PRINTER> [options] # list statistics of a specific printer
```

### 5.13 Git <a name="miscellaneous-git"></a> 

#### 5.13.1 Configuration <a name="miscellaneous-git-configuration"></a> 

```sh
# Configurations stored at $HOME/.gitconfig

git config --global user.email <email_id>
git config --global user.name <username>
git config --global credential.helper store
git config --global commit.gpgsign true
git config --global gpg.program gpg
git config --global tag.gpgsign true
git config --global push.default current
git config --global pull.default current
git config --local status.showuntrackedfiles no
```

#### 5.13.2 Configuring Git signing key with GPG <a name="miscellaneous-git-gpg"></a> 

1. Add the public key to Git provider's settings.
2. Add the secret key locally to Git configurations:
   ```sh
   git config --global user.signingkey <subkey_ID>
   ```
