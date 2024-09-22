#!/usr/bin/env sh

. $XDG_CONFIG_HOME/scripts/utils.sh

KEYBOARD_MODEL="apple"
LAYOUTS=(
    "en-us:us:"
    "san-k:in:san-kagapa:$XDG_CONFIG_HOME/fontconfig/keymaps/devanagari.map"
    "kan-k:in:kan-kagapa:$XDG_CONFIG_HOME/fontconfig/keymaps/kannada.map"
)

function get_index_of() {
    CURRENT_LAYOUT=$1

    IDX=0
    for ITEM in "${LAYOUTS[@]}"; do
        IFS=':' read -ra PARTS <<< "${ITEM}"

        A=$(trim "$CURRENT_LAYOUT")
        B=$(trim "${PARTS[@]:1:2}")

        if [[ "${A//$'\r'/}" == "${B//$'\r'/}" ]]; then
            if [[ $IDX -eq $((${#LAYOUTS[@]}-1)) ]]; then
                echo -1
            else
                echo $IDX
                break
            fi
        fi 
        IDX=$((IDX+1))
    done

}

IFS=':' read -ra CURRENT_LAYOUT <<< "$(setxkbmap -query | grep "layout")"
CURRENT_LAYOUT=$(trim ${CURRENT_LAYOUT[1]})
IFS=':' read -ra CURRENT_VARIANT <<< "$(setxkbmap -query | grep "variant")"
CURRENT_VARIANT=$(trim ${CURRENT_VARIANT[1]})

CURRENT_IDX=$(get_index_of "${CURRENT_LAYOUT} ${CURRENT_VARIANT}")

IFS=':' read -ra NEXT_LAYOUT <<< "${LAYOUTS[$((CURRENT_IDX+1))]}"

NEXT_LAYOUT="${NEXT_LAYOUT[1]}"
NEXT_VARIANT="${NEXT_LAYOUT[2]}"
KEYMAP="${NEXT_LAYOUT[3]}"

setxkbmap -model $KEYBOARD_MODEL ${NEXT_LAYOUT} ${NEXT_VARIANT}
if [[ "$KEYMAP" != "" ]]; then
    xmodmap $KEYMAP
fi
MSG="Keyboard: ${NEXT_LAYOUT}"
if [[ "$NEXT_VARIANT" != "" ]]; then
    MSG="$MSG ($NEXT_VARIANT)"
fi

notify-send --urgency low "$MSG"

