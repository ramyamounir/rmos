#!/usr/bin/env zsh

# if non-interactive session, re-source variables (for rsync, etc.)
! [ -t 0 ] && source ~/.config/shell/variables.sh

source $XDG_CONFIG_HOME/shell/rc.sh

source $XDG_CONFIG_HOME/zsh/aliases.zsh

theme_shell "zsh";

[ -t 0 ] && clear;
