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

configure_brighness()
{
    [ -n "`ls /sys/class/backlight/*/brightness`" ] || return

    title "Configure brightness authorisations"

    cat <<\EOF > /etc/init.d/brightness
#!/bin/sh
### BEGIN INIT INFO
# Provides:          brightness
# Required-Start:    mountkernfs $local_fs $remote_fs
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      
# Short-Description: Let anybody change the brightness
### END INIT INFO

case "$1" in
    "start")
        while [ -z "`ls /sys/class/backlight/*/brightness`" ]
        do
            sleep 5
        done
        chmod 666 `ls /sys/class/backlight/*/brightness`
        ;;
    "stop")
        ;;
    *)
        echo "Usage: `basename $0` (start | stop)"
        exit 1
        ;;
esac

EOF
    chmod 755 /etc/init.d/brightness
    insserv brightness
}

configure_brighness
