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

title "SSD and RAM optimisations"

ssd_optimizations()
{
    sed -i '/# SSD optimizations/,/# end of optimizations/d' /etc/fstab
    $SSD || return

    # SSD optimisation: http://doc.ubuntu-fr.org/ssd_solid_state_drive
    log "SSD optimizations"
    [ -e /etc/fstab.orig ] || cp /etc/fstab /etc/fstab.orig
    if ! grep -q 'noatime,discard' /etc/fstab
    then
        sed -i 's#\( /  *ext4  *\)#\1noatime,discard,#' /etc/fstab
        sed -i 's#\( /home  *ext4  *\)#\1noatime,discard,#' /etc/fstab
        sed -i 's#\( /boot  *ext2  *\)#\1noatime,discard,#' /etc/fstab
    fi

    # Temporary directory to RAM
    log "RAM optimizations"
    cat <<EOF >> /etc/fstab

# SSD optimizations
tmpfs   /tmp                        tmpfs   defaults,size=2g    0   0
tmpfs   /var/log                    tmpfs   defaults,nosuid,nodev,noatime,mode=0755,size=5%     0   0
#tmpfs   /var/cache/apt/archives     tmpfs   defaults,size=2g    0    0
tmpfs   /home/$USERNAME/.cache      tmpfs   defaults,size=1g    0    0
# end of optimizations
EOF
    chmod 644 /etc/fstab
    aptitude clean
    rm -rf /tmp/* /var/log/* /var/cache/apt/archives/* /home/$USERNAME/.cache/*

    # Firefox cache in RAM
    log "Firefox cache in RAM"
    for prefs in $(ls /home/$USERNAME/.mozilla/firefox/*/prefs.js)
    do
        echo "user_pref(\"browser.cache.disk.parent_directory\", \"/tmp\");" >> $prefs
    done

    # RAM disk compression
    # https://wiki.debian.org/ZRam
    cat <<\EOF > /etc/init.d/zram
#!/bin/sh
### BEGIN INIT INFO
# Provides:          zram
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     S
# Default-Stop:      0 1 6
# Short-Description: Use compressed RAM as in-memory swap
# Description:       Use compressed RAM as in-memory swap
### END INIT INFO

# Author: Antonio Galea <antonio.galea@gmail.com>
# Thanks to Przemysław Tomczyk for suggesting swapoff parallelization

FRACTION=75

MEMORY=`perl -ne'/^MemTotal:\s+(\d+)/ && print $1*1024;' < /proc/meminfo`
CPUS=`grep -c processor /proc/cpuinfo`
SIZE=$(( MEMORY * FRACTION / 100 / CPUS ))

case "$1" in
  "start")
    param=`modinfo zram|grep num_devices|cut -f2 -d:|tr -d ' '`
    modprobe zram $param=$CPUS
    for n in `seq $CPUS`; do
      i=$((n - 1))
      echo $SIZE > /sys/block/zram$i/disksize
      mkswap /dev/zram$i
      swapon /dev/zram$i -p 10
    done
    # added by Christophe Delord
    # some softs expect their directories to be created
    if [ -d /var/log ] && ! [ -e /var/log/clamav/freshclam.log ]
    then
        mkdir -p /var/log/clamav/
        touch /var/log/clamav/freshclam.log
        chown clamav:adm /var/log/clamav/freshclam.log
        chmod 755 /var/log/clamav/
        chmod 640 /var/log/clamav/freshclam.log
    fi
    ;;
  "stop")
    for n in `seq $CPUS`; do
      i=$((n - 1))
      swapoff /dev/zram$i && echo "disabled disk $n of $CPUS" &
    done
    wait
    sleep .5
    modprobe -r zram
    ;;
  *)
    echo "Usage: `basename $0` (start | stop)"
    exit 1
    ;;
esac
EOF
    chmod +x /etc/init.d/zram
    insserv zram

}

ssd_optimizations
