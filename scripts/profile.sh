#!/bin/bash

########################################################################
# Post Install (pi): lightweigth Debian « distribution »
#
# Copyright (C) 2015, 2016 Christophe Delord
# http://www.cdsoft.fr/pi
#
# This file is part of Post Install (PI)
#
# PI is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# PI is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with PI.  If not, see <http://www.gnu.org/licenses/>.
########################################################################

title "Shell configuration"

configure_profile()
{
    log "Default .profile"

    cat <<\EOF > /home/$USERNAME/.profile
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export LC_NUMERIC=C

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/local/bin" ] ; then
    PATH="$HOME/local/bin:$PATH"
fi
export PATH=$PATH:.

if [ -d "$HOME/.profiled ]
then
    for profile in $HOME/.profiled/*
    do
        source $profile
    done
fi
EOF

    chown $USERNAME:$USERNAME /home/$USERNAME/.profile
}

configure_shell()
{
    log "Shell configuration"

    cat <<\EOF > /home/$USERNAME/.bash_aliases
alias ll='ls -l'
alias la='ll -A'
alias l='ls -CF'
alias lt='ll -rt'

alias vi=gvim
alias v=gview
alias more=less
alias cmore='vim -u /usr/share/vim/vim74/macros/less.vim'
alias df='df -h'
alias du='du -h'

alias ocaml="rlwrap ocaml"

if [ $VIM ]
then

export PS1='[vim shell] \u@\h \w
$ '

else

# Nice colored prompt
export PS1='\[\033]0;\w\007
\033[34m\]\u@\h \[\033[31m\w\033[0m\]
$ '

# Prompt with the colored return code of the previous command
#export PS1="\033[1;30m==> \$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[1;32m\];)\"; else echo \"\[\033[1;31m\];(\"; fi)\[\033[00m\] $PS1"
export PS1="\033[1;30m\$(r=\$?; printf \"%\$((\$(tput cols)-10))s\" | tr ' ' '-'; printf \"> %3s \" \$r; if [[ \$r == 0 ]]; then echo \"\[\033[1;32m\];)\"; else echo \"\[\033[1;31m\];(\"; fi)\[\033[00m\] $PS1"

fi

export EDITOR=gvim
export TERMINAL=urxvt
export BROWSER=chromium
EOF
    chown $USERNAME:$USERNAME /home/$USERNAME/.bash_aliases

}

configure_profile
configure_shell
