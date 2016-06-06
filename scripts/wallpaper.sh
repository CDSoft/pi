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

configure_wallpaper()
{
    title "Wallpaper"

    mkdir -p /home/$USERNAME/.i3/

    cat <<EOF > /home/$USERNAME/.i3/doc1.txt

===========================================================================
System
===========================================================================

Win+l               lock screen
Win+Pause           Suspend
Win+Delete          Shutdown/Reset/... menu
Alt+Ctrl+Delete     Shutdown/Reset/... menu
Win+i               Network interface chooser (eth0, wlan0 or none)

===========================================================================
i3 configuration
===========================================================================

Win+Shift+c         reload the configuration of i3
Win+Shift+r         restart i3
Win+Shift+e         exit i3

===========================================================================
Scratchpad
===========================================================================

Win+Shift+o         move the active window to the scratchpad
Win+o               show/hide the scratchpad

===========================================================================
Applications
===========================================================================

Win+Escape          start a program launcher (dmenu)
Win+Space           start a small and faster menu

Win+Return          terminal (in the current working directory)
Win+Ctrl+Return     Double Commander
Win+Alt+Return      File manager menu (mc, doublecmd, PCManFM)

Win+t               edit the TODO list
Win+n               notes
Win+p               password manager
Win+= or Win+c      Handy Calc

Win+w               Web browser (chromium)

Print               Capture the whole screen and start GIMP
Win+Print           Capture the active window and start GIMP

EOF
    $I64 || sed -i '/Handy Calc/d' /home/$USERNAME/.i3/doc1.txt
    cat <<EOF > /home/$USERNAME/.i3/doc2.txt

===========================================================================
Windows management
===========================================================================

Win+Mouse           drag floating windows
Win+q or Alt-F4     close the active window

Win+m               let the active window be full screen

Win+s               stacking layout
Win+z               tabbed layout
Win+e               toggle horizontal/vertical layout
Win+f               toggle floating layout

Win+Arrow Key       change the focus
Win+Shift+Arrow Key move the active window

Win+a               focus the parent container
Win+Shift+a         focus the child container
Win+h               open the next window to the right of the active window
Win+v               open the next window below the active window

Win+<               change focus between tiling / floating windows

Win+1..0            switch to workspace
Win+F1..F12         switch to workspace
Win+Shift+1..0      move container to workspace n
Win+Shift+F1..F12   move container to workspace n

Win+Tab or Alt+Tab  switch to the previously active workspace
Alt+Ctrl+Left/Right switch to the previous/next workspace

===========================================================================
Windows resize mode
===========================================================================

Win+r               activate the resize mode
Return/Escape       back to the normal mode
Arrow keys          resize the active window

EOF

    case $((SECONDS%2)) in
        0)  # Thanks to NipTech for this quote (http://inspire.niptech.com/post/25150617089/seuls-les-poissons-morts-nagent-dans-le-sens-du)
            case "$LANG" in
                fr*)    echo -e "« Seuls les poissons morts nagent dans le sens du courant. »    \n\n— Jean-Claude Biver, CEO Hublot    \n" ;;
                *)      echo -e "« Only dead fishes swim in the direction of the stream. »    \n\n— Jean-Claude Biver, CEO Hublot    \n" ;;
            esac ;;
        1)  # http://citations.webescence.com/citations/Thomas-Edison/pas-echoue-simplement-trouve-10000-solutions-qui-fonctionnent-pas-7438
            case "$LANG" in
                fr*)    echo -e "« Je n'ai pas échoué. J'ai simplement trouvé 10 000 solutions qui ne fonctionnent pas. »    \n\n— Thomas Edison    \n" ;;
                *)      echo -e "« I have not failed. I've just found 10,000 ways that won't work. »    \n\n— Thomas Edison    \n" ;;
            esac ;;
    esac > /tmp/quote.txt

    local XxY=$(xrandr 2>/dev/null | grep "Screen 0" | sed 's/.*current \(.*\) x \(.*\),.*/\1x\2/')
    if [ -z $XxY ]
    then
        if laptop-detect
        then
            XxY=1366x768
        else
            XxY=1920x1080
        fi
    fi

    python - <<EOF > /tmp/doc.txt
left = open("/home/$USERNAME/.i3/doc1.txt").read().splitlines()
right = open("/home/$USERNAME/.i3/doc2.txt").read().splitlines()
nbl = max(len(left), len(right))
left += [""]*(nbl-len(left))
right += [""]*(nbl-len(right))
print("")
print("    /-------------------------------------+")
print("    | K E Y B O A R D   S H O R T C U T S |")
print("    +-------------------------------------/")
print("")
print("    /----%-75s----+----%-75s----+"%("-"*75, "-"*75))
for i, (l, r) in enumerate(zip(left, right)):
    print("    |    %-75s    |    %-75s    |"%(l, r))
print("    +----%-75s----+----%-75s----/"%("-"*75, "-"*75))
EOF
    if laptop-detect
    then
        SIZE=12
    else
        SIZE=14
    fi
    sed -i 's/<\(policy .*pattern="@\*".*\)\/>/<!-- \1 -->/' /etc/ImageMagick-6/policy.xml
    convert -size ${XxY} -background black -fill green -font FreeMono-Gras          -pointsize  $((1*SIZE)) -gravity NorthWest label:@/tmp/doc.txt /tmp/doc.png
    convert -size ${XxY} -background black -fill blue  -font FreeMono-Gras-Italique -pointsize  $((2*SIZE)) -gravity SouthEast label:@/tmp/quote.txt /tmp/quote.png
    convert -size ${XxY} -background black -fill red   -font FreeMono-Gras          -pointsize          216 -gravity NorthWest label:LOCKED -rotate 30 /tmp/locked.png
    if laptop-detect
    then
        cp /tmp/doc.png /home/$USERNAME/.i3/wallpaper.png
    else
        composite -compose Add /tmp/doc.png /tmp/quote.png /home/$USERNAME/.i3/wallpaper.png
    fi
    convert /home/$USERNAME/.i3/wallpaper.png -blur 0x2 /tmp/blurred.png
    composite -compose Add /tmp/blurred.png /tmp/locked.png /home/$USERNAME/.i3/locked.png
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.i3
    feh --bg-center /home/$USERNAME/.i3/wallpaper.png
}

configure_wallpaper
