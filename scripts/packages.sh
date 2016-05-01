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

DISTRIB=jessie

packages()
{
    title "Update packages"
    package_repositories
    package_list
    package_install
}

add_rep()
{
    echo "$2" > /etc/apt/sources.list.d/$1.list
}

rem_rep()
{
    rm /etc/apt/sources.list.d/$1.list 2>/dev/null
}

add()
{
    NEW_PACKAGES+=" $*"
}

rem()
{
    REM_PACKAGES+=" $*"
}

add_exp()
{
    NEW_PACKAGES_EXPERIMENTAL+=" $*"
}

add_backport()
{
    NEW_PACKAGES_BACKPORTS+=" $*"
}

add_unstable()
{
    NEW_PACKAGES_UNSTABLE+=" $*"
}

package_repositories()
{
    log "Configure repositories"

    cat <<EOF > /etc/apt/apt.conf
APT::Default-Release "$DISTRIB";
EOF

    # Debian repositories
    cat <<EOF > /etc/apt/sources.list
deb http://ftp.fr.debian.org/debian/ $DISTRIB main contrib non-free
deb http://security.debian.org/ $DISTRIB/updates main contrib
deb http://ftp.fr.debian.org/debian/ $DISTRIB-updates main contrib non-free

#deb http://ftp.fr.debian.org/debian/ unstable main contrib non-free

deb http://http.debian.net/debian $DISTRIB-backports main contrib non-free
EOF

    # Additionnal repositories
    add_rep multimedia "deb http://www.deb-multimedia.org $DISTRIB main non-free"
    add_rep multimedia "deb http://www.deb-multimedia.org $DISTRIB-backports main non-free"
    #add_rep mozilla "deb http://mozilla.debian.net/ $DISTRIB-backports firefox-release"
    if $XCAS
    then
        add_rep xcas "deb http://www-fourier.ujf-grenoble.fr/~parisse/debian/ stable main"
        apt-key add xcas_public_key.gpg
    else
        rem_rep xcas
    fi

    # Double Commander
    add_rep doublecmd "deb http://download.opensuse.org/repositories/home:/Alexx2000/Debian_7.0/ /"
    (   cd /tmp
        wget http://download.opensuse.org/repositories/home:Alexx2000/Debian_7.0/Release.key
        apt-key add - < Release.key
    )

    # Additionnal packages
    NEW_PACKAGES=""
    NEW_PACKAGES_EXPERIMENTAL=""
    NEW_PACKAGES_BACKPORTS=""
    NEW_PACKAGES_UNSTABLE=""
    # Removed packages
    REM_PACKAGES=""

}


package_list()
{
    # system
    add sudo
    add bash dbus udisks notification-daemon libnotify-bin notify-osd zenity
    add htop
    add encfs gparted
    add_backport tcplay
    add pm-utils
    add qemu-system qemu-kvm
    add sqlite3
    add syslinux syslinux-utils syslinux-stuff syslinux-efi mbr
    add nfs-common autofs5 gvfs-bin
    add libfuse2 libdevmapper1.02.1
    add exfat-fuse
    add cups # localhost:631
    #add mtp-tools mtpfs
    add pwgen
    add dialog
    add firmware-linux-free
    add openssh-client openssh-server
    add sshfs
    add ntp #ntpdate
    add preload
    add_backport wireless-tools wpasupplicant firmware-iwlwifi
    #add_backport wicd
    $I64 && add_backport linux-image-amd64
    $I32 && add_backport linux-image-i386
    $RPI && add_backport linux-image-rpi

    # microcode
    case "$(grep vendor_id /proc/cpuinfo)" in
        *GenuineIntel)  add_backport intel-microcode ;;
    esac

    # see https://wiki.debian.org/BluetoothUser
    $BLUETOOTH && add bluetooth blueman d-feet pulseaudio-module-bluetooth

    # X
    add xserver-xorg xserver-xorg-core xinit xnest
    add xterm rxvt feh hsetroot
    add rxvt-unicode
    add fswebcam
    add numlockx
    add wmctrl xdotool scrot
    add gtk-theme-switch gtk2-engines
    add_backport dmenu i3lock suckless-tools surf dunst
    add xautolock
    #add fonts-anonymous-pro fonts-croscore fonts-humor-sans fonts-opendyslexic
    #add fonts-jsmath fonts-junction fonts-mathjax fonts-mathjax-extra
    #add fonts-roboto
    add consolekit

    # file managers
    add_backport mc pcmanfm rox-filer
    add doublecmd-gtk
    #add nautilus nautilus-open-terminal
    # add krusader kget krename konsole
    add shotwell gwenview
    add file-roller
    add p7zip p7zip-full p7zip-rar unrar upx xz-utils bzip2
    add libcdio-utils
    add libdiscid0-dev libcdio-dev libcdio-cdda-dev libcddb2-dev
    add cdparanoia

    # editors, text management
    add_backport vim-gtk
    $LATEX && add texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-full
    add figlet
    add python-docutils python3-docutils
    if $I64 || $I32 || [ -n $LIBREOFFICE ]
    then
        add_backport abiword abiword-plugin-grammar abiword-plugin-mathview
        add_backport gnumeric gnumeric-plugins-extra gnumeric-doc
        add ttf-liberation ttf-mscorefonts-installer
        add simple-scan
        add evince
        add wkhtmltopdf
    fi
    add dos2unix
    add iconv convmv

    # images
    if $I64 || $I32
    then
        add_backport gimp
        add_backport scribus inkscape
        add_backport gnuplot-qt
        add_backport imagemagick
    fi

    # video/music
    if $I64 || $I32
    then
        add vlc
        add easytag
        add libav-tools
        add qarte
        add alsa-utils volumeicon-alsa pavucontrol
        add audacity
        add libdvdread4 ogmrip
        add gtk-recordmydesktop
    fi

    # programming
    add python3 python3-tk git-core git-gui
    add lua5.1 liblua5.1-filesystem0
    add m4
    add nsis mingw32 mingw-w64 libreadline-dev gcc-multilib g++-multilib automake
    if $I64 || $I32
    then
        add codeblocks codeblocks-contrib
    fi
    add make
    add_backport swi-prolog
    add_backport libgc-dev
    add_backport libz-dev
    add_backport gpp graphviz mscgen ditaa
    add_backport rlwrap
    add_backport pkg-config ncurses-dev
    add adlint splint
    add libwxgtk3.0-dev libwxgtk-webview3.0-dev libwxgtk-media3.0-dev
    add meld

    # web
    add wget gftp xsltproc
    add wput
    add curl
    add_backport tidy
    if $I64 || $I32
    then
        add_backport icedove icedove-l10n-fr
        add chromium
    fi

    # fun
    add fortunes fortunes-bofh-excuses fortunes-fr fortunes-min

    # wine
    if $I64 || $I32
    then
        add wine winetricks
        $I64 && dpkg --add-architecture i386 && add wine32
    fi

    # i3
    add_backport i3

    # Mega
    [ -n "$MEGA" ] && add libc-ares2 libcrypto++9

    # Xcas
    if $XCAS
    then
        add giac python-giacpy
    #else
    #    rem giac python-giacpy
    fi

}

package_install()
{
    # Installation of the new packages
    log "update packages"
    ARCHIVE_SIZE=$(du -m /var/cache/apt/archives | tail -1 | awk '{print $1}')
    [ $ARCHIVE_SIZE -ge 4096 ] && logrun aptitude clean
    logrun aptitude update
    logrun aptitude autoclean
    [ -n "$REM_PACKAGES" ] && logrun aptitude remove $REM_PACKAGES
    logrun aptitude install $NEW_PACKAGES
    [ -n "$NEW_PACKAGES_EXPERIMENTAL" ] && logrun aptitude install -t experimental $NEW_PACKAGES_EXPERIMENTAL
    [ -n "$NEW_PACKAGES_BACKPORTS" ]    && logrun aptitude install -t $DISTRIB-backports $NEW_PACKAGES_BACKPORTS
    [ -n "$NEW_PACKAGES_UNSTABLE" ]     && logrun aptitude install -t unstable $NEW_PACKAGES_UNSTABLE
    logrun aptitude full-upgrade
}

packages
