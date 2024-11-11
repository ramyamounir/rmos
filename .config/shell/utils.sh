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
    # settings corresponding to the packages in $ZIM_CONFIG_FILE
    zstyle ':zim:input' double-dot-expand yes
    zstyle ':zim:prompt-pwd:tail' length 10
    zstyle ':autocomplete:history-search-backward:*' list-lines 16
    zstyle ':autocompletion:*' expand 'no'
    zstyle ':zim:completion' dumpfile ${XDG_DATA_HOME}/zsh/.zcompdump
    zstyle ':completion::complete:*' cache-path ${XDG_CACHE_HOME}/zsh/zcompcache
    zstyle ':completion:*' squeeze-slashes true
    zstyle ':completion:*' complete-options true

    init-zim;
    source $ZIM_HOME/init.zsh

    zstyle ':zim:prompt-pwd:fish-style' dir-length 0

    function _prompt_eriner_status() {
        RESET="%k%f"
        YELLOW="%F{yellow}"
        YELLOW_BG="%K{yellow}"
        GREY_BG="%K{#272E33}"
        GREY="%F{#272E33}"
        BLUE_BG="%K{cyan}"

        # item 1: shell depth
        NUMBERS=("󰲠" "󰲢" "󰲤" "󰲦" "󰲨" "󰲪" "󰲬" "󰲮" "󰲰" "󰿬" "")
        SHELL_DEPTH=${SHLVL:-0}
        [[ $SHELL_DEPTH -gt 10 ]] && SHELL_DEPTH=11
        SHELL_DEPTH="${GREY_BG}${YELLOW}▎${NUMBERS[$SHELL_DEPTH]}"

        # item 2: conda environment
        CONDA_ENV=$(! [[ -n $CONDA_PREFIX ]] && echo "" || basename $CONDA_PREFIX)
        CONDA_ENV=$([[ -z $CONDA_ENV ]] && echo "" || echo " ${YELLOW_BG}${GREY}${YELLOW_BG}${GREY}  $([[ "$CONDA_ENV" == "anaconda3" ]] && echo "" || echo "$CONDA_ENV ")"${GREY_BG}${YELLOW})

        echo -en "${CONDA_ENV}${GREY_BG}${YELLOW} %n@%m ${BLUE_BG}${GREY}${RESET}"
    }
    PS1='$(_prompt_eriner_main)'
}

# custom autocompletes
function register_custom_autocompletes() {
    if ! command -v complete 2>&1 > /dev/null; then
        return
    fi
    complete -W "$(rmos-help _autocomplete)" rmos-help
}

function custom_keybindings() {
    # navigation shortcuts
    bindkey "^[[1;5D" backward-word         # Control + left arrow: navigate to the beginning to the word
    bindkey "^[[1;5C" forward-word          # Control + right arrow: navigate to the end of the word
    bindkey "^H" backward-kill-word         # Control + backspace: delete the word before
    bindkey "^[[3;5~" kill-word             # Control + delete: delete the word ahead
    bindkey "^[[1;6D" beginning-of-line     # Control + Shift + left arrow: go to the beginning of the line
    bindkey "^[[1;6C" end-of-line           # Control + Shift + right arrow: go to the end of the line

    delete_from_cursor_to_end() {
        zle kill-line
    }
    zle -N delete_from_cursor_to_end
    bindkey '^[[3;6~' delete_from_cursor_to_end # Control + shift + delete: delete from cursor to the end of the line

    # plugin shortcuts
    if bindkey -l | grep menuselect 2>&1 > /dev/null; then
        bindkey '^N' menu-select                # Control + N: next selection
        bindkey              '^I'        menu-select
        bindkey "$terminfo[kcbt]" reverse-menu-select
        bindkey -M menuselect              '^I'         menu-complete
        bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
    else
        bindkey '^N' menu-complete            # Control + N: next selection
    fi
    bindkey '^ ' autosuggest-accept
}

# theme shell
function theme_shell() {
    WORKING_SHELL=$1

    if [[ "$WORKING_SHELL" = "zsh" ]]; then
        if [[ -z $SHELL_PLUGIN_MANAGER ]]; then
            SHELL_PLUGIN_MANAGER="zim"
        fi

        case $SHELL_PLUGIN_MANAGER in
            "zim")
                theme_zim
                command -v zoxide 2>&1 > /dev/null && eval "$(zoxide init zsh)"
                ;;
            "ohmy")
                theme_oh_my $WORKING_SHELL
                command -v zoxide 2>&1 > /dev/null && eval "$(zoxide init bash)"
                ;;
        esac

        custom_keybindings
    elif [[ "$WORKING_SHELL" = "bash" ]]; then
        theme_oh_my $WORKING_SHELL
    fi

    unset WORKING_SHELL

    register_custom_autocompletes
}
