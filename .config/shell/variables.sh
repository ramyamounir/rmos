#!/bin/env sh

# XDG variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/data"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_STATE_HOME="$HOME/.local/logs"
export XDG_RUNTIME_DIR="/run/user/$(id -u $USER)"

# variables
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
export FZF_DEFAULT_COMMAND="find . -type f -print -o -type l -print 2> /dev/null | sed s/^..//"
export GTK2_RC_FILES="/usr/share/themes/Arc-dark/gtk-2.0/gtkrc"
export GTK_THEME="Arc:dark"
export HISTSIZE=50000
export HISTFILESIZE=50000
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export PATH=$(echo $(cat << EOV
    $HOME/.local/bin:
    $XDG_CONFIG_HOME/scripts:
    $XDG_CONFIG_HOME/scripts/dwmblocks:
    $XDG_CONFIG_HOME/scripts/dmenu:
    $XDG_CONFIG_HOME/scripts/tbp:
    $PATH
EOV
) | tr -d ' ')

export SAVEHIST=50000
export TERM="xterm-256color"
export TERMINAL="alacritty"
export VISUAL=nvim
export EDITOR="$VISUAL"
export SUDO_EDITOR="$VISUAL"
export BROWSER="firefox"

# configurations
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/bat.conf"
export BDOTDIR="$XDG_CONFIG_HOME/bash"
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/gitconfig"
export GIT_EDITOR=$EDITOR
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export NPM_CONFIG_PREFIX="$XDG_CONFIG_HOME/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
export VIMINIT="let \$MYVIMRC='$XDG_CONFIG_HOME/nvim/init.lua' | source \$MYVIMRC"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export XCOMPOSEFILE="$XDG_CONFIG_HOME/x11/XCompose"
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZIM_CONFIG_FILE="$ZDOTDIR/zimrc"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# cache
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship/cache"

# data
export AWS_SHARED_CREDENTIALS_FILE="$XDG_DATA_HOME/aws/credentials"
export GOPATH="$XDG_DATA_HOME/go"
export IPYTHONDIR="$XDG_DATA_HOME/ipython"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"
export MOZILLA_HOME="$XDG_DATA_HOME/mozilla"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export UNISON="$XDG_DATA_HOME/unison"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export ZIM_HOME="$XDG_DATA_HOME/zim"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

# logs
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export ZSH_COMPDUMP="$XDG_STATE_HOME/zcompdump"

