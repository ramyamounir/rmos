#!/bin/env sh

source $XDG_CONFIG_HOME/shell/shell_tools.sh
source $XDG_CONFIG_HOME/shell/aliases.sh
source $XDG_CONFIG_HOME/shell/server_tools.sh

start_ssh_and_companion_agents;
disable_commands;

# kill the SSH and GPG/GNOME agents upon exit
trap shell_cleanup EXIT

[ -f $XDG_DATA_HOME/.rc ] && source $XDG_DATA_HOME/.rc
