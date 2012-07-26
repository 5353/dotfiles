#!sh

test "$DEBUG" && echo "++ profile [arg0=$0]"

# environ

. ~/code/dotfiles/environ

# login

case $0 in -*)
    echo `uptime`
    ;;
esac

# misc

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -f ~/code/dotfiles/profile-$HOSTNAME ]; then
    . ~/code/dotfiles/profile-$HOSTNAME
elif [ -f ~/.profile-$HOSTNAME ]; then
    . ~/.profile-$HOSTNAME
fi

true
