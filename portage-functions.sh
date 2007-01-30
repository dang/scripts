#!/bin/bash
#
# Useful functions and setup for scripts dealing with portage.
#
# Needs: herdstat
#
# Note: this sources make.conf and make.defaults
#

#
# Fake functions to allow ebuild sourcing
function inherit() {
	true
}

# Fallback defaults
DISTDIR="/usr/portage/distfiles"
PORTDIR="/usr/portage"

# Get info from make.conf
source /etc/make.conf

# Get PORTDIR.  First, see if the PWD is in one of the directories in ${PORTDIR}
# or ${PORTDIR_OVERLAY}  If it is, use that as PORTDIR.  Otherwise, fall back on
# PORTDIR specified in /etc/make.conf, or on the default above.
for i in ${PORTDIR} ${PORTDIR_OVERLAY}; do
	MY_PORTDIR=`echo ${PWD} | /bin/grep -Fo "${i}"`
	if [ -n "${MY_PORTDIR}" ]; then
		PORTDIR=${MY_PORTDIR}
		break;
	fi
done

#
# cd to a package location by name in a portdir
function portcd() {
	PORTCD_PWD=`pwd`
	PORTCD_HERDSTAT=`PORTDIR=${PORTDIR} herdstat -qf $*`
	for i in ${PORTCD_HERDSTAT}; do
		cd ${PORTDIR}/$i || die "couldn't cd to $i"
		if [ "${PORTCD_PWD}" == "${PWD}" ]; then
			PORTCD_FOUND="yes"
			break;
		elif [ -z "${PORTCD_MULTI}" ]; then
			PORTCD_MULTI="yes"
		else
			die "Multiple directories for $*"
		fi
	done
}

#
# Given that you are in a directory for a package, get the category of it and
# set it in PORT_CATEGORY
function port_category() {
	PORT_CATEGORY=$(basename $(dirname ${PWD}))
}
