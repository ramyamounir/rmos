#!/usr/bin/env bash

BLUE="\[\e[38;2;66;135;245m\]"
TEAL="\[\e[38;2;0;128;128m\]"
ORANGE="\[\e[38;2;199;136;0m\]"
RESET="\[\e[0m\]"

export PS1="${BLUE}\u${ORANGE}@${BLUE}\h${ORANGE}:${TEAL}\w${ORANGE} \$${RESET} "
export HISTFILE="$XDG_STATE_HOME/bash_history"
