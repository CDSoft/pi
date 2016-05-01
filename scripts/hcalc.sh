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

configure_hcalc()
{
    if $I64
    then
        title "Install hcalc"
        /home/$USERNAME/bin/hcalc version 2>/dev/null > /tmp/hcalc.installed
        wget -O /tmp/hcalc http://cdsoft.fr/hcalc/hcalc 2>/dev/null
        chmod +x /tmp/hcalc
        /tmp/hcalc version 2>/dev/null > /tmp/hcalc.latest
        if ! diff /tmp/hcalc.installed /tmp/hcalc.latest
        then
            cp -p /tmp/hcalc /home/$USERNAME/bin/hcalc
            perm ux /home/$USERNAME/bin/hcalc
        fi
    fi

}

configure_hcalc
