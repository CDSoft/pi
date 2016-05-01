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

title "Network configuration"

configure_network_interfaces()
{
    log "Configure network interfaces"
    # see https://www.debian.org/doc/manuals/debian-reference/ch05.en.html
    cat <<EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
#auto eth0
iface eth0 inet dhcp

#auto wlan0
iface wlan0 inet dhcp

EOF
    $RPI && sed -i 's/#auto wlan0/auto wlan0/s' /etc/network/interfaces
    for config in ${SSIDs[@]}
    do
        name=$(echo $config | awk -F "/" '{print $1}')
        ssid=$(echo $config | awk -F "/" '{print $2}')
        psk=$(echo $config | awk -F "/" '{print $3}')
        cat <<EOF >> /etc/network/interfaces
iface $name inet dhcp
    wpa-ssid $ssid
    wpa-psk $psk

EOF
    done
    chmod 0600 /etc/network/interfaces
    #adduser $USERNAME netdev
    #/etc/init.d/dbus reload
    #/etc/init.d/wicd start
}

configure_hosts()
{
    log "Configure /etc/hosts"
    sed -i "/$SUBNET\./d" /etc/hosts
    (   echo "# $SUBNET.* = local network"
        for nameip in ${IPs[@]}
        do
            name=$(echo $nameip | awk -F "=" '{print $1}' | tr "A-Z" "a-z")
            ip=$(echo $nameip | awk -F "=" '{print $2}')
            echo "${ip} ${name}"
        done
    ) >> /etc/hosts
}

configure_menu()
{
    title "network interface chooser (ifmenu)"

    mkdir -p /home/$USERNAME/bin
    cat <<\EOF > /home/$USERNAME/bin/ifmenu
#!/bin/bash

. $(dirname $0)/../.pirc

mkmenu()
{
    for config in ${SSIDs[@]}
    do
        name=$(echo $config | awk -F "/" '{print $1}')
        ssid=$(echo $config | awk -F "/" '{print $2}')
        printf "wlan0 : %-16s (SSID: %s)\n" "$name" "$ssid"
    done
    echo "eth0  : Ethernet"
    echo "none  : Disconnect"
}

IF=$(mkmenu | dmenu -l 4 -p "Network interface" \
                -fn "-*-lucidatypewriter-*-*-*-*-26-*-*-*-*-*-*-*" \
               -nb cyan -nf black -sb white -sf black
)

case "$IF" in
    eth0*)  sudo ifdown wlan0& sudo ifdown eth0; sudo ifup eth0 ;;
    wlan0*) sudo ifdown eth0& sudo ifdown wlan0; sudo ifup wlan0=$(echo "$IF" | awk '{print $3}') ;;
    none*)  sudo ifdown eth0& sudo ifdown wlan0& ;;
esac
wait
EOF
    perm ux /home/$USERNAME/bin/ifmenu

}

configure_network_interfaces
configure_hosts
configure_menu
