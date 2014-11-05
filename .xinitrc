#!/bin/sh

# Workaround for libreoffice bug that causes xmonad to spin.
export SAL_USE_VCLPLUGIN=gen

. /etc/X11/xinit/xinitrc
