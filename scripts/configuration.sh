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

PIRC=.pirc

load_configuration()
{
    title "Load configuration"
    hardware_detection
    load_default_configuration
    generate_user_configuration
    load_user_configuration
}

load_default_configuration()
{
    log "Load default configuration"

    # Force installation of everything everytimes
    FORCE=false

    AUTOLOGIN=true
    AUTOSTARTX=true
    KEYBOARD=${LANG:0:2}

    XFLUX="-l 43.6042600 -g 1.4436700 -k 2000"

    LATEX=false
    XCAS=false
    HASKELL_PLATFORM=
    RUST=
    ATOM=
    LIBREOFFICE=
    DROPBOX=
    HUBIC=
    MEGA=

    # let SSD be true if you have a SSD or if you want to use the RAM to optimize temporary directories
    SSD=true

    BLUETOOTH=false

    # NAS must be defined in IPs
    NAS_MOUNTPOINT=/mnt/NAS

    # Wifi
    SSIDs=(
        NAME1/SSID1/WPAKEY1
        NAME2/SSID2/WPAKEY2
    )

    # Local network
    SUBNET=192.168.10
    IPs=(
        NAS=$SUBNET.2
        DESKTOP=$SUBNET.10
        LAPTOP=$SUBNET.20
        LAPTOPWIFI=$SUBNET.21
        PHONE=$SUBNET.30
        RASPI3=$SUBNET.40
        RASPI3WIFI=$SUBNET.41
    )

    # Platform specific configurations
    if $I64
    then
        LATEX=true
        HASKELL_PLATFORM=https://haskell.org/platform/download/7.10.3/haskell-platform-7.10.3-unknown-posix-x86_64.tar.gz
        RUST=https://static.rust-lang.org/rustup.sh
        ATOM=https://atom-installer.github.com/v1.7.3/atom-amd64.deb
        LIBREOFFICE=5.1.2
        DROPBOX=https://www.dropbox.com/download?plat=lnx.x86_64
        #MEGA=https://mega.nz/linux/MEGAsync/Debian_8.0/amd64/megasync-Debian_8.0_amd64.deb
        #HUBIC=http://mir7.ovh.net/ovh-applications/hubic/hubiC-Linux/2.1.0/hubiC-Linux-2.1.0.53-linux.deb
        BLUETOOTH=true
    fi
    if $I32
    then
        LATEX=true
        HASKELL_PLATFORM=https://haskell.org/platform/download/7.10.3/haskell-platform-7.10.3-unknown-posix-i386.tar.gz
        RUST=https://static.rust-lang.org/rustup.sh
        LIBREOFFICE=5.1.2
        DROPBOX=https://www.dropbox.com/download?plat=lnx.x86
        #MEGA=https://mega.nz/linux/MEGAsync/Debian_8.0/i386/megasync-Debian_8.0_i386.deb
        #HUBIC=http://mir7.ovh.net/ovh-applications/hubic/hubiC-Linux/2.1.0/hubiC-Linux-2.1.0.53-linux.deb
        BLUETOOTH=true
    fi
    if $RPI
    then
        KEYBOARD=en
        XFLUX=
        BLUETOOTH=true
    fi

}

array()
{
    while [ $1 ]
    do
        echo "   $1"
        shift
    done
}

generate_user_configuration()
{
    [ -e /home/$USERNAME/$PIRC ] && return
    log "Generate user configuration"
    cat <<EOF > /home/$USERNAME/$PIRC
# Post install configuration
# Can be safely modified

# Force installation of everything everytimes
FORCE=$FORCE

AUTOLOGIN=$AUTOLOGIN
AUTOSTARTX=$AUTOSTARTX
KEYBOARD=$KEYBOARD

XFLUX="$XFLUX"

LATEX=$LATEX
XCAS=$XCAS
HASKELL_PLATFORM=$HASKELL_PLATFORM
RUST=$RUST
ATOM=$ATOM
LIBREOFFICE=$LIBREOFFICE
DROPBOX=$DROPBOX
HUBIC=$HUBIC
MEGA=$MEGA

# let SSD be true if you have a SSD or if you want to use the RAM to optimize temporary directories
SSD=$SSD

BLUETOOTH=$BLUETOOTH

# NAS must be defined in IPs
NAS_MOUNTPOINT=$NAS_MOUNTPOINT

# Wifi
SSIDs=(
$(array ${SSIDs[@]})
)

# Local network
SUBNET=$SUBNET
IPs=(
$(array ${IPs[@]})
)
EOF
    perm ux /home/$USERNAME/$PIRC
}

load_user_configuration()
{
    log "Load user configuration"
    . /home/$USERNAME/$PIRC
}

hardware_detection()
{
    I64=false
    I32=false
    RPI=false
    case "$(uname -m)" in
        x86_64)     I64=true ;; # 64 bit Intel
        i686)       I32=true ;; # 32 bit Intel
        arm*)       RPI=true ;; # ARM (assumed to be a Raspberry pi)
        *)          error "Unknown architecture" ;;
    esac
}

load_configuration
