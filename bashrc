#!bash

[[ $DEBUG ]] && echo "++ bashrc [self=$0 prefix=$PREFIX]"

have() { command -v "$1" >&/dev/null; }

### Environment

[[ $PREFIX ]] || . ~/code/dotfiles/environ

export SUDO_PROMPT=$(printf 'sudo: Password for %%u@\e[30;43m%%h\e[m: ')

### Interactive options

[[ $- != *i* ]] && return

[[ $DEBUG ]] && echo ".. bashrc [interactive=$-]"

shopt -os physical              # resolve symlinks when 'cd'ing
shopt -s checkjobs 2> /dev/null # print jobs status on exit
shopt -s checkwinsize           # update $ROWS/$COLUMNS after command
shopt -s no_empty_cmd_completion

shopt -s cmdhist                # store multi-line commands as single history entry
shopt -s histappend             # append to $HISTFILE on exit
shopt -s histreedit             # allow re-editing failed history subst

HISTFILE=~/.bash_history
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth

### Completion

HOSTFILE=~/.hosts

complete -A directory cd

### Terminal capabilities

case $TERM in
    xterm)
        havecolor=8
        if [[ -z $COLORTERM ]] && [[ -f /proc/$PPID/cmdline ]]; then
            read -r -d '' comm </proc/$PPID/cmdline
            comm=${comm##*/}
            case $comm in
                gnome-terminal|konsole|xterm|yakuake)
                    COLORTERM=$comm
                    ;;
                kdeinit4:*konsole*)
                    COLORTERM=konsole
                    ;;
            esac
            unset comm
        fi
        if [[ $COLORTERM ]]; then
            TERM="$TERM-256color"
            havecolor=256
        fi
        ;;
    vt100|vt220|vt320)
        havecolor=8
        ;;
    '')
        havecolor=0
        ;;
    *)
        havecolor=$(have tput && tput colors 2>/dev/null)
        ;;
esac

### Prompt and window title

. ~/code/dotfiles/bashrc.prompt

### Aliases

. ~/code/dotfiles/bashrc.aliases

### More environment

export GREP_OPTIONS='--color=auto'

if [[ -f ~/code/dotfiles/bashrc-$HOSTNAME ]]; then
    . ~/code/dotfiles/bashrc-$HOSTNAME
elif [[ -f ~/.bashrc-$HOSTNAME ]]; then
    . ~/.bashrc-$HOSTNAME
fi

true
