#!/bin/sh

echo 'ansible pikvm --become --module-name shell --args "/usr/bin/shutdown --reboot now" --background 60 --poll 0 --one-line'

ansible pikvm --become --module-name shell --args "/usr/bin/shutdown --reboot now" --background 60 --poll 0 --one-line