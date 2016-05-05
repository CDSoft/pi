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

install_ocaml()
{
    $OCAML || return

    title "Install Ocaml with opam"
    # Ocaml libraries (opam + https://opam.ocaml.org/packages/)
    if $FORCE || ! [ -x /home/$USERNAME/local/bin/opam ]
    then
        mkcd /home/$USERNAME/local/bin
        rm -f opam_installer.sh
        sudo -u $USERNAME wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh
        sudo -u $USERNAME sh ./opam_installer.sh /home/$USERNAME/local/bin
    fi
    . /home/$USERNAME/.opam/opam-init/init.sh > /dev/null 2> /dev/null
    sudo -u $USERNAME /home/$USERNAME/local/bin/opam update
    sudo -u $USERNAME /home/$USERNAME/local/bin/opam install \
            ocamlfind camlp4 \
            utop \
            omake \
            batteries \
            core
    sudo -u $USERNAME /home/$USERNAME/local/bin/opam upgrade

    mkdir -p /home/$USERNAME/.profiled
    cat <<\EOF > /home/$USERNAME/.profiled/ocaml.sh
# Ocaml
. $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
EOF
    perm ux /home/$USERNAME/.profiled

}

install_ocaml
