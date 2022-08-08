#!/bin/bash
# Credit for code:
   #https://unix.stackexchange.com/users/14353/cliff-stanford
   #https://unix.stackexchange.com/users/231160/nik-gnomic
# Post on stackexchange: https://unix.stackexchange.com/questions/467456/how-to-mute-sound-when-xscreensaver-locks-screen/589614#589614

gdbus monitor -y -d org.freedesktop.login1 | grep LockedHint --line-buffered |
    while read line
    do
        case "$line" in
            *"<true>"*)
                #amixer -q -D pulse sset Master off
                pactl set-sink-mute @DEFAULT_SINK@ toggle
            ;;
            *"<false>"*)
                #amixer -q -D pulse sset Master on
                pactl set-sink-mute @DEFAULT_SINK@ toggle
            ;;
        esac
    done
exit
