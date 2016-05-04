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

configure_autofs()
{
    rm -f /etc/auto.master /etc/auto.nfs
    [ -n $NAS_MOUNTPOINT ] || return

    title "autofs configuration"

    cat <<EOF > /etc/auto.master
+auto.master
$NAS_MOUNTPOINT    /etc/auto.nfs   --ghost,--timeout=60
EOF
        cat <<EOF > /etc/auto.nfs
Archives    -fstype=nfs,rw,intr     nas:/volume1/Archives
backup      -fstype=nfs,rw,intr     nas:/volume1/backup
Nuage       -fstype=nfs,rw,intr     nas:/volume1/Nuage
perso       -fstype=nfs,rw,intr     nas:/volume1/perso
EOF
    service autofs restart
}

configure_autofs
