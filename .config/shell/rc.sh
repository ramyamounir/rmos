#!/bin/env sh

source $XDG_CONFIG_HOME/shell/utils.sh
source $XDG_CONFIG_HOME/shell/aliases.sh

gpg_ssh_agent;

# kill the SSH and GPG/GNOME agents upon exit
trap shell_cleanup EXIT

[ -f $XDG_DATA_HOME/.rc ] && source $XDG_DATA_HOME/.rc
