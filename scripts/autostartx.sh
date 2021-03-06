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

configure_autostartx()
{
    $AUTOSTARTX || return

    title "X auto startup"

    cat <<\EOF >> /home/$USERNAME/.profile

# start X on tty1
if [ -z $DISPLAY ] && [ `tty` = "/dev/tty1" ]
then
    startx
fi
EOF
    perm ux /home/$USERNAME/.profile
}

configure_autostartx
