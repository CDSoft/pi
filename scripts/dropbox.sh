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

install_dropbox()
{
    $DROPBOX || return
    $FORCE || ! [ -x /home/$USERNAME/.dropbox-dist/dropboxd ] || return

    title "Install Dropbox"
    (
        cd /home/$USERNAME
        $X86_64 && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
        $X86    && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -
    )
}

install_dropbox
