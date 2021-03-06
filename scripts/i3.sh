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

configure_i3()
{
    title "i3 configuration"

    mkdir -p /home/$USERNAME/.i3

    configure_i3config
    configure_i3status
    configure_fmmenu
    configure_menu

    perm ux /home/$USERNAME/.i3
    i3 reload
}

configure_i3config()
{
    log ".i3/config"
    cat <<\EOF > /home/$USERNAME/.i3/config
# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

# Generated by CDSoft's Post Install
# from the default configuration
# a few ideas taken from http://i3wm.org/docs/user-contributed/lzap-config.html
# and some more custom shortcuts.

# class                 border  backgr. text    indicator
client.focused          #4c7899 #285577 #ffffff #2e9ef4
client.focused_inactive #737373 #5f676a #ffffff #484e50
client.unfocused        #737373 #222222 #888888 #292d2e
client.urgent           #2f343a #900000 #ffffff #900000
client.background       #000000

# starts locked
#exec --no-startup-id i3lock -i ~/.i3/locked.png
#exec xautolock -notify 30 -notifier "notify-send 'Soon locked...'" -time 15 -locker 'i3lock -i ~/.i3/locked.png' &

set $alt Mod1
set $ctrl Control
set $win Mod4
set $mod Mod4

# Volume control
bindsym XF86AudioRaiseVolume exec "amixer set Master 500+"
bindsym XF86AudioLowerVolume exec "amixer set Master 500-"
bindsym XF86AudioMute exec "amixer set Master toggle"

# Brightness
#bindcode 232 exec brightness -5
#bindcode 233 exec brightness +5
bindsym XF86MonBrightnessDown exec brightness -5
bindsym XF86MonBrightnessUp   exec brightness +5

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
font pango:DejaVu Sans Mono 8
# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
#bindsym $mod+Return exec i3-sensible-terminal
bindsym $mod+Return exec urxvt -cd "`xcwd`"

# Filemanagers
bindsym $mod+Ctrl+Return exec doublecmd "`xcwd`" "`xcwd`"
bindsym $mod+$alt+Return exec fmmenu

# scratchpad
bindsym $mod+Shift+o    move scratchpad
bindsym $mod+o          scratchpad show

# some useful shortcuts

bindsym $mod+space              exec ~/bin/menu

bindsym $mod+w                  exec chromium
bindsym $mod+t                  exec gvim ~/todo.txt
bindsym $mod+n                  exec gvim ~/notes.txt
bindsym $mod+p                  exec [ -e ~/secret.pwd ] && gvim ~/secret.pwd || gvim -x ~/secret.pwd
bindsym $mod+equal              exec urxvt +sb -T hCalc -e rlwrap ~/bin/hcalc
bindsym $mod+c                  exec urxvt +sb -T hCalc -e rlwrap ~/bin/hcalc
bindsym Print                   exec scrot '/tmp/%Y%m%d-%H%M%S.png' -e 'gimp $f'
bindsym $win+Print              exec scrot '/tmp/%Y%m%d-%H%M%S.png' -b -u -e 'gimp $f'
bindsym $mod+i                  exec ~/bin/ifmenu

#bindsym $mod+l                  exec i3lock -i ~/.i3/locked.png
bindsym $mod+Pause              exec sudo pm-hibernate
bindsym $mod+Delete             exec urxvt -T Bye +sb -geometry 78x17 -rv -e ~/bin/bye
bindsym $alt+$ctrl+Delete       exec urxvt -T Bye +sb -geometry 78x17 -rv -e ~/bin/bye

# custom window settings
for_window [window_role="pop-up"]                   floating enable
for_window [window_role="task_dialog"]              floating enable
for_window [title="^Bye$"]                          floating enable, border 1pixel
for_window [title="^Network interface chooser$"]    floating enable, border 1pixel
for_window [title="^QEMU"]                          floating enable
for_window [title="^hCalc$"]                        floating enable
for_window [class="^URxvt$" instance="scratchpad"]  border 1pixel; move scratchpad
for_window [title="% Copying"]                      floating enable
for_window [title="% Moving"]                       floating enable
for_window [title="% Extracting"]                   floating enable
for_window [title="Contrôle du volume"]             floating enable

# kill focused window
bindsym $mod+q          kill
bindsym $alt+F4         kill

# start dmenu (a program launcher)
bindsym $mod+Escape  exec dmenu_run

# change focus
#bindsym $mod+j focus left
#bindsym $mod+k focus down
#bindsym $mod+l focus up
#bindsym $mod+m focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
#bindsym $mod+Shift+j move left
#bindsym $mod+Shift+k move down
#bindsym $mod+Shift+l move up
#bindsym $mod+Shift+m move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h
#bindsym $mod+Control+Left   split h
#bindsym $mod+Control+Right  split h

# split in vertical orientation
bindsym $mod+v split v
#bindsym $mod+Control+Up     split v
#bindsym $mod+Control+Down   split v

# enter fullscreen mode for the focused container
#bindsym $mod+F11 fullscreen
bindsym $mod+m   fullscreen

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+z layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+f floating toggle

# change focus between tiling / floating windows
bindsym $mod+less focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
bindsym $mod+Shift+a focus child

# switch to workspace
bindsym $mod+ampersand  workspace 1
bindsym $mod+eacute     workspace 2
bindsym $mod+quotedbl   workspace 3
bindsym $mod+apostrophe workspace 4
bindsym $mod+parenleft  workspace 5
bindsym $mod+minus      workspace 6
bindsym $mod+egrave     workspace 7
bindsym $mod+underscore workspace 8
bindsym $mod+ccedilla   workspace 9
bindsym $mod+agrave     workspace 10
bindsym $mod+F1         workspace 1
bindsym $mod+F2         workspace 2
bindsym $mod+F3         workspace 3
bindsym $mod+F4         workspace 4
bindsym $mod+F5         workspace 5
bindsym $mod+F6         workspace 6
bindsym $mod+F7         workspace 7
bindsym $mod+F8         workspace 8
bindsym $mod+F9         workspace 9
bindsym $mod+F10        workspace 10
bindsym $mod+F11        workspace 11
bindsym $mod+F12        workspace 12

# move focused container to workspace
bindsym $mod+Shift+ampersand    move container to workspace 1
bindsym $mod+Shift+eacute       move container to workspace 2
bindsym $mod+Shift+quotedbl     move container to workspace 3
bindsym $mod+Shift+apostrophe   move container to workspace 4
bindsym $mod+Shift+5            move container to workspace 5
bindsym $mod+Shift+minus        move container to workspace 6
bindsym $mod+Shift+egrave       move container to workspace 7
bindsym $mod+Shift+underscore   move container to workspace 8
bindsym $mod+Shift+ccedilla     move container to workspace 9
bindsym $mod+Shift+agrave       move container to workspace 10
bindsym $mod+Shift+F1           move container to workspace 1
bindsym $mod+Shift+F2           move container to workspace 2
bindsym $mod+Shift+F3           move container to workspace 3
bindsym $mod+Shift+F4           move container to workspace 4
bindsym $mod+Shift+F5           move container to workspace 5
bindsym $mod+Shift+F6           move container to workspace 6
bindsym $mod+Shift+F7           move container to workspace 7
bindsym $mod+Shift+F8           move container to workspace 8
bindsym $mod+Shift+F9           move container to workspace 9
bindsym $mod+Shift+F10          move container to workspace 10
bindsym $mod+Shift+F11          move container to workspace 11
bindsym $mod+Shift+F12          move container to workspace 12

# next/previous workspace
bindsym $alt+Tab            workspace back_and_forth
bindsym $mod+Tab            workspace back_and_forth
bindsym $alt+$ctrl+Left     workspace prev
bindsym $alt+$ctrl+Right    workspace next

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
    # These bindings trigger as soon as you enter the resize mode

    # Pressing left will shrink the window’s width.
    # Pressing right will grow the window’s width.
    # Pressing up will shrink the window’s height.
    # Pressing down will grow the window’s height.
    #bindsym j resize shrink width 10 px or 10 ppt
    #bindsym k resize grow height 10 px or 10 ppt
    #bindsym l resize shrink height 10 px or 10 ppt
    #bindsym m resize grow width 10 px or 10 ppt

    # same bindings, but for the arrow keys
    bindsym Left resize shrink width 10 px or 10 ppt
    bindsym Down resize grow height 10 px or 10 ppt
    bindsym Up resize shrink height 10 px or 10 ppt
    bindsym Right resize grow width 10 px or 10 ppt

    # back to normal: Enter or Escape
    bindsym Return mode "default"
    bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

focus_follows_mouse no
force_focus_wrapping no
workspace_auto_back_and_forth yes

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
    position          bottom
    status_command    i3status -c ~/.i3/status
    #status_command    ~/.i3/status+.py
    colors {
        background  #000000
        statusline  #ffffff
        separator   #737373
        focused_workspace  #4c7899 #285577 #ffffff
        active_workspace   #737373 #5f676a #ffffff
        inactive_workspace #737373 #222222 #888888
        urgent_workspace   #2f343a #900000 #ffffff
    }
}

# Autostart some applications

exec --no-startup-id feh --bg-center ~/.i3/wallpaper.png
exec --no-startup-id urxvt -name scratchpad -e bash
exec --no-startup-id volumeicon

# Start firefox on workspace 9, then switch back to workspace 1
#exec --no-startup-id i3-msg 'workspace 9; exec firefox; workspace 1'
# Start claws-mail on workspace 8, then switch back to workspace 1
#exec --no-startup-id i3-msg 'workspace 8; exec claws-mail; workspace 1'

EOF

    if $I32 || $RPI
    then
        sed -i '/hcalc/d' /home/$USERNAME/.i3/config
    fi

    if ! which xcwd > /dev/null
    then
        log "Install xcwd"
        cd /tmp
        git clone https://github.com/schischi-a/xcwd.git
        cd xcwd
        make
        make install
    fi

    log "create brightness script"
    cat <<\EOF > /home/$USERNAME/bin/brightness
#!/bin/bash

MIN=5
MAX=100

backlight=`echo /sys/class/backlight/*/`

if ! [ -e $backlight/brightness ]
then
    echo "no backlight configuration in /sys/class"
    exit 1
fi

echo "Brightness configuration: $backlight"

cur=`cat $backlight/brightness`
max=`cat $backlight/max_brightness`
cur_p=$((100*cur/max))
echo "Current brightness      : $cur_p %"

set_brightness()
{
    new_p=$1
    if [ $new_p -lt $MIN ]; then new_p=$MIN; fi
    if [ $new_p -gt $MAX ]; then new_p=$MAX; fi
    new=$((max*new_p/100))
    echo "New brightness          : $new_p %"
    echo $new > $backlight/brightness
}

case "$1" in
    \+*|\-*)    set_brightness $(($cur_p$1)) ;;
    ?*)         set_brightness $1 ;;
esac
EOF
    perm ux /home/$USERNAME/bin/brightness

}

configure_i3status()
{
    cat <<\EOF > /home/$USERNAME/.i3/status
general {
    output_format = "i3bar"
    colors = true
    interval = 5
}

#order += "ipv6"
#order += "disk /"
#order += "disk /home"
#order += "run_watch DHCP"
#order += "run_watch VPNC"
#order += "path_exists VPN"
#order += "wireless wlan0"
order += "ethernet eth0"
#order += "battery 0"
#order += "cpu_temperature 0"
order += "cpu_usage"
order += "load"
#order += "volume master"
order += "time"
#order += "tztime paris"

wireless wlan0 {
    format_up = "W: (%quality at %essid, %bitrate) %ip"
    #format_down = "W: down"
}

ethernet eth0 {
    # if you use %speed, i3status requires the cap_net_admin capability
    #format_up = "E: %ip (%speed)"
    format_up = "E: %ip"
    #format_down = "E: down"
}

battery 0 {
    format = "%status %percentage %remaining %emptytime"
    #format_down = "No battery"
    path = "/sys/class/power_supply/BAT%d/uevent"
    #low_threshold = 10
}

run_watch DHCP {
    pidfile = "/var/run/dhclient*.pid"
}

run_watch VPNC {
    # file containing the PID of a vpnc process
    pidfile = "/var/run/vpnc/pid"
}

#path_exists VPN {
#    # path exists when a VPN tunnel launched by nmcli/nm-applet is active
#    path = "/proc/sys/net/ipv4/conf/tun0"
#}

time {
    #format = "%A %e %B %Y - %H:%M:%S"
    format = "%A %e %B %Y - %H:%M"
}

#tztime paris {
#    format = "%A %e %B %Y - %H:%M:%S %Z"
#    timezone = "Europe/Paris"
#}

cpu_usage {
    format = "%usage"
}

load {
    format = "%5min"
}

cpu_temperature 0 {
    format = "T: %degrees °C"
    path = "/sys/devices/platform/coretemp.0/temp1_input"
}

disk "/" {
    format = "/: %free"
}

disk "/home" {
    format = "~: %free"
}

volume master {
        format = "♪: %volume"
        device = "default"
        mixer = "Master"
        mixer_idx = 0
}
EOF
    if laptop-detect
    then
        sed -i 's/#order += "wireless wlan0"/order += "wireless wlan0"/' /home/$USERNAME/.i3/status
        sed -i 's/#order += "battery 0"/order += "battery 0"/' /home/$USERNAME/.i3/status
    fi
    if $RPI
    then
        sed -i 's/#order += "wireless wlan0"/order += "wireless wlan0"/' /home/$USERNAME/.i3/status
    fi

    cat <<\EOF > /home/$USERNAME/.i3/status+.py
#!/usr/bin/python
#
# Hacked from http://code.stapelberg.de/git/i3status/tree/contrib/wrapper.py
# Initial credits go to Valentin Haenel
#
# 2013 syl20bnr <sylvain.benner@gmail.com>
#
# This program is free software. It comes without any warranty, to the extent
# permitted by applicable law. You can redistribute it and/or modify it under
# the terms of the Do What The Fuck You Want To Public License (WTFPL), Version
# 2, as published by Sam Hocevar. See http://sam.zoy.org/wtfpl/COPYING for more
# details.

# modified by C. Delord to restart in case of exception

from subprocess import Popen, PIPE
import sys
import re
import json
import time

I3STATUS_CMD = 'i3status -c ~/.i3/status'
LED_STATUSES_CMD = 'xset q | grep "LED mask"'
LED_MASKS = [
    ('caps', 0b0000000001, 'CAPS', '#DC322F'),
    ('num', 0b0000000010, 'NUM', '#859900'),
    ('scroll', 0b0000000100, 'SCROLL', '#2AA198'),
    ('altgr', 0b1111101000, 'ALTGR', '#B58900')]


def get_led_statuses():
    ''' Return a list of dictionaries representing the current keyboard LED
statuses '''
    try:
        p = Popen(LED_STATUSES_CMD, stdout=PIPE, shell=True)
        mask = re.search(r'[0-9]{8}', p.stdout.read())
        if mask:
            v = int(mask.group(0))
            return [to_dict(n, t, c) for n, m, t, c in reversed(LED_MASKS)
                    if v & m]
    except Exception:
        return ''


def to_dict(name, text, color):
    ''' Returns a dictionary with given information '''
    return {'full_text': text, 'name': name, 'color': color}


def print_line(message):
    ''' Non-buffered printing to stdout. '''
    sys.stdout.write(message + '\n')
    sys.stdout.flush()


def read_line(process):
    ''' Interrupted respecting reader for stdin. '''
    try:
        line = process.stdout.readline().strip()
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()


if __name__ == '__main__':
    while True:
        try:
            p = Popen(I3STATUS_CMD, stdout=PIPE, shell=True)
            # waiting 1 second to get the first lines
            time.sleep(1)
            if p.poll() is None:
                # Skip the first line which contains the version header.
                print_line(read_line(p))
                # The second line contains the start of the infinite array.
                print_line(read_line(p))
            while p.poll() is None:
                line, prefix = read_line(p), ''
                # ignore comma at start of lines
                if line.startswith(','):
                    line, prefix = line[1:], ','
                # prepend led statuses
                j = json.loads(line)
                leds = get_led_statuses()
                [(lambda x: j.insert(0, x))(x) for x in leds]
                # and echo back new encoded json
                print_line(prefix+json.dumps(j))
        except:
            import traceback
            exc = " | ".join(line.strip() for line in traceback.format_exc(limit=1).splitlines())
            exc = exc.replace('"', "'")
            print_line('{"color":"#FF0000", "name":"exc", "full_text":"%s"}'%(exc))
            time.sleep(10)
EOF
    chmod +x /home/$USERNAME/.i3/status+.py
}

configure_fmmenu()
{
    log "filemanager chooser (fmmenu)"
    mkdir -p /home/$USERNAME/bin
    cat <<\EOF > /home/$USERNAME/bin/fmmenu
#!/bin/bash

FM=$(cat <<\EndOfMenu | dmenu -l 5 -p "File manager" \
                        -fn "-*-lucidatypewriter-*-*-*-*-26-*-*-*-*-*-*-*" \
                        -nb cyan -nf black -sb white -sf black
Double Commander
Midnight Commander
PCManFM
ROX-Filer
EndOfMenu
)

case "$FM" in
    "Double Commander")     doublecmd "`xcwd`" "`xcwd`";;
    "Midnight Commander")   urxvt -e mc "`xcwd`" "`xcwd`";;
    "PCManFM")              pcmanfm "`xcwd`";;
    "ROX-Filer")            rox "`xcwd`";;
esac
EOF
    perm ux /home/$USERNAME/bin/fmmenu

}

configure_menu()
{
    log "menu script"
    mkdir -p /home/$USERNAME/bin
    cat <<\EOF > /home/$USERNAME/bin/menu
#!/bin/dash
case $(awk '$1 ~ /\)$/ {print substr($1,1,length($1)-1)}' $0 | dmenu -i -b -p Menu) in
    mail)           icedove ;;
    web)            chromium ;;
    hoogle)         surf https://www.haskell.org/hoogle/ ;;
    scan)           simple-scan ;;
    calc)           urxvt +sb -T hCalc -e rlwrap ~/bin/hcalc ;;
    vlc)            vlc ;;
    libreoffice)    /usr/local/bin/libreoffice*.* ;;
esac
EOF
    which simple-scan > /dev/null || sed -i '/simple-scan/d' /home/$USERNAME/bin/menu
    $OFFICE || sed -i '/libreoffice/d' /home/$USERNAME/bin/menu
    if $I32 || $RPI
    then
        sed -i '/icedove/d' /home/$USERNAME/bin/menu
        sed -i '/hcalc/d' /home/$USERNAME/bin/menu
    fi
    perm ux /home/$USERNAME/bin/menu

}

configure_i3
