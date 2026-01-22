#!/bin/env sh

source $HOME/.config/shell/variables.sh

# if non-interactive session, skip interactive setup
! [ -t 0 ] && return 0

source $XDG_CONFIG_HOME/shell/utils.sh
source $XDG_CONFIG_HOME/shell/aliases.sh

# if exists, source $$XDG_DATA_HOME/.env
[ -f $XDG_DATA_HOME/.env ] && source $XDG_DATA_HOME/.env
