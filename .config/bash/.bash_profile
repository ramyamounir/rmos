#!/usr/bin/env bash

source $HOME/.config/shell/profile.sh
source $XDG_CONFIG_HOME/bash/variables.bash

# if zsh path is availabe, switch to zsh
switch_to_zsh_if_desired;

# if no ZSH, start X from bash
start_X_if_available;

clear;
