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

install_haskell()
{
    $HASKELL || return

    $I64 && HASKELL_PLATFORM=https://haskell.org/platform/download/8.0.1/haskell-platform-8.0.1-unknown-posix--minimal-x86_64.tar.gz
    $I32 && HASKELL_PLATFORM=https://haskell.org/platform/download/8.0.1/haskell-platform-8.0.1-unknown-posix--minimal-i386.tar.gz

    [ -n "$HASKELL_PLATFORM" ] || return

    title "Install Haskell"
    if $FORCE || ! [ -x /usr/local/bin/ghc ]
    then
        log "Install Haskell Platform"
        mkcd /home/$USERNAME/.haskell/haskell-platform
        wget -c $HASKELL_PLATFORM
        tar xf `basename $HASKELL_PLATFORM`
        ./install-haskell-platform.sh
    fi

    log "Update PATH"
    mkdir -p /home/$USERNAME/.profiled
    cat <<\EOF > /home/$USERNAME/.profiled/haskell.sh
# Haskell
export PATH=~/.cabal/bin:$PATH
for mod in pandoc ghcmod shellcheck
do
    export PATH=~/.haskell/$mod/.cabal-sandbox/bin:$PATH
done
EOF
    perm ux /home/$USERNAME/.profiled

    log "Install Haskell libraries"
    cd /home/$USERNAME
    sudo -u $USERNAME cabal update
    sudo -u $USERNAME cabal install \
        split \
        missingh \
        readline \
        network-multicast \
        base-unicode-symbols \
        utf8-string \
        interpolatedstring-perl6 shakespeare-text here \
        glut

    log "Install Pandoc with cabal"
    mkcd /home/$USERNAME/.haskell/pandoc
    sudo -u $USERNAME cabal sandbox init
    sudo -u $USERNAME cabal update
    sudo -u $USERNAME cabal install pandoc

    log "Install ghc-mod"
    mkcd /home/$USERNAME/.haskell/ghcmod
    sudo -u $USERNAME cabal sandbox init
    sudo -u $USERNAME cabal update
    sudo -u $USERNAME cabal install hlint stylish-haskell ghc-mod

    log "Install shellcheck"
    mkcd /home/$USERNAME/.haskell/shellcheck
    sudo -u $USERNAME cabal sandbox init
    sudo -u $USERNAME cabal update
    sudo -u $USERNAME cabal install shellcheck
}

install_haskell
