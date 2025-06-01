#!/bin/env sh
# source shell_tools in both the shell's rc and profile files

################################################################################
#                               SSH and keyrings                               #
################################################################################

# GPG agent configuration
function gpg_ssh_agent() {
    if ! [ -z "$PS1" ]; then

        if command -v ssh-agent > /dev/null 2>&1; then
            export GPG_TTY=$(tty)
            eval "$(ssh-agent)" > /dev/null
        fi

        if command -v gpgconf > /dev/null 2>&1; then
            if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
                export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
            fi
        fi
        
        if command -v gpg-connect-agent > /dev/null 2>&1; then
            gpg-connect-agent --quiet updatestartuptty /bye
        fi
    fi
}


# SSH and GPG/GNOME agent cleanup
function shell_cleanup {
    if ! [ -z "$PS1" ]; then
        if ! [ -z $SSH_AGENT_PID ]; then
            eval `ssh-agent -k` &> /dev/null
        fi
        if ! [ -z $DBUS_SESSION_BUS_PID ]; then
            kill -9 $DBUS_SESSION_BUS_PID &> /dev/null
        fi
    fi
}

################################################################################
#                       System-related utility tools                           #
################################################################################

function switch_to_zsh_if_desired() {
    if ! [ -z $USE_ZSH_AT ]; then
        SHELL=$USE_ZSH_AT
        exec $SHELL -l
    fi
}

function start_X_if_available() {
    # start the X server when logging in through the true terminal (TTY)
    if [[ $SHLVL -eq 1 ]] && [[ "`tty`" == "/dev/tty"* ]]; then
        clear;
        startx > /dev/null 2>&1
    fi
}

################################################################################
#                               Shell theming                                  #
################################################################################

# theme OhMy[zsh|bash]
function theme_oh_my() {
    WORKING_SHELL=$1

    completions=(git composer ssh)
    plugins=(git)

    if [[ "$WORKING_SHELL" =~ "zsh" ]]; then
        SOURCEABLES=(
            $HOME/.local/src/zsh-autocomplete/zsh-autocomplete.plugin.zsh
            $HOME/.local/src/zsh-autosuggestions/zsh-autosuggestions.zsh
        )

        for SOURCEABLE in ${SOURCEABLES[@]}; do
            [ -f $SOURCEABLE ] && source $SOURCEABLE
        done

        zstyle ':omz:*' aliases no
        plugins+=(tmux)
        ZSH_THEME="agnoster"
        export OH_MY_ZSH="$XDG_DATA_HOME/oh-my-zsh"
        [ -f $OH_MY_ZSH/oh-my-zsh.sh ] && source $OH_MY_ZSH/oh-my-zsh.sh
    elif [[ "$WORKING_SHELL" =~ "bash" ]]; then
        plugins+=()
        OSH_THEME="agnoster"
        export OSH="$XDG_DATA_HOME/oh-my-bash"
        [ -f $OSH/oh-my-bash.sh ] && source $OSH/oh-my-bash.sh
    fi

    if [[ "$WORKING_SHELL" =~ "zsh" ]]; then
        prompt_dir() {
          CURRENT_FG='black'
          prompt_segment cyan $CURRENT_FG '%~'
        }

        prompt_context() {
            prompt_segment black yellow "%(!.%{%F{yellow}%}.)%n@%m"
        }
    elif [[ "$WORKING_SHELL" =~ "bash" ]]; then
        prompt_dir() {
          CURRENT_FG='black'
          prompt_segment cyan $CURRENT_FG '~'
        }

        prompt_context() {
            prompt_segment black yellow "\u@\h"
        }
    fi

    build_prompt() {
        RETVAL=$?
        prompt_context
        prompt_virtualenv
        prompt_dir
        prompt_git
        prompt_end
    }

    if [[ "$WORKING_SHELL" =~ "zsh" ]]; then
        bindkey "\eOA" up-line-or-history
        bindkey "\eOB" down-line-or-history
        bindkey "\eOC" forward-char
        bindkey "\eOD" backward-char
    fi

    unset WORKING_SHELL
}

# theme zsh with Zim
function theme_zim() {
    init-zim;
    source $ZIM_HOME/init.zsh
}

# custom autocompletes
function register_custom_autocompletes() {
    if ! command -v complete 2>&1 > /dev/null; then
        return
    fi
    complete -W "$(rmos-help _autocomplete)" rmos-help
}

# theme shell
function theme_shell() {
    WORKING_SHELL=$1

    if [[ "$WORKING_SHELL" = "zsh" ]]; then
        theme_zim
        command -v starship 2>&1 > /dev/null && eval "$(starship init zsh)"
        command -v zoxide 2>&1 > /dev/null && eval "$(zoxide init zsh)"

    elif [[ "$WORKING_SHELL" = "bash" ]]; then
        theme_oh_my $WORKING_SHELL
    fi

    unset WORKING_SHELL

    register_custom_autocompletes
}
