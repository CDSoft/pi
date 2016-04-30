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

    # Debug mode (single terminal, single thread)
    DEBUG_MODE=false

    # Force installation of everything everytimes
    FORCE=false

    AUTOLOGIN=true
    AUTOSTARTX=true

    XFLUX="-l 43.6042600 -g 1.4436700 -k 2000"

    LATEX=false
    XCAS=false
    HASKELL_PLATFORM=
    RUST=
    ATOM=
    LIBREOFFICE=
    DROPBOX=false
    HUBIC=false
    MEGA=false

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
        NAS=192.168.10.2
        DESKTOP=192.168.10.10
        LAPTOP=192.168.10.20
        LAPTOPWIFI=192.168.10.21
        PHONE=192.168.10.30
        RASPI3=192.168.10.40
        RASPI3WIFI=192.168.10.41
    )

    # Platform specific configurations
    if $X86_64
    then
        LATEX=true
        HASKELL_PLATFORM=https://haskell.org/platform/download/7.10.3/haskell-platform-7.10.3-unknown-posix-x86_64.tar.gz
        RUST=https://static.rust-lang.org/rustup.sh
        ATOM=https://atom-installer.github.com/v1.5.4/atom-amd64.deb
        LIBREOFFICE=5.0.5
        DROPBOX=true
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

# Debug mode (single terminal, single thread)
DEBUG_MODE=$DEBUG_MODE

# Force installation of everything everytimes
FORCE=$FORCE

AUTOLOGIN=$AUTOLOGIN
AUTOSTARTX=$AUTOSTARTX

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

    # Force debug mode when no X display is available
    if ! xterm -iconic -e exit
    then
        DEBUG_MODE=true
    fi
}

hardware_detection()
{
    X86_64=false
    X86=false
    case "$(uname -m)" in
        x86_64)     X86_64=true;;
        *)          error "Unknown architecture" ;;
    esac
}

load_configuration
