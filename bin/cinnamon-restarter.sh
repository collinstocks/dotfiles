#!/bin/bash

while sleep 1; do
    if [ -e /tmp/restart-cinnamon ]; then
        sleep 10
        env cinnamon --replace &
        disown %
        sleep 5
        rm -f /tmp/restart-cinnamon
    fi
done
