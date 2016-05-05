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

install_atom()
{
    $ATOM || return

    $I64 && ATOMDEB=https://atom-installer.github.com/v1.7.3/atom-amd64.deb

    [ -n "$ATOMDEB" ] || return

    if $FORCE || ! [ -x /usr/bin/atom ]
    then
        title "Install Atom"
        cd /tmp
        wget "$ATOMDEB"
        sudo dpkg -i $(basename "$ATOMDEB")
    fi
}

install_atom
