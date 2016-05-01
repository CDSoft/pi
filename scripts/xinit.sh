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

numlockx on
#alsactl init &

# Notifications
#/usr/lib/notify-osd/notify-osd &
dunst -key y &

mkdir -p ~/.pw/
cp -f ~/secret.pwd ~/.pw/\$(date +%F-secret.pwd)

[ -x ~/bin/coffres.sh ] && ~/bin/coffres.sh &

xflux $XFLUX &

~/.dropbox-dist/dropboxd &
megasync > /tmp/megasync.log &
( [ -x ~/hubic.login ] && ~/hubic.login; hubic start ) &
EOF
    $BLUETOOTH && echo "blueman-applet &" >> /home/$USERNAME/.xinitrc
    echo "exec ck-launch-session dbus-launch i3"    >> /home/$USERNAME/.xinitrc

    [ -n "$XFLUX" ] || sed -i '/xflux/d' /home/$USERNAME/.xinitrc
    [ -n "$DROPBOX" ] || sed -i '/dropbox/d' /home/$USERNAME/.xinitrc
    [ -n "$MEGA" ] || sed -i '/megasync/d' /home/$USERNAME/.xinitrc
    [ -n "$HUBIC" ] || sed -i '/hubic/d' /home/$USERNAME/.xinitrc
    $LAPTOP && sed -i 's/numlockx on/numlockx off/' /home/$USERNAME/.xinitrc

    chown $USERNAME:$USERNAME /home/$USERNAME/.xinitrc

}

configure_xinit
