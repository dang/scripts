# fvwm
# gnome-session

#
# awesome

eval $(dbus-launch --exit-with-session --sh-syntax)
/usr/libexec/gconfd-2 &
/usr/libexec/gnome-settings-daemon &

eval $(/usr/bin/gnome-keyring-daemon)
export GNOME_KEYRING_SOCKET
export SSH_AUTH_SOCK
export GNOME_KEYRING_PID

/usr/libexec/gnome-volume-manager &
/usr/bin/gnome-power-manager &
#ck-launch-session &
#nm-applet &
nautilus --no-default-window &
awesome > output.dfg 2>&1
