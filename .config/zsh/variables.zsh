#!/usr/bin/env zsh

BLUE="%F{#4287F5}"
TEAL="%F{#008080}"
ORANGE="%F{#DFA000}"
RESET="%k%f"

export PS1="${BLUE}%n${ORANGE}@${BLUE}%m${ORANGE}:${TEAL}%d ${ORANGE}\$${RESET} "
export HISTFILE="$XDG_STATE_HOME/zsh_history"
