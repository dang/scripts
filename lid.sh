#!/bin/bash
#
# Turn backlight on when lid opens
#
# Goes in /etc/acpi/lid.sh
#

if [ ! "$(cat /proc/acpi/button/lid/LID/state | grep open)" = "" ]; then
	vbetool dpms on
fi
