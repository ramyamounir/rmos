<h1 align="center">RMOS User Configs</h1>

**This document provides user configurations for RMOS, additional configs may be provdided under the corresponding config directory.**


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
3. [Terminal Emulator](#alacritty)
4. [Text Editor](#nvim)
5. [RMOS Desktop Environment](#suckless)
    1. [Dynamic Window Manager (DWM)](#dwm)
    2. [DMenu](#dmenu)
    3. [DWM Blocks](#dwmb)
6. [GnuPG and SSH](#gpg)
7. [LF File Manager](#lf)
8. [Fonts](#fonts)


### 1. User Configs Installation <a name="installation"></a>

This has been automated with a shell script. Once a network connection has been established, all user configurations can be applied by simply running the following shell command:

```sh
source <(curl -Ls ramyamounir.com/setupuser)

# or
source setupuser  # if the script is already downloaded 
```

This scipt will download the packages under the `.config/packages/[DISTRIBUTION]/user.csv`.
Additional packages are available in sub-csv files and can be installed independentally with the `instalfromcsv.sh` script.


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
| `CLOUD_USERNAME`        | Nextcloud username (used by `syncloud`)                                                                                  |
| `CLOUD_PASSWORD_FILE`   | `pass` filename with Nextcloud password (used by `syncloud`)                                                             |
| `CLOUD_DIR`             | Nextcloud directory (used by `syncloud`)                                                                                 |
| `CLOUD_SERVER_URL`      | Nextcloud server URL (used by `syncloud`)                                                                                |
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
| `VIM_THEME`             | The default Vim theme                                                                                                    |
| `X_DISPLAY_LAYOUT`      | Used by [`xprofile`]($XDG_CONFIG_HOME/x11/xprofile) to determine the screen layout (refer to the profile to get an idea) |
| `X_WALLPAPER`           | Path to an image to set as the background (used by X)                                                                    |


### 3. Terminal Emulator <a name="alacritty"></a>

[Alacritty](https://alacritty.org) is the installed terminal emulator and can be configured in `$HOME/.config/alacritty/alacritty.toml`.


### 4. Text Editor <a name="nvim"></a>

[NeoVim](https://neovim.io/) is the installed text editor. Nvim is configured to intall its plugin manager and its plugins.
It should right work out of the box.


### 5. RMOS Desktop Environment <a name="suckless"></a>

[Suckless](https://suckless.org/) software is used in RMOS.
All suckless software is written in C++ and configures in the `config.h` header file.
The src files are stored in `.local/src` and compiled in `.local/bin`.

To compile use `make clean install`

#### 5.1 Dynamic Window Manager (DWM) <a name="dwm"></a>

DWM is the tiling window manager installed by default in RMOS. Keybindings are provided in the `.local/src/dwm/config.h` file.

#### 5.2 DMenu <a name="dmenu"></a>

Dmenu allows for running scripts easily.

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

