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

configure_bye()
{
    title "shutdown script (bye)"

    mkdir -p /home/$USERNAME/bin

    cat <<\EOF > /home/$USERNAME/bin/bye
#!/usr/bin/env python

""" bye (C) Christophe Delord - cdsoft.fr/pi

'bye' is a simple suspend/shutdown/reboot script.
"""

SAMPLES = 6     # number of samples
PERIOD = 10     # sampling period

NET_THR = 10.0
CPU_THR = 0.5

MENU = [
    #("Suspend", "bash -c '(cd /tmp; nohup i3lock -i ~/.i3/locked.png )& sudo pm-hibernate'"),
    ("Suspend", "sudo pm-hibernate"),
    ("Halt",    "sudo /sbin/shutdown -h now"),
    ("Reboot",  "sudo /sbin/shutdown -r now"),
    ("Cancel",  None),
]

import curses, os, sys, time

def copyright(scr, X, Y):
    msg = "[ 'bye' (C) Christophe Delord - cdsoft.fr ]"
    scr.addstr(Y-1, X-len(msg)-2, msg, curses.A_DIM)

class Button:

    def __init__(self, name, cmd, scr, x1, y1, x2, y2):
        self.name = name
        self.cmd = cmd
        self.scr = scr
        self.x1, self.y1, self.x2, self.y2 = x1, y1, x2, y2

    def show(self, active):
        x1, y1, x2, y2 = self.x1, self.y1, self.x2, self.y2
        attr = active and curses.A_REVERSE+curses.A_BOLD or curses.A_NORMAL
        for x in range(x1+1, x2):
            self.scr.addch(y1, x, curses.ACS_HLINE)
            self.scr.addch(y2, x, curses.ACS_HLINE)
        for y in range(y1+1, y2):
            self.scr.addch(y, x1, curses.ACS_VLINE)
            self.scr.addch(y, x2, curses.ACS_VLINE)
            self.scr.addstr(y, x1+1, " "*(x2-x1-1), attr)
        self.scr.addch(y1, x1, curses.ACS_ULCORNER)
        self.scr.addch(y1, x2, curses.ACS_URCORNER)
        self.scr.addch(y2, x1, curses.ACS_LLCORNER)
        self.scr.addch(y2, x2, curses.ACS_LRCORNER)
        self.scr.addstr((y2+y1)/2, x1+1, self.name.center(x2-x1-2), attr)

    def inside(self, x, y):
        return self.x1 < x < self.x2 and self.y1 < y < self.y2

    def run(self):
        if self.cmd is None:
            sys.exit(0)
        else:
            os.system('sync')
            os.system(self.cmd)
        sys.exit(0)

class Probe:

    def __init__(self, scr, y, samples, thr):
        self.scr, self.y = scr, y
        self.load = []
        self.samples = samples
        self.thr = thr
        self.update()

    def show(self, action):
        state = "%s: %s (%s when < %s)"%(self.__class__.__name__, max(self.load), action, self.thr)
        loads = "[%s]"%(" ".join(self.fmt%x for x in self.load))
        self.scr.addstr(self.y, 5, state)
        self.scr.addstr(self.y+1, 5, loads)

    def update(self):
        new_load = self.compute()
        self.load = (self.load+[new_load])[-self.samples:]

    def idle(self):
        return len(self.load) >= self.samples and max(self.load) < self.thr

class Net(Probe):
    fmt = "%.1f"
    def compute(self):
        stat = open('/proc/net/netstat')
        load = 0.0
        for n in stat.read().split():
            try: load += float(n)
            except ValueError: pass
        stat.close()
        try:
            delta = load - self.prev
            self.prev = load
            return delta/1000.0
        except AttributeError:
            self.prev = load
            return 0.0

class Cpu(Probe):
    fmt = "%.2f"
    def compute(self):
        stat = open('/proc/loadavg')
        load = stat.read().split()[1]
        stat.close()
        return float(load)

def menu(scr):
    curses.use_default_colors()
    curses.mousemask(curses.BUTTON1_PRESSED+curses.BUTTON1_RELEASED)
    scr.timeout(PERIOD*1000)
    Y, X = scr.getmaxyx()
    N = len(MENU)
    bw = 12 # largeur d'un bouton
    mw = N*bw + (N-1)*bw/2 # largeur du menu complet
    top = 3
    left = (X-mw)/2
    buttons = [ Button(name, cmd,
                    scr,
                    left+i*(bw+bw/2), top,
                    left+i*(bw+bw/2)+bw, top+4)
                for i, (name, cmd) in enumerate(MENU)
    ]
    net = Net(scr, top+7, SAMPLES, NET_THR)
    cpu = Cpu(scr, top+10, SAMPLES, CPU_THR)
    selected = 0
    while True:
        scr.clear()
        scr.border()
        title = "[ B y e ]"
        scr.addstr(0, (X-len(title))/2, title, curses.A_BOLD)
        for i, b in enumerate(buttons):
            b.show(i==selected)
        net.show(buttons[selected].name)
        cpu.show(buttons[selected].name)
        copyright(scr, X, Y)
        ch = scr.getch()
        if ch in (curses.KEY_LEFT, curses.KEY_UP): selected = max(selected-1, 0)
        if ch in (curses.KEY_RIGHT, curses.KEY_DOWN): selected = min(selected+1, len(buttons)-1)
        if ch == 27: break
        if ch == 10: buttons[selected].run()
        if ch == curses.KEY_MOUSE:
            _id, x, y, z, bstate = curses.getmouse()
            for i, b in enumerate(buttons):
                if b.inside(x, y):
                    if bstate == curses.BUTTON1_PRESSED: selected = i
                    if bstate == curses.BUTTON1_RELEASED: b.run()
        if ch == -1:
            net.update()
            cpu.update()
            if net.idle() and cpu.idle():
                buttons[selected].run()

if __name__ == '__main__':
    if sys.stdin.isatty() and sys.stdout.isatty():
        curses.wrapper(menu)
    else:
        term = "xterm -class Bye -T Bye -geometry 78x17 -rv -e %s"
        bye = sys.argv[0]
        sys.exit(os.system(term%bye))
EOF
    perm ux /home/$USERNAME/bin/bye

}

configure_bye
