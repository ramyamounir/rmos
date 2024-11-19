<h1 align="center">RMOS User Configs</h1>

**This document provides user configurations for RMOS, additional configs may be provided under the corresponding config directory.**


All user configurations, applicable for any Linux-based as well as console-based
environment, can be applied by downloading the configuration files and
organising them as below.

```txt
$HOME
 ├─ .configs/     # configuration files and directories ($XDG_CONFIG_HOME)
 ╰─ .local
     ├─ bin/      # binary files
     ├─ cache/    # cache ($XDG_CACHE_HOME)
     ├─ data/     # persistent data (e.g., databases, credentials, etc.) ($XDG_DATA_HOME)
     ├─ logs/     # logs ($XDG_STATE_HOME)
     ╰─ src/      # source code (of manually built applications)
```

## Table of contents

1. [User Configs Installation](#installation)
2. [Terminal Shell](#shell)
    1. [Plugin Managers](#zim)
    2. [Environment Variables](#env-vars)
    2. [Setting Screen Layout](#screen_layout)
3. [Terminal Emulator](#alacritty)
4. [Text Editor](#nvim)
5. [RMOS Desktop Environment](#suckless)
    1. [Dynamic Window Manager (DWM)](#dwm)
    2. [DMenu](#dmenu)
    3. [DWM Blocks](#dwmb)
6. [GnuPG and SSH](#gpg)
7. [LF File Manager](#lf)
8. [Fonts](#fonts)
9. [Bluetooth](#bluetooth)
10. [Printers](#printers)
11. [Scanners](#scanners)
12. [Access Conrol List](#acl)


### 1. User Configs Installation <a name="installation"></a>

This has been automated with a shell script. Once a network connection has been established, all user configurations can be applied by simply running the following shell command:

```sh
# Connect to wifi if not connected
nmcli device wifi connect <SSID> password <passwd>
# or
nmcli con up <SSID> --ask

# Get script and set up user
source <(curl -Ls https://raw.githubusercontent.com/ramyamounir/rmos/refs/heads/main/.config/scripts/setupuser)

# Import GPG key
gpg --import [KEY]

# (optional) Run postgpg script to get pass repository and enable some services
postgpg
```

This script will download the packages under the `.config/packages/[DISTRIBUTION]/user.csv`.
Additional packages are available in sub-csv files and can be installed independentaly with the `instalfromcsv.sh` script.


### 2. Terminal Shell <a name="shell"></a>

[Z Shell (Zsh)](https://www.zsh.org) is the configured shell. However, most of the configurations are available for [GNU Bash](https://www.gnu.org/software/bash/); simply create symbolic links in the home directory to `.config/bash/.bash_profile`, `.config/bash/.bashrc`. For zsh, create a link to `.config/zsh/.zprofile` in the home directory.

Zsh can also be easily installed in a `conda` environment.


#### 2.1 Plugin Managers <a name="zim"></a>

By default, or if specified to use the [ZIM](https://zimfw.sh/) plugin manager, the shell setup will install (if not installed) and initialise ZIM (if necessary). To manually do the two, run `init-zim` and `zimfw init`, respectively. 

The following environment variables are used to automatically customize the settings (for `bash` and `zsh`).

#### 2.2 Environment Variables <a name="env-vars"></a>

If they exist, `$XDG_DATA_HOME/.env` will be invoked at the beginning of setting up the shell and `$XDG_DATA_HOME/.rc` at the end. This list contains the optional environment variables that can be exported in `$XDG_DATA_HOME/.env` as needed and will be used in the shell configurations with this setup.

| Variable name           | Usage                                                                                                                    |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `AM_I_ADMIN`            | Specify when the user is the admin (0 for not admin; 1 for admin; default = 0)                                           |
| `BORE_SECRET`           | Bore tunnel secret token                                                                                                 |
| `BORE_SERVER`           | Bore tunnel server URL                                                                                                   |
| `DISABLE_UPDATE_CMDS`   | Disabled all update commands (defaults to `1`)                                                                           |
| `SHELL_PLUGIN_MANAGER`  | Shell plugin manager (`zim` or `ohmy`; defaults to `zim`)                                                                |
| `SLACK_SERVER_URL`      | The URL of the server (Used by `slackme`)                                                                                |
| `SLACK_WORKSPACE_TOKEN` | Slack API Key(Used by `slackme`)                                                                                         |
| `SLACK_CHANNEL_ID`      | channel ID to which to send the slack message(Used by `slackme`)                                                         |
| `SSH_KEYRING_COMPANION` | Whether to use GPG (`gpg`) or GNOME Keyring (`gnome`) agent with ssh                                                     |
| `SSH_MNT_DIR`           | SSHFS mount directory (used by `portal`) (default: `/media/network`)                                                     |
| `STORAGE_DIR`           | Used by the command `mkpdir` as the storage location                                                                     |
| `USE_ZSH_AT`            | Path to `zsh`. This variable is useful when the default shell is bash, cannot be changed, but zsh is preferred.          |
| `WINDOW_MANAGER`        | The window manager to use (`gnome` for GNOME (requires GNOME to be installed); none for dwm; default: dwm)               |

#### 2.3 Setting Screen Layout <a name="screen_layout"></a>

To set a system specific screen layout, specify an xrandr command in the file `$XDG_DATA_HOME/screenlayout.sh`.
The package `arandr` can be used to configure and export this xrandr command to the desired location.




### 3. Terminal Emulator <a name="alacritty"></a>

[Alacritty](https://alacritty.org) is the installed terminal emulator and can be configured in `$HOME/.config/alacritty/alacritty.toml`.
Here are some of the keybindings configured in Alacritty.

| Mod         | Key    | Action                   |
| ----------- | ------ | ------------------------ |
| Alt         | c      | Copy                     |
| Alt         | v      | Paste                    |
| Alt         | Escape | ToggleViMode             |
| Alt         | j/k    | Scroll Line up/down      |
| Alt         | u/d    | Scroll Half page up/down |
| Alt         | U/D    | Scroll to top/bottom     |
| Alt - Shift | j/k    | Change font size         |


### 4. Text Editor <a name="nvim"></a>

[NeoVim](https://neovim.io/) is the installed text editor. Nvim is configured to install its plugin manager and its plugins.
It should right work out of the box. Here are some keybindings in nvim.

| Plugin    | Mod       | Key                | Action                              |
| --------- | --------- | ------------------ | ----------------------------------- |
| Core      | Ctrl      | h/j/k/l            | Move between splits                 |
| Core      | Ctrl      | up/down/left/right | Resize splits                       |
| Core      | Space     | j                  | close buffer (`:q`)                 |
| Core      | Space     | k                  | New tab                             |
| Core      | Shift     | h/l                | Cycle between tabs                  |
| Core      | -         | zz                 | Save all buffers (`:wa`)            |
| Core      | Shift     | zz                 | Save and close all buffers (`:wqa`) |
| Nvim Tree | Space     | e                  | Toggle Nvim tree                    |
| Nvim Tree | -         | a                  | add file                            |
| Nvim Tree | -         | r                  | Rename file                         |
| Telescope | Ctrl      | p                  | Find Files                          |
| Telescope | Ctrl      | t                  | Find text                           |
| GitSigns  | Space - h | p                  | Hunk Preview                        |
| GitSigns  | Space - h | n                  | Hunk Next                           |
| GitSigns  | Space - h | s                  | Hunk Stage                          |
| GitSigns  | Space - h | S                  | Stage file                          |
| GitSigns  | Space - h | u                  | Hunk undo stage                     |
| GitSigns  | Space - h | R                  | Reset buffer                        |
| GitSigns  | Space - h | b                  | Blame line                          |
| GitSigns  | Space -h  | d                  | Diff this                           |
| cmp       | Shift     | k                  | preview definition (hover)          |
| cmp       | Shift     | k (x2)             | Go into preview                     |
| cmp       | Ctrl      | k                  | Exit preview                        |
| cmp       | Ctrl      | y                  | Start Completion suggestions        |
| cmp       | -         | Tab                | Cycle through suggestions           |
| cmp       | -         | Enter              | Select suggestions                  |
| cmp       | -         | gl                 | Show diagnostics (hover)            |
| cmp       | -         | gd                 | Show definition                     |
| cmp       | -         | gD                 | Show Declaration                    |
| cmp       | -         | gR                 | Show References                     |
| cmp       | -         | gi                 | Show Implementation                 |

### 5. RMOS Desktop Environment <a name="suckless"></a>

[Suckless](https://suckless.org/) software is used in RMOS.
All suckless software is written in C++ and configures in the `config.h` header file.
The src files are stored in `.local/src` and compiled in `.local/bin`.

To compile use `make clean install`

#### 5.1 Dynamic Window Manager (DWM) <a name="dwm"></a>

DWM is the tiling window manager installed by default in RMOS. Keybindings are provided in the `.local/src/dwm/config.h` file.
Here are some of the keybinding defined in RMOS.

| Mod           | Key           | Action                   |
| ------------- | ------------- | ------------------------ |
| Super         | Number        | Go to workspace          |
| Super - Shift | Number        | Move Window to Workspace |
| Super         | t             | Layout 1                 |
| Super - Shift | t             | Layout 2                 |
| Super         | y             | Layout 3                 |
| Super - Shift | y             | Layout 4                 |
| Super         | f             | Toggle Full Screen       |
| Super         | b             | Toggle Bar               |
| Super         | Enter         | Spawn Terminal           |
| Super         | Space         | Zoom Window              |
| Super         | j or k        | Move between Windows     |
| Super         | h or l        | Resize Master Window     |
| Super         | w             | Browser                  |
| Super - Shift | w             | Network GUI (NMTUI)      |
| Super         | r             | Lf Window Manager        |
| Super - Shift | r             | Htop                     |
| Super         | q             | Quit Window              |
| Super - Shift | q             | Quit dwm to tty          |
| Super         | z             | Decrease Window gaps     |
| Super         | x             | Increase Window gaps     |
| Super         | m             | Mount device script      |
| Super - Shift | m             | UnMount device script    |
| Super         | Backspace     | Turn off script          |
| Super         | d             | Spawn dmenu              |
| Super         | p             | dmenupass                |
| Super - Shift | p             | Maim pick script         |
| Super         | Left or Right | Switch to monitor        |
| Super - Shift | Left or Right | Move Window to monitor   |
| Super - Shift | b             | Bluetooth TUI            |
| Super         | v             | VPN script               |
| Super         | e             | email client             |

#### 5.2 DMenu <a name="dmenu"></a>

Dmenu allows for running scripts easily. Dmenu has been configured to run in the center of the screen.
Make sure to pass the output of the command `$(dwm -m)` to the dmenu command; it contains some variables.

#### 5.2 DWM Blocks <a name="dwmb"></a>

DWMBlocks periodically run script outputs as blocks in the status bar in dwm.

### 6. GnuPG and SSH <a name="gpg"></a>

### 7. LF File Manager <a name="lf"></a>

[Lf](https://github.com/gokcehan/lf) is the configured file manager.
It can be used to navigate and search in the filesystem, as well as preview files.

### 8. Fonts <a name="fonts"></a>

Some fonts are available in the `.config/fontconfig` directory, including nerd font symbols.

```sh
# To install fonts
fc-cache -fr

# To list available fonts
fc-list
```


### 9 Bluetooth <a name="bluetooth"></a> 

This configuration uses the Linux Bluetooth protocol stack
[BlueZ](http://www.bluez.org/), configurable with `bluez` and its utilities
extension `bluez-utils`. It can be enabled and started as a service:

```sh
systemctl enable bluetooth
systemctl start bluetooth
```

> **Note:** To ensure that Bluetooth hardware is supported by the system, run
> `rfkill list`. To unblock (if blocked), run `rfkill unblock bluetooth`.

To scan, connect, list, delete, and perform other operations on Bluetooth
devices, enter the Bluetooth controller interactive shell:

```sh
bluetoothctl
> agent on # enable Bluetooth agent
> scan on # scan devices
> pair XX:XX:XX:XX:XX:XX # pair a device
> connect XX:XX:XX:XX:XX:XX # connect to a device
> set-alias ALIAS # device alias
> exit # exit the interactive shell
```

or directly inline in the command line interface (_e.g._, `bluetoothctl connect
XX:XX:XX:XX:XX:XX`).

**After pairing a new device, the script `dm-bluetooth` can be used to connect to paired devices.**

### 10 Printer <a name="printers"></a> 

To use printers, enable and start `cups.service`; alternatively, to enable them
on demand, enable and start `cups.socket`.

```sh
systemctl enable cups.service

# on demand
systemctl enable --user cups.socket
```

If necessary, the printer may be searched with the [appropriate
driver](https://wiki.archlinux.org/title/CUPS/Printer-specific_problems) and
added to CUPS using `lpadmin`. If the IP address of the printer is know, then
it can be configured over `ipp`:

```sh
# with IP address
lpadmin -p PRINTER_NAME -E -v "ipp://IP_ADDRESS/ipp/print" -m everywhere

# with URI obtained with a driver
lpadmin -p PRINTER_NAME -E -v URI -P /usr/share/cups/model/DRIVER.ppd
```

Other useful commands:

```sh
lpinfo -m # list available drivers

lpstat -v # list added printers

lpstat -p PRINTER [options] # list statistics of a specific printer
```

[Ink](https://ink.sourceforge.net/) can be used to print the ink information.
For example:

```sh
ink -b bjnp://IP_ADDRESS
```

Here are a few examples to add Brother and HP printers:

* Here is an example to set up a brother printer:
    ```sh
    lpadmin -p home_brother -E -v "ipp://192.168.50.183/ipp/print" -m everywhere
    ```
* Here is an example to set up an HP printer:
    ```sh
    # Install hplip package (should be part of the printers csv)
    sudo pacman -S hplip

    # Use hp-setup utility with -i (cli) to add the printer
    hp-setup -i
    ```


### 11 Scanners <a name="scanners"></a> 

This setup comes with GNOME's [Document
Scanner](https://apps.gnome.org/en/SimpleScan/) graphical interface installed,
which also installs the [SANE](http://www.sane-project.org/) backend necessary
for scanning. For it to work, the `saned` daemon service needs to be enabled and
started.

```sh
systemctl enable --now saned.socket
```

Most scanners can be configured to work wireless by editing the configuration
file relevant to the scanner of interest in `/etc/sane.d` and restarting the
daemon `saned.socket`.

Here is an [example](https://gist.github.com/sieste/77c004a263f1da38688e119c7b4758b8) to set up a brother scanner:

```sh
# add scanner example
sudo brsaneconfig4 -a name='brother' model='DCP-L2540DW' ip=192.168.50.183

# restart sane
sudo systemctl restart saned.socket

# Check if scanner is recognised
scanimage -L
```

**For additional scanner problems check [here](https://wiki.archlinux.org/title/SANE/Scanner-specific_problems).**


### 12 Access Control List <a name="acl"></a> 

To change owners and default permissions use:

```sh
# Change default permissions for all groups, recursively
sudo setfacl -R -d -m g:[group_name]:rwX /path/to/folder

# Change the "sticky" bit to inherit user:group permissions, recursively
sudo chmod -R g+s /path/to/folder

# Change the file permissions to 755, recursively
sudo chmod -R 755 /path/to/folder

# Change the user:group owners, recursively
sudo chown -R [user]:[group] /path/to/folder
```


