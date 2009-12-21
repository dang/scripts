# fvwm
# gnome-session

#
# awesome

eval $(dbus-launch --exit-with-session --sh-syntax)
/usr/libexec/gconfd-2 &
/usr/libexec/gnome-settings-daemon &
/usr/bin/gnome-keyring-daemon &
/usr/libexec/gnome-volume-manager &
/usr/bin/gnome-power-manager &
nm-applet &
nautilus --no-default-window &
awesome > output.dfg 2>&1
