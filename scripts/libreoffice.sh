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

install_libreoffice()
{
    $OFFICE || return
    $I64 || $I32 || return

    LIBREOFFICE=5.1.2

    if $FORCE || ! [ -x /usr/local/bin/libreoffice* ]
    then
        title "Install Libre Office"
        rm -f /usr/local/bin/libreoffice*
        rm -rf /opt/libreoffice*
        cd /tmp
        case `uname -m` in
            x86_64) ARCH_=x86_64;   ARCH=x86-64;;
            *)      ARCH_=x86;      ARCH=x86;;
        esac
        wget http://ftp.free.fr/mirrors/documentfoundation.org/libreoffice/stable/${LIBREOFFICE}/deb/${ARCH_}/LibreOffice_${LIBREOFFICE}_Linux_${ARCH}_deb.tar.gz
        tar xzf LibreOffice_*_Linux_*_deb.tar.gz && (
            cd LibreOffice_*_Linux_*_deb/DEBS
            dpkg -i *.deb
        )
        case $LANG in
            fr*)    wget http://ftp.free.fr/mirrors/documentfoundation.org/libreoffice/stable/${LIBREOFFICE}/deb/${ARCH_}/LibreOffice_${LIBREOFFICE}_Linux_${ARCH}_deb_langpack_fr.tar.gz
                    wget http://ftp.free.fr/mirrors/documentfoundation.org/libreoffice/stable/${LIBREOFFICE}/deb/${ARCH_}/LibreOffice_${LIBREOFFICE}_Linux_${ARCH}_deb_helppack_fr.tar.gz
                    ;;
        esac
        tar xzf LibreOffice_*_Linux_*_deb_langpack_*.tar.gz && (
            cd LibreOffice_*_Linux_*_deb_langpack_*/DEBS
            dpkg -i *.deb
        )
        tar xzf LibreOffice_*_Linux_*_deb_helppack_*.tar.gz && (
            cd LibreOffice_*_Linux_*_deb_helppack_*/DEBS
            dpkg -i *.deb
        )
    fi
}

install_libreoffice
