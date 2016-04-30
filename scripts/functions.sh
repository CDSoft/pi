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

title()
{
    echo -e "\e[91m########################################\e[0m"
    echo -e "\e[91m# $*\e[0m"
    echo -e "\e[91m########################################\e[0m"
}

log()
{
    echo -e "\e[91m# $*\e[0m"
}

error()
{
    log "Post Install error: $*"
    exit 1
}

logrun()
{
    log $*
    $*
}

PIDIR=$(dirname $(readlink -f $0))

run_script()
{
    cd $PIDIR
    source scripts/$1.sh
}

perm()
{
    case "$1" in
        ux)     chmod -R +x $2
                chown -R $USERNAME:$USERNAME $2
                ;;
        *)      error "Invalid permission (perm $*)"
                ;;
    esac
}

mkcd()
{
    mkdir -p $1
    chown $USERNAME:$USERNAME $1
    cd $1
}


