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

configure_bluetooth()
{
    $BLUETOOTH || return
    ! [ -e /etc/bluetooth/audio.conf ] || return
    
    cat <<EOF > /etc/bluetooth/audio.conf
# Configuration file for the audio service

# This section contains options which are not specific to any
# particular interface
# NOTE: Enable=Sink means that bluetoothd exposes Sink interface for remote
# devices, and the local device is a Source
[General]
Enable=Sink,Control,Headset,Gateway,Source
#Enable=Gateway,Source,Socket

# Switch to master role for incoming connections (defaults to true)
Master=false

# If we want to disable support for specific services
# Defaults to supporting all implemented services
#Disable=Control,Source

# SCO routing. Either PCM or HCI (in which case audio is routed to/from ALSA)
# Defaults to HCI
#SCORouting=PCM

# Automatically connect both A2DP and HFP/HSP profiles for incoming
# connections. Some headsets that support both profiles will only connect the
# other one automatically so the default setting of true is usually a good
# idea.
AutoConnect=true

# Headset interface specific options (i.e. options which affect how the audio
# service interacts with remote headset devices)
#[Headset]

# Set to true to support HFP (in addition to HSP only which is the default)
# Defaults to false
#HFP=true

# Maximum number of connected HSP/HFP devices per adapter. Defaults to 1
#MaxConnections=1

# Set to true to enable use of fast connectable mode (faster page scanning)
# for HFP when incomming call starts. Default settings are restored after
# call is answered or rejected. Page scan interval is much shorter and page
# scan type changed to interlaced. Such allows faster connection initiated
# by a headset.
FastConnectable=false

# Just an example of potential config options for the other interfaces
[A2DP]
SBCSources=1
MPEG12Sources=0

[AVRCP]
InputDeviceName=AVRCP
EOF

}

configure_bluetooth
