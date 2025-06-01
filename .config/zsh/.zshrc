#!/usr/bin/env zsh

# if non-interactive session, re-source variables (for rsync, etc.)
! [ -t 0 ] && source ~/.config/shell/variables.sh

source $XDG_CONFIG_HOME/zsh/configs.zsh

source $XDG_CONFIG_HOME/shell/rc.sh

source $XDG_CONFIG_HOME/zsh/aliases.zsh

if [ -t 0 ]; then
    theme_shell "zsh";
    clear;
fi

