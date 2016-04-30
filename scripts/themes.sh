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

configure_themes()
{
    title "GTK theme"

    cat <<EOF > /home/$USERNAME/.gtkrc-2.0
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
include "/home/$USERNAME/.gtkrc-2.0.mine"
EOF
    chown $USERNAME:$USERNAME /home/$USERNAME/.gtkrc-2.0

    cat <<EOF > /home/$USERNAME/.gtkrc-2.0.mine
gtk-toolbar-style = GTK_TOOLBAR_ICONS
gtk-xft-antialias = 1
gtk-xft-hintstyle = "slight"
gtk-xft-hinting = 1
gtk-xft-rgba = "rgb"
gtk-xft-dpi = 96
gtk-can-change-accels = 1
EOF
    chown $USERNAME:$USERNAME /home/$USERNAME/.gtkrc-2.0.mine

    if [ -d /home/$USERNAME/.config/gtk-3.0 ]
    then
        cat <<EOF > /home/$USERNAME/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name = Clearlooks
gtk-xft-antialias = 1
gtk-xft-hintstyle = "slight"
gtk-xft-hinting = 1
gtk-xft-rgba = "rgb"
gtk-xft-dpi = 96
gtk-can-change-accels = 1
gtk-toolbar-style = GTK_TOOLBAR_ICONS
EOF
        chown $USERNAME:$USERNAME /home/$USERNAME/.config/gtk-3.0/settings.ini
    fi
}

configure_themes
