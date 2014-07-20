# FreeBSD stuff
#
# Setting TERM is normally done through /etc/ttys.  Do only override
# if you're sure that you'll never log in via telnet or xterm or a
# serial line.
# Use cons25l1 for iso-* fonts
# TERM=cons25;  export TERM

# set ENV to a file invoked each time sh is started for interactive use.
export ENV=$HOME/.shrc
export BLOCKSIZE=K

if [ -x /usr/games/fortune ] ; then /usr/games/fortune freebsd-tips ; fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && source "$file"
done
unset file

source ~/dotfiles/git-completion.bash
source ~/dotfiles/wcshow-completion.bash

if [[ -z `git config --global user.name` ]]; then
    echo -n "Please, enter user name for git: "
    read GIT_AUTHOR_NAME
    git config --global user.name "$GIT_AUTHOR_NAME"
fi

if [[ -z `git config --global user.email` ]]; then
    echo -n "Please, enter email name for git: "
    read GIT_AUTHOR_EMAIL
    git config --global user.email "$GIT_AUTHOR_EMAIL"
fi

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

# Create a new directory and enter it
function d() {
    mkdir -p "$@" && cd "$@"
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* *
    fi
}

_expand()
{
    return 0;
}

# Save ssh agent socket for using in tmux sessions
if [[ $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != $HOME/.ssh/ssh_auth_sock ]]
then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi

# # command prompt
# case $TERM in
#     screen*)
#         SCREENTITLE='\[\ek\e\\\]\[\ek\W\e\\\]'
#         ;;
#     *)
#         SCREENTITLE=''
#         ;;
# esac
# export PS1="${SCREENTITLE}[\u@\h \W]\$ "


# подмаунтить jail
# используется http://osxfuse.github.com/
jailmount()
{
    JAIL=${1:-"leon42.yandex.ru"}
    echo -e "\033[33m===> MOUNT JAIL: \033[31m$JAIL \033[0m"
    mkdir -p /mount/$JAIL
    jailunmount $JAIL
    sshfs $USER@$JAIL:/ /mount/$JAIL -oauto_cache,reconnect,volname=$1
}

# размаунтить джейл
jailunmount()
{
    JAIL=${1:-"boogie4.yandex.ru"}
    umount /mount/$1 >/dev/null
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

# Tmux session alias for pair-programming
# Syntax:
#    Server:
#        tm-pair <feature>
#    Client:
#        tm-pair <user> <feature>
function tm-pair
{
    if [ ${2} ]; then
        tmux -2 -S /tmp/tm-${1} attach -t ${2}
    else
        tmux -2 -S /tmp/tm-`whoami` new -s ${1}
    fi
}
