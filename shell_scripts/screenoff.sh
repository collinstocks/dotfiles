#!/bin/bash

while true
do
    sleep 120
    case "$(cinnamon-screensaver-command -q | egrep -o '\bactive\b|\binactive\b')" in
        "active")
            echo "active"
            xset dpms force off
        ;;
        "inactive")
            echo "inactive"
        ;;
    esac
done
