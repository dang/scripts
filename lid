# Handle hte lid events
#
# scrpipt turns backlight on after open

event=button[ /]lid
action=/etc/acpi/lid.sh %e
