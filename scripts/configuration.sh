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

    TIMEZONE=Europe/Paris

    XFLUX="-l 43.6042600 -g 1.4436700 -k 2000"

    LATEX=false
    XCAS=false
    HASKELL=false
    OCAML=false
    RUST=false
    ATOM=false
    OFFICE=false
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
        NAS=$SUBNET.2
        DESKTOP=$SUBNET.10
        LAPTOP=$SUBNET.20
        LAPTOPETH=$SUBNET.21
        PHONE=$SUBNET.30
        RPI=$SUBNET.40
        RPIETH=$SUBNET.41
    )

    # Platform specific configurations
    if $I64
    then
        LATEX=true
        HASKELL=true
        OCAML=true
        RUST=true
        ATOM=true
        OFFICE=true
        DROPBOX=true
        #MEGA=true
        #HUBIC=true
        BLUETOOTH=true
    fi
    if $I32
    then
        LATEX=true
        HASKELL=true
        OCAML=true
        RUST=true
        OFFICE=true
        DROPBOX=true
        #MEGA=true
        #HUBIC=true
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

# TIMEZONE shall be a file located in /usr/share/zoneinfo
TIMEZONE=$TIMEZONE

XFLUX="$XFLUX"

LATEX=$LATEX
XCAS=$XCAS
HASKELL=$HASKELL
RUST=$RUST
ATOM=$ATOM
OFFICE=$OFFICE
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
        arm*)       RPI=true ;; # ARM (assumed to be a Raspberry Pi)
        *)          error "Unknown architecture" ;;
    esac
}

load_configuration
