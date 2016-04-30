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

configure_autologin()
{
    # Auto login (http://www.debian-fr.org/autostartx-apres-autologin-t25337.html)
    # http://forums.debian.net/viewtopic.php?t=29333
    # http://www.raspberrypi.org/forums/viewtopic.php?f=26&t=44801
            #-e "s#^1:2345:.*#1:2345:respawn:/bin/login -f $USERNAME tty1 </dev/tty1 >/dev/tty1 2>\&1#" \
            #-e "s#^1:2345:.*#1:2345:respawn:/sbin/getty --autologin $USERNAME --noclear 38400 tty1#" \
    title "Autologin configuration"
    if $AUTOLOGIN
    then
        log "enable autologin"
        if [ -e /etc/inittab ]
        then
            sed -i \
                -e "s#^1:2345:.*#1:2345:respawn:/bin/login -f $USERNAME tty1 </dev/tty1 >/dev/tty1 2>\&1#" \
                -e "s#^2:23:.*#2:23:respawn:/sbin/getty 38400 tty2#" \
                -e "s#^3:23:.*#3:23:respawn:/sbin/getty 38400 tty3#" \
                /etc/inittab
        fi
        if [ -x /bin/systemd ]
        then
            # systemd
            mkdir -p /etc/systemd/system/getty@tty1.service.d
            cat <<EOF > /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear %I 38400
linux
EOF
        fi
    else
        log "disable autologin"
        if [ -e /etc/inittab ]
        then
            sed -i \
                -e "s#^1:2345:.*#1:2345:respawn:/sbin/getty 38400 tty1#" \
                -e "s#^2:23:.*#2:23:respawn:/sbin/getty 38400 tty2#" \
                -e "s#^3:23:.*#3:23:respawn:/sbin/getty 38400 tty3#" \
                /etc/inittab
        fi
        if [ -x /bin/systemd ]
        then
            # systemd
            rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf 2>/dev/null
            rmdir /etc/systemd/system/getty@tty1.service.d/ 2>/dev/null
        fi
    fi
}

configure_autologin
