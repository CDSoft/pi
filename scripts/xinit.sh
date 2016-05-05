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

configure_xinit()
{
    title "X initialisation (.xinitrc)"

#    cat <<\EOF > /home/$USERNAME/.Xmodmap
#keycode 91 = Delete period
#EOF
#    chown $USERNAME:$USERNAME /home/$USERNAME/.Xmodmap

    cat <<EOF > /home/$USERNAME/.xinitrc
xset -b # disable bell
#xset dpms 300 600 900
#xrdb -merge \$HOME/.Xresources

#dbus instance
#eval `dbus-launch --sh-syntax --exit-with-session`

setxkbmap -layout $KEYBOARD
#setxkbmap -option ctrl:nocaps
#xmodmap \$HOME/.Xmodmap
#xbindkeys

numlockx $( ( laptop-detect || $RPI ) && echo off || echo on )
#alsactl init &

# Notifications
#/usr/lib/notify-osd/notify-osd &
dunst -key y &

mkdir -p ~/.pw/
cp -f ~/secret.pwd ~/.pw/\$(date +%F-secret.pwd)

[ -x ~/bin/coffres.sh ] && ~/bin/coffres.sh &

$( [ -n "$XFLUX" ]  && echo "xflux $XFLUX &" )

$( $DROPBOX && echo "~/.dropbox-dist/dropboxd &" )
$( $MEGA    && echo "megasync > /tmp/megasync.log &" )
$( $HUBIC   && echo "( [ -x ~/hubic.login ] && ~/hubic.login; hubic start ) &" )

$( $BLUETOOTH && echo "blueman-applet &" )

exec ck-launch-session dbus-launch i3
EOF
    chown $USERNAME:$USERNAME /home/$USERNAME/.xinitrc

}

configure_xinit
