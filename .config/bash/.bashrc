#!/usr/bin/env bash

# if non-interactive session, re-source variables (for rsync, etc.)
! [ -t 0 ] && source ~/.config/shell/variables.sh

source $XDG_CONFIG_HOME/shell/rc.sh

theme_shell "bash"; # theme shell before aliases
source $XDG_CONFIG_HOME/bash/aliases.bash

[ -t 0 ] && clear;
