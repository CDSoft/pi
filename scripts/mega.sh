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

install_mega()
{
    $MEGA || return

    $I64 && MEGADEB=https://mega.nz/linux/MEGAsync/Debian_8.0/amd64/megasync-Debian_8.0_amd64.deb
    $I32 && MEGADEB=https://mega.nz/linux/MEGAsync/Debian_8.0/i386/megasync-Debian_8.0_i386.deb

    [ -n "$MEGADEB" ] || return

    $FORCE || ! [ -x /usr/bin/megasync ] || return

    title "Install Mega"
    cd /tmp
    wget "$MEGADEB"
    dpkg -i $(basename "$MEGADEB")
}

install_mega
