#!/bin/env sh

### NAVIGATION & HELPER ###
alias lsl='ls -lh'
alias c='clear'
alias lsa='ls -alh'
alias ipe='curl ipinfo.io/ip;echo ""'
alias ipi="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias psg='ps -eaf | grep -P'
alias cursor='find-cursor --repeat 0 --follow --distance 1 --line-width 16 --size 16 --color red'
alias pen='sudo ~/Downloads/Linux_Pentablet_V1.2.14.1/Pentablet_Driver.sh'
alias MI='mediainfo --Inform="Video;Width=%Width%, Height=%Height%, Duration=%Duration%, FPS=%FrameRate%, NumFrames=%FrameCount%"'
alias open='xdg-open'
alias svim='sudoedit'
### NAVIGATION & HELPER ###

### CONDA ###
alias aa='a torch'
alias aaa='a ramy_torch'
alias d='conda deactivate'
a() { conda deactivate; conda activate $1; }
alias tb='tensorboard --samples_per_plugin="images=0" --logdir'
### CONDA ###

### GP ###
alias gpc='nmcli connection up usf --ask'
alias gpd='nmcli connection down usf'

### NGROK ###
alias ngbot='aaa; python ~/apps/ngrok-bot.py; d'
alias nga='~/apps/ngrok start -all'
alias ng='~/apps/ngrok start'
alias ngp='~/apps/ngrok http'

### SSH ###
alias deepv='ssh deepv'
alias beast='ssh beast'
alias puppy='ssh puppy'
alias gaivi='ssh gaivi'
alias hpg='ssh hpg'
alias seedbox='ssh seedbox'
alias margoz='ssh margoz'
alias rpi='ssh rpi'
alias lab='ssh lab'

### mounting ###
alias MSujal='sudo mount nec200a.ssh.sujal.tv:/storage/hdd/shared /data/D1/sujal --mkdir'
alias USujal='sudo umount /data/D1/sujal && rm -rf /data/D1/sujal'


alias rmos="git --git-dir $HOME/.rmos --work-tree $HOME"
# alias vpn-nord-connect="nordvpn connect"
# alias vpn-nord-disconnect="nordvpn disconnect"
# alias vpn-gp-connect="vpn-nord-disconnect; globalprotect connect"
# alias vpn-gp-disconnect="globalprotect disconnect"

# miscellaneous
function u1() {
    rmos pull;
    rmos add .;
    rmos status;

    if command -v pass 2>&1 > /dev/null; then
        pass git pull;
        pass git add .;
        pass git status;
    fi
}
function u2() {
    rmos push;
    if command -v pass 2>&1 > /dev/null; then
        pass git push;
    fi
    update ${AM_I_ADMIN:-0};
}

# alias u="u1; u2;"

# substitute for setting path variables to configuration and data directories
alias yarn="yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
alias wget="wget --hsts-file $XDG_CACHE_HOME/wget-hsts"

command -v tgpt > /dev/null 2>&1 && alias ask="tgpt -i"
command -v pulsemixer > /dev/null 2>&1 && alias mute="pulsemixer --mute" unmute="pulsemixer --unmute"
command -v startx > /dev/null 2>&1 && alias s="startx > /dev/null 2>&1"
command -v nvidia-smi > /dev/null 2>&1 && alias killgpu='nvidia-smi --query-compute-apps=pid --format=csv,noheader | xargs -I{} kill -9 {} -u `whoami`'

# better variants
command -v bat > /dev/null 2>&1 && alias catt="command bat"
command -v bpytop > /dev/null 2>&1 && alias htopp="bpytop"
command -v dua > /dev/null 2>&1 && alias duu="command dua"
command -v duf > /dev/null 2>&1 && alias df="command duf --hide special" duf="command df"
command -v nvim > /dev/null 2>&1 && alias vim="command nvim" vimdiff="command nvim -d" nvim="command vim"
command -v procs > /dev/null 2>&1 && alias pss="procs"

