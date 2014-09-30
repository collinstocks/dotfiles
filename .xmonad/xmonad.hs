{-# LANGUAGE
    DeriveDataTypeable,
    FlexibleContexts,
    FlexibleInstances,
    MultiParamTypeClasses,
    NoMonomorphismRestriction,
    PatternGuards,
    ScopedTypeVariables,
    TypeSynonymInstances,
    UndecidableInstances
    #-}
{-# OPTIONS_GHC -W -fwarn-unused-imports -fno-warn-missing-signatures #-}


import XMonad

-- Copied from navru
import qualified Data.Map as M
import qualified Data.List as L
import qualified XMonad.StackSet as W
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Grid
import XMonad.Layout.IndependentScreens
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.MultiToggle
import XMonad.Layout.Renamed
import XMonad.Layout.Reflect
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run
import XMonad.Util.WorkspaceCompare


-- import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops

import XMonad.Util.Run
import XMonad.Util.EZConfig

import System.IO


main = do
  killtrayer <- spawnPipe "killall trayer"
  trayer <- spawnPipe "sleep 0.1 && trayer --edge top --align right --widthtype request --height 14 --SetDockType true --SetPartialStrut true --monitor 1"
  xscreensaver <- spawnPipe "xscreensaver -no-splash"
  background <- spawnPipe "nitrogen --set-zoom-fill ~/Pictures/collection/dnb_united_states_lrg.jpg"
  gsettings <- spawnPipe "gnome-settings-daemon"
  keyboard <- spawnPipe "sleep 0.5 && setxkbmap -rules evdev -model pc104 -layout 'us,us' -variant ',dvorak' -option 'grp:alt_caps_toggle'"
  xmonad $ defaultConfig
    { borderWidth = 1
    , normalBorderColor = "#000000"
    , focusedBorderColor = "#00ffa0"
    , focusFollowsMouse = True
    , modMask = mod4Mask -- use the window key as the modkey
    , manageHook = manageDocks
    , startupHook = setWMName "LG3D"
    , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook <+> ewmhDesktopsEventHook
    , terminal = "gnome-terminal"
    , workspaces = withScreens 4 ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "<-"]
    , keys = \c -> myKeys c `M.union` keys defaultConfig c
    }


myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList
  $ [ ((0, 0x1008ff14), spawn "dbus-send --print-reply --dest=net.kevinmehall.Pithos /net/kevinmehall/Pithos net.kevinmehall.Pithos.PlayPause")
    , ((0, 0x1008ff17), spawn "dbus-send --print-reply --dest=net.kevinmehall.Pithos /net/kevinmehall/Pithos net.kevinmehall.Pithos.SkipSong")
    , ((0, 0x1008ff81), spawn "pithos")
    , ((mod4Mask, xK_F2), spawn "bash -lc $'source ~/.bashrc; command=$(compgen -ac | sort -u | dmenu -nb \"#000\" -nf \"#fff\" -sb \"#fff\" -sf \"#000\") && ($command || xmessage \"Error: \\\"$command\\\" returned exit status $?\")' ")
    , ((mod4Mask, xK_Escape), spawn "xscreensaver-command -l")
    , ((mod4Mask, xK_Caps_Lock), spawn "setxkbmap -rules evdev -model pc104 -layout 'us,us' -variant ',dvorak' -option 'grp:alt_caps_toggle'")
    ]
  ++ [((m .|. modm, k), windows $ f i)
     | (i, k) <- zip (XMonad.workspaces conf) [xK_grave, xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_minus, xK_equal, xK_BackSpace]
     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
     ]



