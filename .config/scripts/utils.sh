#!/usr/bin/env sh

padclip() {
    # Given a string (as the first argument) and a length (as the second), this
    # function pads the string with spaces to match the length (if the string is
    # shorter than the length) or clips it to match the length (if the string is
    # longer than the length). Argument 3: right justify if 1, left justify
    # otherwise; default: left justify.

    local string="$1"
    local length=$2
    local right=${3:-0}

    if (( ${#string} < $((length)) )); then
        if [[ $right -eq 0 ]]; then
            printf "%-${length}s" "$string"
        else
            printf "%${length}s" "$string"
        fi
    else
        if [[ $right -eq 0 ]]; then
            printf "%.$((length-3))s..." "$string"
        else
            printf "...%.$((length-3))s" "$string"
        fi
    fi
}

trim() {
    # This function removes the leading and trailing spaces from a given input
    # string.

    echo -e "$@" | sed 's/^[ \t]*//;s/[ \t]*$//'
}
