#!/bin/env sh

source $HOME/.config/shell/variables.sh

# if non-interactive session, exit
! [ -t 0 ] && exit 0

source $XDG_CONFIG_HOME/shell/utils.sh
source $XDG_CONFIG_HOME/shell/aliases.sh

# if exists, source $$XDG_DATA_HOME/.env
[ -f $XDG_DATA_HOME/.env ] && source $XDG_DATA_HOME/.env
