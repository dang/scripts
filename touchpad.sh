#!/bin/sh
#
# This script is an hotplug script for use with the various
# input devices plugins.
#
# The script is called with the arguments:
# -t [added|present|removed] <device name>
#       added ... device was just plugged in
#       present.. device was present at gnome-settings-daemon startup
#       removed.. device was just removed
# -i <device ID>
#       device ID being the XInput device ID
# <device name> The name of the device
#
# The script should return 0 if the device is to be
# ignored from future configuration.
#

args=`getopt "t:i:" $*`

set -- $args

while [ $# -gt 0 ]
do
    case $1 in
    -t)
        shift;
        type="$1"
        ;;
     -i)
        shift;
        id="$1"
        ;;
     --)
        shift;
        device="$@"
        break;
        ;;
    *)
        echo "Unknown option $1";
        exit 1
        ;;
    esac
    shift
done

if [ -z "$device" ]; then
	echo "No device"
	exit 1
fi

retval=1

case $type in
        added)
                echo "Device '$device' (ID=$id) was added"
                ;;
        present)
                echo "Device '$device' (ID=$id) was already present at startup"
                ;;
        removed)
                echo "Device '$device' (ID=$id) was removed"
		exit 1
                ;;
        *)
                echo "Unknown operation"
		exit 1
                ;;
esac

echo -n "$device: "

# If the device is a touchpad ...
if [[ -z "${device#*Touchpad*}" ]]; then
	echo -n "matched"
	# ... enable two-finger scrolling (vertical and horizontal) ...
	xinput set-prop "${device}" "Synaptics Two-Finger Scrolling" 1 1
	# ... fix tap order
	xinput set-prop "${device}" "Synaptics Tap Action" 0, 0, 0, 0, 1, 2, 3
	# ... Turn on palm detection
	xinput set-prop "${device}" "Synaptics Palm Detection" 1
	# We handled the touchpad
	retval=0
else
	echo -n "didn't match"
fi

echo ""

# All further processing will be disabled if $retval == 0
exit $retval
