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

title "System configuration"

SWAPPINESS=10

config_sudoers()
{
    log "sudoers configuration"

    cat <<EOF > /etc/sudoers.d/sudogroup
# Created by Post Install

%sudo    ALL=(root) ALL

ALL   ALL=NOPASSWD:/sbin/shutdown
ALL   ALL=NOPASSWD:/usr/sbin/s2ram
ALL   ALL=NOPASSWD:/usr/sbin/s2disk
ALL   ALL=NOPASSWD:/usr/sbin/s2both
ALL   ALL=NOPASSWD:/usr/sbin/pm-hibernate
ALL   ALL=NOPASSWD:/usr/sbin/pm-is-supported
ALL   ALL=NOPASSWD:/usr/sbin/pm-powersave
ALL   ALL=NOPASSWD:/usr/sbin/pm-suspend
ALL   ALL=NOPASSWD:/usr/sbin/pm-suspend-hybrid
ALL   ALL=NOPASSWD:/usr/sbin/iftop
ALL   ALL=NOPASSWD:/bin/mount
ALL   ALL=NOPASSWD:/bin/umount
ALL   ALL=NOPASSWD:/sbin/ifup
ALL   ALL=NOPASSWD:/sbin/ifdown
ALL   ALL=NOPASSWD:/sbin/dhclient
EOF
    chmod 440 /etc/sudoers.d/sudogroup
    addgroup $USERNAME sudo
    addgroup $USERNAME kvm
}

config_swappiness()
{
    log "swappiness"
    if grep -q "vm\.swappiness" /etc/sysctl.conf
    then
        sed -i "s/.*vm\.swappiness.*/vm.swappiness=$SWAPPINESS/" /etc/sysctl.conf
    else
        echo "vm.swappiness=$SWAPPINESS" >> /etc/sysctl.conf
    fi
    /sbin/sysctl -p
}

config_system_beep()
{
    log "Disable system beep"
    modprobe -r pcspkr snd_pcsp
    cat <<EOF > /etc/modprobe.d/nobeep.conf
blacklist pcspkr
blacklist snd_pcsp
EOF
    sed -i 's/# set bell-style none/set bell-style none/' /etc/inputrc
}

config_mtp()
{
    log "MTP setup"
    adduser $USERNAME plugdev
    usermod -a -G plugdev $USERNAME    
    mkdir -p /media/$USERNAME
    chown $USERNAME:$USERNAME /media/$USERNAME
}

config_fuse()
{
    log "Fuse setup"
    groupadd fuse
    adduser $USERNAME fuse
}

config_sudoers
config_swappiness
config_system_beep
config_mtp
config_fuse
